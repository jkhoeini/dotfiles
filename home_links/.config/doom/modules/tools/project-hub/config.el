;;; tools/project-hub/config.el -*- lexical-binding: t; -*-

(use-package! agent-shell-sessions
  :defer t
  :init
  (when (modulep! :ui workspaces)
    (setq agent-shell-sessions-switch-to-project-function
          #'+project-hub-switch-to-project))
  :config
  (agent-shell-sessions-mode-setup))

(after! agent-shell
  (require 'agent-shell-sessions))

(use-package! agent-shell-sessions-embark
  :after (agent-shell-sessions-consult embark))

(add-hook! 'doom-after-modules-config-hook
  (defun +project-hub--bind-keys-h ()
    (map! :leader :desc "Project hub" "," #'+project-hub/open)))
