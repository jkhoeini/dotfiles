;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Mohammad Sadegh Khoeini"
      user-mail-address "mskco.tp@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
(setq doom-font (font-spec :family "JuliaMono" :size 13 :height 1.4 :weight 'regular))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
(setq doom-theme 'doom-nord)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq scroll-margin 4)
(setq-default line-spacing 8)
(setq calendar-date-style 'iso)
(pixel-scroll-precision-mode)
(auto-save-visited-mode)
(setq parinfer-rust-library "/Users/mohammadk/Dev/parinfer-rust/parinfer.so")

(after! typescript-mode
  ;; Ensure that lsp-mode automatically detects deno in projects with a "deno.json" or "deno.jsonc" configuration file
  (add-hook 'typescript-mode-hook
            (lambda ()
              (message "Make sure this is actually running")
              (when (or (locate-dominating-file default-directory "deno.json")
                        (locate-dominating-file default-directory "deno.jsonc"))
                (setq-local lsp-enabled-clients '(deno-ls))))))

(map! :n "-" #'dired-jump)

(require 'typst-ts-mode)
(add-to-list 'auto-mode-alist '("\\.typ\\'" . typst-ts-mode))
(setq ;typst-ts-watch-options "--open"
 typst-ts-mode-enable-raw-blocks-highlight t)

(after! (:and typst-ts-mode lsp-mode)
  (add-to-list 'lsp-language-id-configuration '(typst-ts-mode . "typst"))
  (lsp-register-client (make-lsp-client :new-connection (lsp-stdio-connection "tinymist")
                                        :activation-fn (lsp-activate-on "typst")
                                        :server-id 'typst-lsp)))


(defvar my-scroll-reset-timer nil
  "Timer to reset scroll-margin after scrolling stops.")

(defun my-disable-scroll-margin (&rest _)
  "Disable scroll-margin when pixel scrolling."
  (setq-local scroll-margin 0)
  ;; Cancel any existing timer
  (when my-scroll-reset-timer
    (cancel-timer my-scroll-reset-timer))
  ;; Set a new timer to restore scroll-margin after inactivity
  (setq my-scroll-reset-timer
        (run-with-idle-timer 0.2 nil #'my-restore-scroll-margin)))

(defun my-restore-scroll-margin ()
  "Restore scroll-margin after scrolling stops."
  (setq-local scroll-margin 4)
  (setq my-scroll-reset-timer nil))

(dolist (cmd '(pixel-scroll-precision-scroll-up pixel-scroll-precision-scroll-down))
  (advice-add cmd :before #'my-disable-scroll-margin))

(add-hook 'cider-repl-mode-hook #'subword-mode)


;; === paren-face-mode ===

(global-paren-face-mode)
(setq paren-face-regexp "\\([( ]\\.-\\|[( ]\\.+\\|[][(){}#/]\\)")
;; (set-face-foreground 'parenthesis "#3ff244de4915")

(advice-add 'rainbow-delimiters-mode :around
            (lambda (orig-fun &rest args)
              (if (derived-mode-p 'clojure-mode)
                  (message "Skipping rainbow-delimiters-mode in clojure-mode")
                (apply orig-fun args))))


;; === clj-refactor ===

(map! :mode clojure-mode
      :localleader "R" #'hydra-cljr-help-menu/body)


;; === .dir-locals ===

(defun my-reload-dir-locals-for-current-buffer ()
  "reload dir locals for the current buffer"
  (interactive)
  (let ((enable-local-variables :all))
    (hack-dir-local-variables-non-file-buffer)))

(defun my-reload-dir-locals-for-all-buffer-in-this-directory ()
  "For every buffer with the same `default-directory` as the
current buffer's, reload dir-locals."
  (interactive)
  (let ((dir default-directory))
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
        (when (equal default-directory dir)
          (my-reload-dir-locals-for-current-buffer))))))

(add-hook 'emacs-lisp-mode-hook
          (defun enable-autoreload-for-dir-locals ()
            (when (and (buffer-file-name)
                       (equal dir-locals-file
                              (file-name-nondirectory (buffer-file-name))))
              (add-hook 'after-save-hook
                        'my-reload-dir-locals-for-all-buffer-in-this-directory
                        nil t))))

(after! projectile
  (add-to-list 'projectile-project-root-files "Package.swift")
  (projectile-register-project-type
   'swift '("Package.swift")
   :project-file "Package.swift"
   :compile "swift build"
   :run "swift run"
   :test "swift test"))

(map! "C-M-s-f"
      (cmd!  ; doom macro: wraps a lambda (interactive)
       (start-process "fill-screen" nil "osascript"
                      "-e" "tell application \"System Events\" to key down 63"                       ; Fn down
                      "-e" "tell application \"System Events\" to key code 3 using {control down}"   ; Ctrl-F
                      "-e" "tell application \"System Events\" to key up 63")))                     ; Fn up

(after! gptel
  (require 'gptel-integrations)
  (setq
   gptel-model 'magistral:latest
   gptel-backend (gptel-make-ollama "Ollama"
                   :host "localhost:11434"
                   :stream t
                   :models '(devstral:latest magistral:latest))))

;; (use-package! magit-gptcommit
;;   :config
;;   (require 'llm-ollama)
;;   (setq magit-gptcommit-llm-provider (make-llm-ollama :chat-model "devstral-small-2:latest"))
;;   (magit-gptcommit-mode 1)
;;   (magit-gptcommit-status-buffer-setup))

(after! aidermacs
  (setq aidermacs-default-model "ollama_chat/devstral"
        aidermacs-default-chat-mode 'architect))

;; (map! :leader :desc "Aidermacs" "a a" #'aidermacs-transient-menu)

(after! (org ob-aider)
  (add-to-list 'org-babel-load-languages '(aider . t))
  (org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages))

(use-package! eat
  :after eshell
  :hook ((eshell-load . eat-eshell-mode)
         (eshell-load . eat-eshell-visual-command-mode))
  :config
  (setq! eat-shell "/opt/homebrew/bin/zsh"
         eat-scroll-to-bottom-on-input t
         shell-file-name eat-shell
         +eshell-backend 'eat
         eat-enable-shell-integration t
         eshell-visual-commands '("htop" "top" "vim" "nvim" "less" "man" "tmux" "watch" "gemini")))
