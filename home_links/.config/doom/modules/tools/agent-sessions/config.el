;;; tools/agent-sessions/config.el -*- lexical-binding: t; -*-

(add-load-path! ".")

(after! agent-shell
  (require 'agent-shell-sessions)
  (agent-shell-sessions-mode-setup))

(after! (agent-shell-sessions-consult embark)
  (require 'agent-shell-sessions-embark))
