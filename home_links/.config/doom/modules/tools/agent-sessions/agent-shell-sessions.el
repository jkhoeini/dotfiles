;;; agent-shell-sessions.el --- Session tracking for agent-shell -*- lexical-binding: t -*-

;; Copyright (C) 2025 Mohammad Sadegh Khoeini
;; Author: Mohammad Sadegh Khoeini
;; URL: https://github.com/mkhoeini/agent-shell-sessions
;; Version: 0.1.0
;; Package-Requires: ((emacs "29.1") (agent-shell "0.1"))
;; Keywords: tools, processes

;;; Commentary:

;; Persistent session tracking for agent-shell using SQLite.
;; Records sessions, titles, and timestamps.  Optionally renames
;; buffers to match session titles.

;;; Code:

(require 'cl-lib)
(require 'map)

(declare-function agent-shell-resume-session "agent-shell")
(declare-function agent-shell-start "agent-shell")
(declare-function agent-shell-subscribe-to "agent-shell")
(declare-function agent-shell-buffers "agent-shell")
(declare-function agent-shell--resolve-config-designator "agent-shell")
(declare-function shell-maker-set-buffer-name "shell-maker")

(defgroup agent-shell-sessions nil
  "Session tracking for agent-shell."
  :group 'agent-shell
  :prefix "agent-shell-sessions-")

(defcustom agent-shell-sessions-db-directory
  (expand-file-name "agent-shell"
                    (or (getenv "XDG_STATE_HOME")
                        (expand-file-name "~/.local/state")))
  "Directory for the sessions SQLite database."
  :type 'directory)

(defcustom agent-shell-sessions-rename-buffer t
  "When non-nil, rename agent-shell buffers to the session title."
  :type 'boolean)

(defcustom agent-shell-sessions-switch-to-project-function nil
  "Function to switch to a project workspace before resuming a session.
Called with two arguments: PROJECT-DIR and BUFFER.
PROJECT-DIR is the project root directory.
BUFFER is the agent-shell buffer to display (may be nil for new sessions).

When nil, sessions are resumed in the current workspace with `pop-to-buffer'."
  :type '(choice (const :tag "None (use current workspace)" nil)
                 function))

;;; Database

(defvar agent-shell-sessions--db-connection nil)

(defun agent-shell-sessions-db ()
  "Open or return the session database connection."
  (when (and agent-shell-sessions--db-connection
             (not (sqlitep agent-shell-sessions--db-connection)))
    (setq agent-shell-sessions--db-connection nil))
  (unless agent-shell-sessions--db-connection
    (make-directory agent-shell-sessions-db-directory t)
    (let ((db (sqlite-open (expand-file-name "sessions.db"
                                             agent-shell-sessions-db-directory))))
      (sqlite-execute db "PRAGMA journal_mode=WAL")
      (sqlite-execute db "PRAGMA busy_timeout=3000")
      (sqlite-execute db
       "CREATE TABLE IF NOT EXISTS sessions (
          session_id TEXT PRIMARY KEY,
          title TEXT,
          project_dir TEXT,
          agent_type TEXT,
          archived INTEGER DEFAULT 0,
          created_at INTEGER,
          updated_at INTEGER)")
      (unless (sqlite-select db
               "SELECT 1 FROM pragma_table_info('sessions') WHERE name='agent_type'")
        (sqlite-execute db "ALTER TABLE sessions ADD COLUMN agent_type TEXT")
        (sqlite-execute db
         "UPDATE sessions SET agent_type = 'claude-code' WHERE agent_type IS NULL"))
      (setq agent-shell-sessions--db-connection db)))
  agent-shell-sessions--db-connection)

(defun agent-shell-sessions-db-upsert (session-id project-dir &optional agent-type)
  "Insert or update SESSION-ID with PROJECT-DIR and AGENT-TYPE.
AGENT-TYPE is a string like \"claude-code\" or \"opencode\".
When AGENT-TYPE is nil, preserves any existing value."
  (let ((now (truncate (float-time))))
    (sqlite-execute (agent-shell-sessions-db)
     "INSERT INTO sessions (session_id, project_dir, agent_type, created_at, updated_at)
      VALUES (?, ?, ?, ?, ?)
      ON CONFLICT(session_id) DO UPDATE SET
        project_dir = excluded.project_dir,
        agent_type = COALESCE(excluded.agent_type, sessions.agent_type),
        updated_at = excluded.updated_at"
     (list session-id project-dir agent-type now now))))

(defun agent-shell-sessions-db-update-title (session-id title)
  "Update TITLE for SESSION-ID, truncating and collapsing newlines."
  (when (and session-id (stringp title) (not (string-empty-p title)))
    (let ((clean (truncate-string-to-width
                  (replace-regexp-in-string "[\n\r]+" " " title) 120)))
      (sqlite-execute (agent-shell-sessions-db)
       "UPDATE sessions SET title = ?, updated_at = ? WHERE session_id = ?"
       (list clean (truncate (float-time)) session-id)))))

(defun agent-shell-sessions-db-toggle-archive (session-id)
  "Toggle the archived flag for SESSION-ID."
  (sqlite-execute (agent-shell-sessions-db)
   "UPDATE sessions SET archived = 1 - archived WHERE session_id = ?"
   (list session-id)))

(defun agent-shell-sessions-db-delete (session-id)
  "Delete SESSION-ID from the database."
  (sqlite-execute (agent-shell-sessions-db)
   "DELETE FROM sessions WHERE session_id = ?"
   (list session-id)))

(defun agent-shell-sessions-db-bump-updated (session-id)
  "Bump updated_at for SESSION-ID to now."
  (sqlite-execute (agent-shell-sessions-db)
   "UPDATE sessions SET updated_at = ? WHERE session_id = ?"
   (list (truncate (float-time)) session-id)))

(defun agent-shell-sessions-db-query-project (project-dir archived-p)
  "Query sessions for PROJECT-DIR with ARCHIVED-P status."
  (sqlite-select (agent-shell-sessions-db)
   "SELECT session_id, title, project_dir, updated_at, agent_type
    FROM sessions WHERE archived = ? AND project_dir = ?
    ORDER BY updated_at DESC"
   (list (if archived-p 1 0) project-dir)))

(defun agent-shell-sessions-db-projects (archived-p)
  "Return distinct project dirs ordered by most recent session.
ARCHIVED-P selects archive status."
  (sqlite-select (agent-shell-sessions-db)
   "SELECT project_dir, MAX(updated_at) as latest
    FROM sessions WHERE archived = ? AND project_dir != ''
    GROUP BY project_dir ORDER BY latest DESC"
   (list (if archived-p 1 0))))

;;; Buffer helpers

(defun agent-shell-sessions-live-buffers ()
  "Return alist of (session-id . buffer) for live agent-shell buffers."
  (cl-loop for buf in (if (fboundp 'agent-shell-buffers) (agent-shell-buffers) nil)
           when (buffer-live-p buf)
           for id = (with-current-buffer buf
                      (when (boundp 'agent-shell--state)
                        (map-nested-elt agent-shell--state '(:session :id))))
           when id collect (cons id buf)))

(defun agent-shell-sessions-find-live-buffer (session-id)
  "Find a live agent-shell buffer with SESSION-ID."
  (cl-find-if
   (lambda (buf)
     (with-current-buffer buf
       (and (boundp 'agent-shell--state)
            (equal (map-nested-elt agent-shell--state '(:session :id))
                   session-id))))
   (if (fboundp 'agent-shell-buffers) (agent-shell-buffers) nil)))

;;; Formatting

(defun agent-shell-sessions-relative-time (unix-time)
  "Format UNIX-TIME as a relative time string."
  (if (or (null unix-time) (= unix-time 0)) ""
    (let ((diff (- (truncate (float-time)) unix-time)))
      (cond
       ((< diff 60) "now")
       ((< diff 3600) (format "%dm ago" (/ diff 60)))
       ((< diff 86400) (format "%dh ago" (/ diff 3600)))
       ((< diff 2592000) (format "%dd ago" (/ diff 86400)))
       (t (format-time-string "%b %d" (seconds-to-time unix-time)))))))

;;; Session tracker

(defun agent-shell-sessions--buffer-session-id (buf)
  "Return the session ID from agent-shell BUF, or nil."
  (with-current-buffer buf
    (when (boundp 'agent-shell--state)
      (map-nested-elt agent-shell--state '(:session :id)))))

(defun agent-shell-sessions-tracker-setup ()
  "Subscribe to agent-shell events for session tracking.
Add this to `agent-shell-mode-hook'."
  (when (sqlite-available-p)
    (let ((buf (current-buffer)))
      (agent-shell-subscribe-to
       :shell-buffer buf
       :event 'init-finished
       :on-event (lambda (_event)
                   (when (buffer-live-p buf)
                     (when-let* ((id (agent-shell-sessions--buffer-session-id buf)))
                       (let ((agent-type
                              (with-current-buffer buf
                                (when-let* ((ident (map-nested-elt
                                                    agent-shell--state
                                                    '(:agent-config :identifier))))
                                  (symbol-name ident)))))
                         (agent-shell-sessions-db-upsert
                          id (buffer-local-value 'default-directory buf)
                          agent-type))))))
      (agent-shell-subscribe-to
       :shell-buffer buf
       :event 'session-title-changed
       :on-event (lambda (event)
                   (when (buffer-live-p buf)
                     (when-let* ((id (agent-shell-sessions--buffer-session-id buf))
                                 (title (map-nested-elt event '(:data :title))))
                       (agent-shell-sessions-db-update-title id title)
                       (when agent-shell-sessions-rename-buffer
                         (with-current-buffer buf
                           (shell-maker-set-buffer-name buf (format "*%s*" title))))))))
      (agent-shell-subscribe-to
       :shell-buffer buf
       :event 'turn-complete
       :on-event (lambda (_event)
                   (when (buffer-live-p buf)
                     (when-let* ((id (agent-shell-sessions--buffer-session-id buf)))
                       (agent-shell-sessions-db-bump-updated id))))))))

;;;###autoload
(defun agent-shell-sessions-mode-setup ()
  "Enable session tracking for agent-shell.
Call this once, or add to your init."
  (add-hook 'agent-shell-mode-hook #'agent-shell-sessions-tracker-setup))

;;; Resume

(defun agent-shell-sessions-resume (session-id project-dir &optional agent-type)
  "Switch to or resume SESSION-ID from PROJECT-DIR.
AGENT-TYPE is a string like \"claude-code\" identifying the agent harness.
When non-nil, resumes with the correct agent config automatically.
Uses `agent-shell-sessions-switch-to-project-function' for workspace management."
  (let ((live (agent-shell-sessions-find-live-buffer session-id)))
    (cond
     (live
      (when agent-shell-sessions-switch-to-project-function
        (funcall agent-shell-sessions-switch-to-project-function project-dir live))
      (pop-to-buffer live))
     (t
      (unless (and project-dir (file-directory-p project-dir))
        (user-error "Project directory no longer exists: %s" project-dir))
      (when agent-shell-sessions-switch-to-project-function
        (funcall agent-shell-sessions-switch-to-project-function project-dir nil))
      (let* ((default-directory project-dir)
             (config (when (and agent-type
                               (not (string-empty-p agent-type))
                               (fboundp 'agent-shell--resolve-config-designator))
                       (agent-shell--resolve-config-designator (intern agent-type))))
             (buf (if config
                      (agent-shell-start :config config :session-id session-id)
                    (agent-shell-resume-session session-id))))
        (when (and buf agent-shell-sessions-switch-to-project-function)
          (funcall agent-shell-sessions-switch-to-project-function project-dir buf)))))))

(provide 'agent-shell-sessions)

;;; agent-shell-sessions.el ends here
