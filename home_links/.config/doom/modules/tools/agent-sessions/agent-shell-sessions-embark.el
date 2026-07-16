;;; agent-shell-sessions-embark.el --- Embark actions for agent-shell-sessions -*- lexical-binding: t -*-

;; Copyright (C) 2025 Mohammad Sadegh Khoeini
;; Author: Mohammad Sadegh Khoeini
;; URL: https://github.com/mkhoeini/agent-shell-sessions
;; Version: 0.1.0
;; Package-Requires: ((emacs "29.1") (agent-shell-sessions-consult "0.1") (embark "1.0"))
;; Keywords: tools, processes

;;; Commentary:

;; Embark actions for agent-shell session candidates.
;; Provides archive toggling, renaming, deletion, and utility actions
;; via the `agent-session' category.

;;; Code:

(require 'embark)
(require 'agent-shell-sessions-consult)

(declare-function agent-shell "agent-shell")
(declare-function shell-maker-set-buffer-name "shell-maker")

(defun agent-shell-sessions-embark-archive-toggle (cand)
  "Toggle archive status of session CAND."
  (interactive "sSession: ")
  (if-let* ((data (agent-shell-sessions-consult-session-data cand))
            (id (plist-get data :id)))
      (progn
        (agent-shell-sessions-db-toggle-archive id)
        (message "Toggled archive: %s" (string-trim cand)))
    (user-error "Unknown session: %s" cand)))

(defun agent-shell-sessions-embark-rename (cand)
  "Rename session CAND."
  (interactive "sSession: ")
  (if-let* ((data (agent-shell-sessions-consult-session-data cand))
            (id (plist-get data :id)))
      (let ((title (read-string "New title: " (plist-get data :title))))
        (agent-shell-sessions-db-update-title id title)
        (when-let* ((buf (agent-shell-sessions-find-live-buffer id))
                    ((bound-and-true-p agent-shell-sessions-rename-buffer)))
          (shell-maker-set-buffer-name buf (format "*%s*" title)))
        (message "Renamed: %s" title))
    (user-error "Unknown session: %s" cand)))

(defun agent-shell-sessions-embark-delete (cand)
  "Delete session CAND from the database."
  (interactive "sSession: ")
  (if-let* ((data (agent-shell-sessions-consult-session-data cand))
            (id (plist-get data :id)))
      (progn
        (when (agent-shell-sessions-find-live-buffer id)
          (user-error "Session has a live buffer — kill it first with K"))
        (agent-shell-sessions-db-delete id)
        (message "Deleted: %s" (string-trim cand)))
    (user-error "Unknown session: %s" cand)))

(defun agent-shell-sessions-embark-copy-id (cand)
  "Copy session ID of CAND to the kill ring."
  (interactive "sSession: ")
  (if-let* ((data (agent-shell-sessions-consult-session-data cand))
            (id (plist-get data :id)))
      (progn
        (kill-new id)
        (message "Copied session ID: %s" id))
    (user-error "Unknown session: %s" cand)))

(defun agent-shell-sessions-embark-dired (cand)
  "Open project directory of CAND in dired."
  (interactive "sSession: ")
  (if-let* ((data (agent-shell-sessions-consult-session-data cand))
            (dir (plist-get data :dir)))
      (if (file-directory-p dir)
          (dired dir)
        (user-error "Directory no longer exists: %s" dir))
    (user-error "Unknown session: %s" cand)))

(defun agent-shell-sessions-embark-kill-buffer (cand)
  "Kill the live buffer for session CAND."
  (interactive "sSession: ")
  (if-let* ((data (agent-shell-sessions-consult-session-data cand))
            (id (plist-get data :id)))
      (if-let* ((buf (agent-shell-sessions-find-live-buffer id)))
          (progn
            (kill-buffer buf)
            (message "Killed buffer for: %s" (string-trim cand)))
        (message "No live buffer for: %s" (string-trim cand)))
    (user-error "Unknown session: %s" cand)))

(defun agent-shell-sessions-embark-new-session (cand)
  "Start a new agent-shell session in the same project as CAND."
  (interactive "sSession: ")
  (if-let* ((data (agent-shell-sessions-consult-session-data cand))
            (dir (plist-get data :dir)))
      (let ((default-directory dir))
        (agent-shell))
    (user-error "Unknown session: %s" cand)))

(defvar-keymap agent-shell-sessions-embark-map
  :doc "Actions for agent-shell sessions."
  :parent embark-general-map
  "a" #'agent-shell-sessions-embark-archive-toggle
  "r" #'agent-shell-sessions-embark-rename
  "k" #'agent-shell-sessions-embark-delete
  "w" #'agent-shell-sessions-embark-copy-id
  "j" #'agent-shell-sessions-embark-dired
  "K" #'agent-shell-sessions-embark-kill-buffer
  "n" #'agent-shell-sessions-embark-new-session)

(add-to-list 'embark-keymap-alist '(agent-session . agent-shell-sessions-embark-map))

(defun agent-shell-sessions-embark-target-finder ()
  "Target finder for agent-shell buffers.
Returns the current buffer's session as an `agent-session' target.
The candidate is the bare session ID; the resolver's DB fallback
handles lookup since embark strips text properties during injection."
  (when (bound-and-true-p agent-shell--state)
    (when-let* ((id (map-nested-elt agent-shell--state '(:session :id))))
      `(agent-session ,id ,(point) . ,(point)))))

(add-to-list 'embark-target-finders #'agent-shell-sessions-embark-target-finder t)

(when (eq embark-quit-after-action t)
  (setq embark-quit-after-action '((t . t))))
(dolist (cmd '(agent-shell-sessions-embark-archive-toggle
               agent-shell-sessions-embark-rename
               agent-shell-sessions-embark-delete
               agent-shell-sessions-embark-kill-buffer))
  (setf (alist-get cmd embark-quit-after-action) nil)
  (add-to-list 'embark-post-action-hooks (list cmd 'embark--restart)))
(dolist (cmd '(agent-shell-sessions-embark-delete
               agent-shell-sessions-embark-kill-buffer))
  (add-to-list 'embark-pre-action-hooks (list cmd 'embark--confirm)))

(provide 'agent-shell-sessions-embark)

;;; agent-shell-sessions-embark.el ends here
