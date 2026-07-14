;;; tools/project-hub/autoload/project-hub.el -*- lexical-binding: t; -*-

(defvar +project-hub--history nil
  "History for project hub prompts.")

(defvar +project-hub--source-buffers
  `(:name "Buffer"
    :narrow ?b
    :category buffer
    :face consult-buffer
    :default t
    :state ,#'consult--buffer-state
    :items ,(lambda ()
              (cl-loop for b in (if (bound-and-true-p persp-mode)
                                    (persp-buffer-list)
                                  (buffer-list))
                       for name = (buffer-name b)
                       unless (or (eq b (current-buffer))
                                  (string-prefix-p " " name))
                       collect name))
    :action ,(lambda (name &rest _) (switch-to-buffer name))
    :new ,(lambda (name) (switch-to-buffer (get-buffer-create name)))))

(defvar +project-hub--source-workspaces
  `(:name "Workspace"
    :narrow ?w
    :category workspace
    :face font-lock-constant-face
    :items ,(lambda ()
              (when (bound-and-true-p persp-mode)
                (cl-remove (+workspace-current-name)
                           (+workspace-list-names)
                           :test #'equal)))
    :action ,(lambda (name &rest _) (+workspace/switch-to name))))

(defvar +project-hub--source-projects
  `(:name "Project"
    :narrow ?p
    :hidden t
    :face font-lock-keyword-face
    :items ,(lambda ()
              (when (bound-and-true-p persp-mode)
                (let ((open (+workspace-list-names)))
                  (cl-loop for dir in (project-known-project-roots)
                           for name = (file-name-nondirectory
                                       (directory-file-name dir))
                           unless (member name open)
                           collect (propertize name 'project-dir dir)))))
    :action ,(lambda (name &rest _)
               (let ((dir (get-text-property 0 'project-dir name)))
                 (+project-hub-switch-to-project dir nil)
                 (project-switch-project dir)))))

(defun +project-hub--project-dir ()
  (or (when-let* ((pr (project-current))) (expand-file-name (project-root pr)))
      default-directory))

(defun +project-hub--bookmark-items ()
  (require 'bookmark)
  (bookmark-maybe-load-default-file)
  (thread-last bookmark-alist
    (seq-filter (lambda (bm)
                  (bookmark-prop-get bm 'project)))
    (seq-sort-by (lambda (bm)
                   (+ (if (bookmark-prop-get bm 'pinned) 1e12 0)
                      (or (bookmark-prop-get bm 'last-used) 0)))
                 #'>)
    (mapcar (lambda (bm)
              (let ((name (bookmark-name-from-full-record bm)))
                (if (bookmark-prop-get bm 'pinned)
                    (concat (propertize "★ " 'face 'warning) name)
                  name))))))

(defun +project-hub--bookmark-jump (cand &rest _)
  (let ((name (string-remove-prefix "★ " (substring-no-properties cand))))
    (when-let* ((proj (bookmark-prop-get (bookmark-get-bookmark name) 'project)))
      (+project-hub-switch-to-project proj nil))
    (bookmark-prop-set name 'last-used (truncate (float-time)))
    (bookmark-jump name)))

(defvar +project-hub--source-bookmarks
  `(:name "Bookmark"
    :narrow ?m
    :category bookmark
    :face consult-bookmark
    :items ,#'+project-hub--bookmark-items
    :action ,#'+project-hub--bookmark-jump))

(defun +project-hub--session-sources ()
  "Return agent-shell session consult sources, stripping :default."
  (when (and (fboundp 'sqlite-available-p) (sqlite-available-p)
             (require 'agent-shell-sessions-consult nil t))
    (clrhash agent-shell-sessions-consult--candidates)
    (mapcar (lambda (src) (map-delete src :default))
            (append (agent-shell-sessions-consult-sources nil)
                    (agent-shell-sessions-consult-sources t)))))

;;;###autoload
(defun +project-hub/open ()
  "Unified hub: buffers, workspaces, and agent sessions."
  (interactive)
  (require 'consult)
  (consult--multi
   (append (list '+project-hub--source-buffers
                 '+project-hub--source-workspaces
                 '+project-hub--source-projects
                 '+project-hub--source-bookmarks)
           (+project-hub--session-sources))
   :prompt "Hub: "
   :history '+project-hub--history
   :require-match nil
   :sort nil))

;;;###autoload
(defun +project-hub-switch-to-project (project-dir buffer)
  "Switch to workspace for PROJECT-DIR, adding BUFFER."
  (when (and project-dir (file-directory-p project-dir)
             (bound-and-true-p persp-mode))
    (let ((ws-name (file-name-nondirectory (directory-file-name project-dir))))
      (+workspace-switch ws-name t)
      (when buffer (persp-add-buffer buffer)))))
