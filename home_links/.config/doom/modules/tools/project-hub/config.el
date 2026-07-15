;;; tools/project-hub/config.el -*- lexical-binding: t; -*-

(after! agent-shell-sessions
  (when (modulep! :ui workspaces)
    (setq agent-shell-sessions-switch-to-project-function
          #'+project-hub-switch-to-project)))

(add-hook! 'doom-after-modules-config-hook
  (defun +project-hub--bind-keys-h ()
    (map! :leader :desc "Project hub" "," #'+project-hub/open)))

(after! embark
  (define-key embark-buffer-map (kbd "*") #'+project-hub/toggle-pin-buffer)

  (defvar-keymap +project-hub-embark-project-map
    :doc "Actions for project candidates."
    :parent embark-general-map
    "*" #'+project-hub/toggle-pin-project)
  (add-to-list 'embark-keymap-alist '(project . +project-hub-embark-project-map))

  (when (eq embark-quit-after-action t)
    (setq embark-quit-after-action '((t . t))))
  (dolist (cmd '(+project-hub/toggle-pin-buffer
                 +project-hub/toggle-pin-project
                 +project-hub/toggle-pin-session))
    (setf (alist-get cmd embark-quit-after-action) nil)
    (add-to-list 'embark-post-action-hooks (list cmd 'embark--restart))))

(after! agent-shell-sessions-embark
  (define-key agent-shell-sessions-embark-map (kbd "*") #'+project-hub/toggle-pin-session))
