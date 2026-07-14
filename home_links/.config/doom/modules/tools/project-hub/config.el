;;; tools/project-hub/config.el -*- lexical-binding: t; -*-

(after! agent-shell-sessions
  (when (modulep! :ui workspaces)
    (setq agent-shell-sessions-switch-to-project-function
          #'+project-hub-switch-to-project)))

(add-hook! 'doom-after-modules-config-hook
  (defun +project-hub--bind-keys-h ()
    (map! :leader
          :desc "Project hub" "," #'+project-hub/open
          (:prefix ("k" . "hub")
           :desc "Bookmark here" "m" #'+project-hub/bookmark-add
           :desc "Toggle pin"    "p" #'+project-hub/bookmark-toggle-pin))))

(after! embark
  (define-key embark-bookmark-map (kbd "p") #'+project-hub/bookmark-toggle-pin))
