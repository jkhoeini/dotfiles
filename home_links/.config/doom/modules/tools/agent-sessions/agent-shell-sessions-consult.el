;;; agent-shell-sessions-consult.el --- Consult integration for agent-shell-sessions -*- lexical-binding: t -*-

;; Copyright (C) 2025 Mohammad Sadegh Khoeini
;; Author: Mohammad Sadegh Khoeini
;; URL: https://github.com/mkhoeini/agent-shell-sessions
;; Version: 0.1.0
;; Package-Requires: ((emacs "29.1") (agent-shell-sessions "0.1") (consult "1.0"))
;; Keywords: tools, processes

;;; Commentary:

;; Consult-based session picker for agent-shell-sessions.
;; Provides per-project grouped sources and a standalone switcher command.

;;; Code:

(require 'consult)
(require 'project)
(require 'agent-shell-sessions)

(declare-function agent-shell "agent-shell")
(declare-function agent-shell-resume-session "agent-shell")

(defvar agent-shell-sessions-consult--candidates (make-hash-table :test #'equal)
  "Map candidate string to session plist, rebuilt per invocation.")

(defvar agent-shell-sessions-consult--history nil
  "History for session consult prompts.")

(defun agent-shell-sessions-consult--make-items (archived-p &optional project-dir)
  "Build consult candidates from SQLite.
ARCHIVED-P selects archive status.  PROJECT-DIR limits to one project."
  (let ((live (agent-shell-sessions-live-buffers))
        (rows (if project-dir
                  (agent-shell-sessions-db-query-project project-dir archived-p)
                (sqlite-select (agent-shell-sessions-db)
                 "SELECT session_id, title, project_dir, updated_at, agent_type
                  FROM sessions WHERE archived = ? ORDER BY updated_at DESC"
                 (list (if archived-p 1 0))))))
    (cl-loop for row in rows
             for idx from 0
             for id = (nth 0 row)
             for title = (or (nth 1 row) "Untitled")
             for dir = (or (nth 2 row) "")
             for updated = (nth 3 row)
             for agent-type = (nth 4 row)
             for project = (if (string-empty-p dir) ""
                             (file-name-nondirectory
                              (directory-file-name dir)))
             collect
             (let* ((live-buf (cdr (assoc id live)))
                    (data (list :id id :title title :dir dir :updated updated
                                :agent-type agent-type :live-p (and live-buf t)))
                    (cand (propertize
                           (concat (truncate-string-to-width title 50 nil ?\s)
                                   (propertize (concat " " project)
                                               'face 'font-lock-comment-face)
                                   (consult--tofu-encode idx))
                           'agent-shell-session data)))
               (puthash cand data
                        agent-shell-sessions-consult--candidates)
               cand))))

(defun agent-shell-sessions-consult--db-lookup (id)
  "Look up session ID directly in the database, return a plist or nil."
  (when-let* ((row (car (sqlite-select (agent-shell-sessions-db)
                         "SELECT session_id, title, project_dir, updated_at, agent_type
                          FROM sessions WHERE session_id = ?"
                         (list id)))))
    (list :id (nth 0 row)
          :title (or (nth 1 row) "Untitled")
          :dir (or (nth 2 row) "")
          :updated (nth 3 row)
          :agent-type (nth 4 row)
          :live-p (and (agent-shell-sessions-find-live-buffer (nth 0 row)) t))))

(defun agent-shell-sessions-consult-session-data (cand)
  "Resolve CAND to a session plist.
Tries text property, hash table (with and without tofu suffix),
then direct DB lookup by session ID."
  (or (get-text-property 0 'agent-shell-session cand)
      (gethash cand agent-shell-sessions-consult--candidates)
      (when (> (length cand) 0)
        (gethash (substring cand 0 -1) agent-shell-sessions-consult--candidates))
      (agent-shell-sessions-consult--db-lookup cand)))

(defun agent-shell-sessions-consult-annotate (cand)
  "Annotate session CAND with age, agent type, and live status."
  (when-let* ((data (agent-shell-sessions-consult-session-data cand)))
    (let* ((updated (plist-get data :updated))
           (agent-type (plist-get data :agent-type))
           (live-p (plist-get data :live-p)))
      (concat (when agent-type
                (propertize (format " [%s]" agent-type)
                            'face 'font-lock-type-face))
              (propertize (format " %s" (agent-shell-sessions-relative-time updated))
                          'face 'font-lock-doc-face)
              (when live-p
                (propertize " ●" 'face 'success))))))

(defun agent-shell-sessions-consult--action (cand)
  "Resume or switch to session CAND."
  (when-let* ((data (agent-shell-sessions-consult-session-data cand)))
    (agent-shell-sessions-resume (plist-get data :id)
                                 (plist-get data :dir)
                                 (plist-get data :agent-type))))

(defun agent-shell-sessions-consult--action-unarchive (cand)
  "Resume session CAND and unarchive it."
  (when-let* ((data (agent-shell-sessions-consult-session-data cand)))
    (agent-shell-sessions-db-toggle-archive (plist-get data :id))
    (agent-shell-sessions-resume (plist-get data :id)
                                 (plist-get data :dir)
                                 (plist-get data :agent-type))))

(defun agent-shell-sessions-consult--current-project-source ()
  "Hidden consult source for the current project's sessions, narrow key ?p."
  (let ((dir (file-name-as-directory
              (expand-file-name
               (or (when-let* ((pr (project-current)))
                     (project-root pr))
                   default-directory)))))
    `(:name "Current project"
      :narrow (?p . "Current project")
      :hidden t
      :category agent-session
      :items ,(lambda ()
                (agent-shell-sessions-consult--make-items nil dir))
      :annotate ,#'agent-shell-sessions-consult-annotate
      :action ,#'agent-shell-sessions-consult--action)))

;;;###autoload
(defun agent-shell-sessions-consult-sources (archived-p)
  "Generate one consult source per project.
ARCHIVED-P selects archive status.  Sources share narrow key
?a (active) or ?x (archived)."
  (let ((projects (agent-shell-sessions-db-projects archived-p)))
    (cl-loop for row in projects
             for first = t then nil
             for dir = (nth 0 row)
             for project = (file-name-nondirectory (directory-file-name dir))
             collect
             `(:name ,(format "%s: %s" (if archived-p "Archived" "Sessions") project)
               :narrow ,(if archived-p ?x ?a)
               :category agent-session
               ,@(when (and first (not archived-p)) '(:default t))
               ,@(when archived-p '(:hidden t))
               :items ,(let ((d dir) (ap archived-p))
                         (lambda ()
                           (agent-shell-sessions-consult--make-items ap d)))
               :annotate ,#'agent-shell-sessions-consult-annotate
               :action ,(if archived-p
                            #'agent-shell-sessions-consult--action-unarchive
                          #'agent-shell-sessions-consult--action)
               ,@(unless archived-p
                   `(:new ,(let ((d dir))
                             (lambda (_input)
                               (let ((default-directory d))
                                 (agent-shell))))))))))

;;;###autoload
(defun agent-shell-sessions-consult-switcher ()
  "Browse and resume agent-shell sessions."
  (interactive)
  (unless (sqlite-available-p) (user-error "SQLite not available"))
  (clrhash agent-shell-sessions-consult--candidates)
  (consult--multi
   (append (when-let* ((src (agent-shell-sessions-consult--current-project-source)))
             (list src))
           (agent-shell-sessions-consult-sources nil)
           (agent-shell-sessions-consult-sources t))
   :prompt "Agent session: "
   :history 'agent-shell-sessions-consult--history
   :require-match nil
   :sort nil))

(provide 'agent-shell-sessions-consult)

;;; agent-shell-sessions-consult.el ends here
