;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Jonathan Khoeini"
      user-mail-address "jonathan@komemfamily.com")

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
(setopt doom-font (font-spec :family "JuliaMono"
                            :size (if (eq system-type 'darwin) 13 13)
                            :weight 'regular)
       line-spacing 0.6)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-nord)
;; (setq doom-twilight-dark-variant "hard")      ; Darker background
;; (setq doom-twilight-colorful-headers t)       ; Varied heading colors  
;; (setq doom-twilight-brighter-comments t)      ; Cyan comments
;; (setq doom-twilight-brighter-modeline t)      ; Blue-tinted modeline
(setq doom-theme 'doom-twilight)

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

(after! doom-modeline
  (setq doom-modeline-persp-name t
        doom-modeline-display-default-persp-name t))

(setq frame-title-format
      '((:eval (if (bound-and-true-p persp-mode)
                   (format "[%s] " (+workspace-current-name))
                 ""))
        "%b"))

(setq scroll-margin 4)
(setq-default line-spacing 8)
(setq calendar-date-style 'iso)
(pixel-scroll-precision-mode)
(auto-save-visited-mode)
(setq parinfer-rust-library (expand-file-name "~/Dev/parinfer-rust/parinfer.so"))

(after! typescript-mode
  ;; Ensure that lsp-mode automatically detects deno in projects with a "deno.json" or "deno.jsonc" configuration file
  (add-hook 'typescript-mode-hook
            (lambda ()
              (message "Make sure this is actually running")
              (when (or (locate-dominating-file default-directory "deno.json")
                        (locate-dominating-file default-directory "deno.jsonc"))
                (setq-local lsp-enabled-clients '(deno-ls))))))

(map! :n "-" #'dired-jump)
(map! :leader :desc "Run command" :n "SPC" 'execute-extended-command)

(after! consult
  (defvar my/consult-source-workspace-buffers
    `(:name "Buffer"
      :narrow ?b
      :category buffer
      :face consult-buffer
      :state ,#'consult--buffer-state
      :items ,(lambda ()
                (let ((bufs (if (bound-and-true-p persp-mode)
                               (persp-buffer-list)
                             (buffer-list))))
                  (cl-loop for b in bufs
                           for name = (buffer-name b)
                           unless (or (eq b (current-buffer))
                                      (string-prefix-p " " name))
                           collect name)))
      :action ,(lambda (name &rest _) (switch-to-buffer name))))

  (defvar my/consult-source-workspaces
    `(:name "Workspace"
      :narrow ?w
      :face font-lock-constant-face
      :items ,(lambda ()
                (when (bound-and-true-p persp-mode)
                  (cl-remove (+workspace-current-name)
                             (+workspace-list-names)
                             :test #'equal)))
      :action ,(lambda (name &rest _) (+workspace/switch-to name)))))

(defun my/unified-switcher ()
  "Switch between workspace buffers and open workspaces."
  (interactive)
  (consult-buffer (list 'my/consult-source-workspace-buffers
                        'my/consult-source-workspaces)))

(map! :leader :desc "Switch buffer/workspace" "," #'my/unified-switcher)

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


;; ==== AI Stuff ====================

(after! gptel
  (require 'gptel-integrations)
  (setq
   gptel-model 'devstral-small-2:latest
   gptel-backend (gptel-make-ollama "Ollama"
                   :host "localhost:11434"
                   :stream t
                   :models '(devstral-small-2:latest magistral:latest))))

(use-package! agent-shell
  :commands (agent-shell agent-shell-toggle agent-shell-anthropic-start-claude-code)
  :config
  (require 'acp)
  (require 'agent-shell)

  (defun my/agent-shell-dot-subdir (subdir)
    "Store agent-shell data outside project working trees."
    (let* ((state-home (or (getenv "XDG_STATE_HOME")
                           (expand-file-name "~/.local/state")))
           (cwd (directory-file-name (expand-file-name (agent-shell-cwd))))
           (sanitized-cwd (replace-regexp-in-string "[/:]" "-" cwd)))
      (expand-file-name subdir
                        (expand-file-name sanitized-cwd
                                          (expand-file-name "agent-shell" state-home)))))

  (setq agent-shell-preferred-agent-config 'claude-code
        agent-shell-anthropic-claude-acp-command '("claude-agent-acp")
        agent-shell-anthropic-claude-environment
        (agent-shell-make-environment-variables :inherit-env t)
        agent-shell-dot-subdir-function #'my/agent-shell-dot-subdir))

(use-package! agent-shell-manager
  :after agent-shell
  :commands agent-shell-manager-toggle
  :config
  (require 'agent-shell-manager)

  (map! :map agent-shell-manager-mode-map
        :n "RET" #'agent-shell-manager-goto
        :n "gr"  #'agent-shell-manager-refresh
        :n "K"   #'agent-shell-manager-kill
        :n "c"   #'agent-shell-manager-new
        :n "R"   #'agent-shell-manager-restart
        :n "D"   #'agent-shell-manager-delete-killed
        :n "m"   #'agent-shell-manager-set-mode
        :n "M"   #'agent-shell-manager-set-model
        :n "C-c C-c" #'agent-shell-manager-interrupt
        :n "t"   #'agent-shell-manager-view-traffic
        :n "l"   #'agent-shell-manager-toggle-logging
        :n "q"   #'quit-window))



;; ==== Session Tracker (SQLite) ====

(defvar my/session-db--connection nil)

(defun my/session-db ()
  "Open or return the session database connection."
  (when (and my/session-db--connection
             (not (sqlitep my/session-db--connection)))
    (setq my/session-db--connection nil))
  (unless my/session-db--connection
    (let ((db-dir (expand-file-name "agent-shell"
                                     (or (getenv "XDG_STATE_HOME")
                                         (expand-file-name "~/.local/state")))))
      (make-directory db-dir t)
      (let ((db (sqlite-open (expand-file-name "sessions.db" db-dir))))
        (sqlite-execute db "PRAGMA journal_mode=WAL")
        (sqlite-execute db "PRAGMA busy_timeout=3000")
        (sqlite-execute db
         "CREATE TABLE IF NOT EXISTS sessions (
            session_id TEXT PRIMARY KEY,
            title TEXT,
            project_dir TEXT,
            archived INTEGER DEFAULT 0,
            created_at INTEGER,
            updated_at INTEGER)")
        (setq my/session-db--connection db))))
  my/session-db--connection)

(defun my/session-db-upsert (session-id project-dir)
  "Insert or update a session, preserving created_at and title."
  (let ((now (truncate (float-time))))
    (sqlite-execute (my/session-db)
     "INSERT INTO sessions (session_id, project_dir, created_at, updated_at)
      VALUES (?, ?, ?, ?)
      ON CONFLICT(session_id) DO UPDATE SET updated_at = excluded.updated_at"
     (list session-id project-dir now now))))

(defun my/session-db-update-title (session-id title)
  "Update the title for a session, truncating and collapsing newlines."
  (when (and session-id (stringp title) (not (string-empty-p title)))
    (let ((clean (truncate-string-to-width
                  (replace-regexp-in-string "[\n\r]+" " " title) 120)))
      (sqlite-execute (my/session-db)
       "UPDATE sessions SET title = ?, updated_at = ? WHERE session_id = ?"
       (list clean (truncate (float-time)) session-id)))))

(defun my/session-db-toggle-archive (session-id)
  "Toggle the archived flag for a session."
  (sqlite-execute (my/session-db)
   "UPDATE sessions SET archived = 1 - archived WHERE session_id = ?"
   (list session-id)))

(defun my/session-db-query (&optional include-archived)
  "Query sessions ordered by recency."
  (sqlite-select (my/session-db)
   (if include-archived
       "SELECT session_id, title, project_dir, archived, updated_at
        FROM sessions ORDER BY updated_at DESC"
     "SELECT session_id, title, project_dir, archived, updated_at
      FROM sessions WHERE archived = 0 ORDER BY updated_at DESC")))

(defun my/session-tracker-setup ()
  "Subscribe to agent-shell events for session tracking."
  (when (sqlite-available-p)
    (let ((buf (current-buffer)))
      (agent-shell-subscribe-to
       :shell-buffer buf
       :event 'init-finished
       :on-event (lambda (_event)
                   (when-let* ((id (with-current-buffer buf
                                     (when (boundp 'agent-shell--state)
                                       (map-nested-elt agent-shell--state '(:session :id))))))
                     (my/session-db-upsert id (buffer-local-value 'default-directory buf)))))
      (agent-shell-subscribe-to
       :shell-buffer buf
       :event 'session-title-changed
       :on-event (lambda (event)
                   (when-let* ((id (with-current-buffer buf
                                     (when (boundp 'agent-shell--state)
                                       (map-nested-elt agent-shell--state '(:session :id)))))
                               (title (map-nested-elt event '(:data :title))))
                     (my/session-db-update-title id title)
                     (with-current-buffer buf
                       (rename-buffer (format "*%s*" title) t)
                       (setq-local shell-maker--buffer-name-override (buffer-name))))))
      (agent-shell-subscribe-to
       :shell-buffer buf
       :event 'turn-complete
       :on-event (lambda (_event)
                   (when-let* ((id (with-current-buffer buf
                                     (when (boundp 'agent-shell--state)
                                       (map-nested-elt agent-shell--state '(:session :id))))))
                     (let ((now (truncate (float-time))))
                       (sqlite-execute (my/session-db)
                        "UPDATE sessions SET updated_at = ? WHERE session_id = ?"
                        (list now id)))))))))

(add-hook 'agent-shell-mode-hook #'my/session-tracker-setup)

(defun my/session-live-buffers ()
  "Return alist of (session-id . buffer) for live agent-shell buffers."
  (cl-loop for buf in (if (fboundp 'agent-shell-buffers) (agent-shell-buffers) nil)
           when (buffer-live-p buf)
           for id = (with-current-buffer buf
                      (when (boundp 'agent-shell--state)
                        (map-nested-elt agent-shell--state '(:session :id))))
           when id collect (cons id buf)))

(defun my/relative-time (unix-time)
  "Format UNIX-TIME as a relative time string."
  (if (or (null unix-time) (= unix-time 0)) ""
    (let ((diff (- (truncate (float-time)) unix-time)))
      (cond
       ((< diff 60) "now")
       ((< diff 3600) (format "%dm ago" (/ diff 60)))
       ((< diff 86400) (format "%dh ago" (/ diff 3600)))
       ((< diff 2592000) (format "%dd ago" (/ diff 86400)))
       (t (format-time-string "%b %d" (seconds-to-time unix-time)))))))

(defun my/session-find-live-buffer (session-id)
  "Find a live agent-shell buffer with SESSION-ID."
  (cl-find-if
   (lambda (buf)
     (with-current-buffer buf
       (and (boundp 'agent-shell--state)
            (equal (map-nested-elt agent-shell--state '(:session :id))
                   session-id))))
   (if (fboundp 'agent-shell-buffers) (agent-shell-buffers) nil)))

(defun my/session--workspace-of (buf)
  "Return the workspace name containing BUF, or nil."
  (when (bound-and-true-p persp-mode)
    (cl-loop for persp in (+workspace-list)
             when (persp-contain-buffer-p buf persp)
             return (safe-persp-name persp))))

(defvar my/session--candidates (make-hash-table :test #'equal)
  "Map candidate string -> session plist, rebuilt per invocation.")

(defun my/session--make-items (archived-p)
  "Build consult candidates from SQLite. ARCHIVED-P selects archive status."
  (let ((live (my/session-live-buffers))
        (rows (sqlite-select (my/session-db)
               "SELECT session_id, title, project_dir, updated_at
                FROM sessions WHERE archived = ? ORDER BY updated_at DESC"
               (list (if archived-p 1 0)))))
    (cl-loop for row in rows
             for idx from 0
             for id = (nth 0 row)
             for title = (or (nth 1 row) "Untitled")
             for dir = (or (nth 2 row) "")
             for updated = (nth 3 row)
             collect
             (let* ((live-buf (cdr (assoc id live)))
                    (cand (concat (truncate-string-to-width title 50 nil ?\s)
                                  (consult--tofu-encode idx))))
               (puthash cand (list :id id :dir dir :updated updated
                                   :live-p (and live-buf t))
                        my/session--candidates)
               cand))))

(defun my/session--annotate (cand)
  "Annotate a session candidate with project, age, and live status."
  (when-let* ((data (gethash cand my/session--candidates)))
    (let* ((dir (plist-get data :dir))
           (project (file-name-nondirectory (directory-file-name dir)))
           (updated (plist-get data :updated))
           (live-p (plist-get data :live-p)))
      (concat (propertize (format " %s" project) 'face 'font-lock-comment-face)
              (propertize (format " %s" (my/relative-time updated))
                          'face 'font-lock-doc-face)
              (when live-p
                (propertize " ●" 'face 'success))))))

(defun my/session--resume (session-id project-dir)
  "Switch to or resume SESSION-ID in the correct workspace."
  (let ((live (my/session-find-live-buffer session-id)))
    (cond
     ;; Live buffer in a known workspace: switch there
     ((and live (my/session--workspace-of live))
      (+workspace-switch (my/session--workspace-of live))
      (pop-to-buffer live))
     ;; Live buffer but orphaned from workspace: add to project workspace
     (live
      (unless (and project-dir (file-directory-p project-dir))
        (user-error "Project directory no longer exists: %s" project-dir))
      (let ((ws-name (file-name-nondirectory (directory-file-name project-dir))))
        (+workspace-switch ws-name t)
        (persp-add-buffer live)
        (pop-to-buffer live)))
     ;; Dead session: create in project workspace
     (t
      (unless (and project-dir (file-directory-p project-dir))
        (user-error "Project directory no longer exists: %s" project-dir))
      (let* ((ws-name (file-name-nondirectory (directory-file-name project-dir)))
             (_ (+workspace-switch ws-name t))
             (default-directory project-dir)
             (buf (agent-shell-resume-session session-id)))
        (when buf (persp-add-buffer buf)))))))

(defun my/session--action (cand)
  "Resume or switch to session CAND."
  (when-let* ((data (gethash cand my/session--candidates)))
    (my/session--resume (plist-get data :id) (plist-get data :dir))))

(defun my/session--action-unarchive (cand)
  "Resume session CAND and unarchive it."
  (when-let* ((data (gethash cand my/session--candidates)))
    (my/session-db-toggle-archive (plist-get data :id))
    (my/session--resume (plist-get data :id) (plist-get data :dir))))

(defvar my/session--history nil)

(after! consult
  (defun my/agent-shell-switcher ()
    "Unified agent-shell session switcher."
    (interactive)
    (unless (sqlite-available-p) (user-error "SQLite not available"))
    (clrhash my/session--candidates)
    (consult--multi
     (list `(:name "Sessions" :narrow ?s :category agent-session :default t
             :items ,(lambda () (my/session--make-items nil))
             :annotate ,#'my/session--annotate
             :action ,#'my/session--action
             :new ,(lambda (_input) (agent-shell)))
           `(:name "Archived" :narrow ?x :category agent-session :hidden t
             :items ,(lambda () (my/session--make-items t))
             :annotate ,#'my/session--annotate
             :action ,#'my/session--action-unarchive))
     :prompt "Agent session (M-RET new): "
     :history 'my/session--history
     :require-match nil
     :sort nil))

  (map! :leader :prefix "o" :desc "Agent Sessions" "a" #'my/agent-shell-switcher))

(after! embark
  (defvar-keymap my/session-embark-map
    :doc "Actions for agent-shell sessions"
    :parent embark-general-map
    "a" #'my/session-embark-archive-toggle)
  (add-to-list 'embark-keymap-alist '(agent-session . my/session-embark-map)))

(defun my/session-embark-archive-toggle (cand)
  "Toggle archive status of session CAND."
  (when-let* ((data (gethash cand my/session--candidates))
              (id (plist-get data :id)))
    (my/session-db-toggle-archive id)
    (message "Toggled archive: %s" (truncate-string-to-width cand 40))))

(map! :leader
      :prefix "o"
      :desc "New Agent Shell" "A" #'agent-shell
      :desc "Agent Shell Manager" "m" #'agent-shell-manager-toggle)



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

(after! org
  (setopt org-todo-keywords
         '((sequence "NOW(n)" "NEXT(x)" "LATER(l)" "PROJ(p)" "|" "DONE(d)" "CANCEL(c)")
           (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)")))

  ;; Count all descendant TODOs, not just direct children
  (setopt org-hierarchical-todo-statistics nil)

  ;; Auto-update cookies when TODO state changes
  (add-hook 'org-after-todo-state-change-hook 'org-update-parent-todo-statistics))

(map! :leader
      :prefix "n"
      :desc "TODOs by stata"
      :n "t" (cmd! (org-ql-search (current-buffer)
                     '(todo)
                     :sort '(priority)
                     :super-groups '((:todo "NOW")
                                     (:todo "NEXT")
                                     (:todo "LATER")))))

(after! (eshell em-term)
  (setopt eshell-visual-commands (append eshell-visual-commands '("bat" "htop" "top" "vim" "nvim" "less" "man" "tmux" "watch" "gemini"))
         ;; eshell-visual-subcommands (append eshell-visual-subcommands '(("git" "log" "diff" "show")))
         ;; eshell-visual-options (append eshell-visual-options '(("git" "--help" "--paginate")))
         eshell-destroy-buffer-when-process-dies nil)

  (require 'ghostel-eshell)
  (ghostel-eshell-visual-command-mode +1)

  (add-hook 'eshell-mode-hook (cmd! (eldoc-mode -1)))

  (set-eshell-alias!
   "-" "cd -"
   "..." "../.."
   "...." "../../.."
   "....." "../../../.."
   "w" "type -a $*"
   "j" "jj --no-pager $*"
   "ghre" "guix home reconfigure ~/src/dotfiles/guix/home-configuration.scm"))

(defun +term-auto-normal-state-h (proc _event)
  "Switch to normal state when the term process dies."
  (unless (process-live-p proc)
    (let ((buf (process-buffer proc)))
      (when (buffer-live-p buf)
        (with-current-buffer buf
          (evil-normal-state))))))

(after! term
  (add-hook 'term-exec-hook
            (lambda ()
              (let ((proc (get-buffer-process (current-buffer))))
                (set-process-sentinel proc #'+term-auto-normal-state-h))))

  (map! :map term-mode-map
        :n "q" (cmds! (not (process-live-p (get-buffer-process (current-buffer))))
                      #'kill-current-buffer)))

(after! vterm
  (setopt vterm-kill-buffer-on-exit nil)

  (add-hook 'vterm-exit-functions
            (lambda (buf _event)
              (with-current-buffer buf
                (evil-normal-state))))

  (map! :map vterm-mode-map
        :n "q" (cmds! (not (process-live-p (get-buffer-process (current-buffer))))
                      #'kill-current-buffer)))

(use-package! leetcode
  :config
  (setq leetcode-save-solutions t)
  (setq leetcode-directory "~/Dev/leetcode"))

(use-package! mise
  :config
  (global-mise-mode))

(after! lsp-mode
  (setq lsp-file-watch-ignored-directories
        (append lsp-file-watch-ignored-directories
                '(".local/state"
                  ".local/share"
                  ".local/pipx"
                  ".local/node_modules"))))

(use-package! vc-jj)

(map! :leader :prefix "g" :desc "Run vc-dir-root" :n "v" (cmd! (vc-dir-root)))

(defun jj-st ()
  (interactive)
  (term "jj --no-pager st"))

(defun jj-log ()
  (interactive)
  (term "jj --no-pager log -r 'all()' --limit 50"))

(defun jj-desc ()
  (interactive)
  (term "jj desc"))

(defun jj-new ()
  (interactive)
  (term "jj new"))

(defun jj-commit ()
  (interactive)
  (term "jj commit"))

(add-hook 'after-init-hook 'global-guix-prettify-mode)
(add-hook 'scheme-mode-hook 'guix-devel-mode)

(use-package! org-ql
  :after org
  :commands (org-ql-search org-ql-view))

;; Majutsu: Magit-style interface for Jujutsu
;; https://github.com/0WD0/majutsu
(use-package! majutsu
  :after magit
  :commands (majutsu majutsu-log)
  :config
  ;; Set the jj executable path (auto-detect)
  (setq majutsu-jj-executable (executable-find "jj"))

  ;; Confirm before destructive operations
  (setq majutsu-confirm-critical-actions t)

  ;; Word-level diff refinement for better readability
  (setq majutsu-diff-refine-hunk t))

(map! :leader
      :prefix "g"
      :desc "Majutsu status" "j" #'majutsu
      :desc "Majutsu log" "J" #'majutsu-log)

(map! :leader :desc "EShell popup" :n "'" #'+eshell/toggle)

(after! telega
  (map! :leader :prefix "o" :desc "Telega" :n "T" telega-prefix-map)

  (setopt telega-directory (expand-file-name "telega" (getenv "XDG_STATE_HOME"))))

(use-package! ghostel
  :commands ghostel
  :config

  (setq ghostel-module-auto-install 'download)

  (defadvice! my/ghostel-per-workspace-a (&rest args)
    :around #'ghostel
    (let ((ghostel-buffer-name
           (if (bound-and-true-p persp-mode)
               (format "*ghostel:%s*" (+workspace-current-name))
             ghostel-buffer-name)))
      (apply args)))

  (add-hook 'ghostel-mode-hook
            (lambda ()
              (when (bound-and-true-p persp-mode)
                (persp-add-buffer (current-buffer))))))

(map! :leader
      :desc "Terminal (ghostel)" "o t" #'ghostel
      :desc "Terminal here"      "o T" (cmd! (let ((default-directory
                                                    (or (doom-project-root)
                                                        default-directory)))
                                               (ghostel))))
