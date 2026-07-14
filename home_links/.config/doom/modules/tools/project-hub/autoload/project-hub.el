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
                 '+project-hub--source-workspaces)
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
