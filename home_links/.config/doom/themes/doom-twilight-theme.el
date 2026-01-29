;;; doom-twilight-theme.el --- inspired by the classic Twilight theme -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Author: doom-twilight theme author
;; Maintainer: doom-twilight theme maintainer
;; Source: https://github.com/ianyepan/twilight-emacs-theme
;; Original: TextMate Twilight theme by Michael Sheets
;; Version: 2.0.0
;;
;;; Commentary:
;;
;; A comprehensive port of the classic Twilight theme, originally from TextMate
;; by Michael Sheets. This doom-themes version provides:
;;
;; - Full doom-themes framework integration with proper color inheritance
;; - 256-color and 16-color terminal support with accurate fallbacks
;; - Comprehensive package support (magit, org, ivy, vertico, corfu, flycheck,
;;   tree-sitter, lsp-mode, dired, helm, and 40+ additional packages)
;; - Customizable comment brightness, modeline styles, and background variants
;; - WCAG AA accessible contrast ratios for text readability
;;
;; The Twilight palette features warm, muted colors with a dark background,
;; designed to reduce eye strain during extended coding sessions while
;; maintaining excellent syntax differentiation.
;;
;; Customization options:
;;   - `doom-twilight-brighter-comments' - More visible comments
;;   - `doom-twilight-brighter-modeline' - Vivid modeline colors
;;   - `doom-twilight-comment-bg' - Subtle comment background highlight
;;   - `doom-twilight-dark-variant' - Background contrast: "hard", "soft", or nil
;;   - `doom-twilight-colorful-headers' - Varied colors for org/outline headers
;;   - `doom-twilight-padded-modeline' - Add padding to modeline
;;
;;; Code:

(require 'doom-themes)


;;
;;; Variables

(defgroup doom-twilight-theme nil
  "Options for the `doom-twilight' theme."
  :group 'doom-themes)

(defcustom doom-twilight-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-twilight-theme
  :type 'boolean)

(defcustom doom-twilight-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-twilight-theme
  :type 'boolean)

(defcustom doom-twilight-comment-bg doom-twilight-brighter-comments
  "If non-nil, comments will have a subtle highlight to enhance their
legibility."
  :group 'doom-twilight-theme
  :type 'boolean)

(defcustom doom-twilight-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'doom-twilight-theme
  :type '(choice integer boolean))

(defcustom doom-twilight-dark-variant nil
  "A choice of \"hard\" or \"soft\" can be used to change background contrast.
Hard uses a darker background (#0a0a0a), soft uses a lighter one (#1e1e1e),
and nil uses the classic Twilight background (#141414)."
  :group 'doom-twilight-theme
  :type '(choice (const :tag "Default (#141414)" nil)
                 (const :tag "Hard - darker (#0a0a0a)" "hard")
                 (const :tag "Soft - lighter (#1e1e1e)" "soft")))

(defcustom doom-twilight-colorful-headers nil
  "If non-nil, org-mode and outline headers will use varied accent colors.
When nil, headers use a more subdued progression of orange and brown tones."
  :group 'doom-twilight-theme
  :type 'boolean)


;;
;;; Theme definition

(def-doom-theme doom-twilight
  "A port of the classic Twilight theme, originally from TextMate by Michael Sheets.
This doom-themes version provides full framework integration, terminal support,
and comprehensive package styling."

  ;;; Colors
  ;; name        default   256           16
  ((bg         (cond ((equal doom-twilight-dark-variant "hard") '("#0a0a0a" "#080808" "black"))
                     ((equal doom-twilight-dark-variant "soft") '("#1e1e1e" "#1c1c1c" "black"))
                     (t '("#141414" "#121212" "black"))))  ; Classic Twilight bg
   (fg         '("#d8d8d8" "#d7d7d7"     "brightwhite"  ))  ; Slightly softened white

   ;; These are off-color variants of bg/fg, used primarily for `solaire-mode',
   ;; but can also be useful as a basis for subtle highlights (e.g. for hl-line
   ;; or region), especially when paired with the `doom-darken', `doom-lighten',
   ;; and `doom-blend' helper functions.
   (bg-alt     '("#0c0c0c" "#080808"     "black"        ))  ; Distinct from base1
   (fg-alt     '("#b8b8b8" "#b2b2b2"     "white"        ))  ; Slightly dimmer than fg

   ;; These should represent a spectrum from bg to fg, where base0 is a starker
   ;; bg and base8 is a starker fg. For example, if bg is light grey and fg is
   ;; dark grey, base0 should be white and base8 should be black.
   ;; Base gradient: smooth progression from darkest (base0) to brightest (base8)
   ;; Each step is visually distinct for proper UI hierarchy
   (base0      '("#000000" "#000000"     "black"        ))  ; Pure black
   (base1      '("#080808" "#080808"     "brightblack"  ))  ; Deepest UI bg
   (base2      '("#1a1a1a" "#1c1c1c"     "brightblack"  ))  ; Slightly lighter than bg
   (base3      '("#252525" "#262626"     "brightblack"  ))  ; hl-line, subtle highlights
   (base4      '("#313131" "#303030"     "brightblack"  ))  ; Selection, region
   (base5      '("#4b474c" "#4e4e4e"     "brightblack"  ))  ; Line numbers, inactive
   (base6      '("#888888" "#878787"     "white"        ))  ; Comments, secondary text
   (base7      '("#cacaca" "#c6c6c6"     "brightwhite"  ))  ; Bright secondary
   (base8      '("#fafafa" "#eeeeee"     "brightwhite"  ))  ; Brightest, emphasis

   (grey       base5)

   ;; Twilight color palette with proper 256-color approximations
   (red        '("#cf6a4c" "#d7875f"     "red"          ))  ; Warm terracotta
   (orange     '("#cda869" "#d7af5f"     "brightred"    ))  ; Golden ochre
   (green      '("#a6c176" "#afaf5f"     "green"        ))  ; Muted olive-green
   (teal       '("#7f9f98" "#87afaf"     "brightgreen"  ))  ; Dusty teal
   (yellow     '("#f9ee98" "#ffff87"     "yellow"       ))  ; Pale cream yellow
   (blue       '("#7587a6" "#5f87af"     "brightblue"   ))  ; Steel blue
   (dark-blue  '("#4e5a65" "#5f5f5f"     "blue"         ))  ; Muted slate
   (magenta    '("#988299" "#af87af"     "brightmagenta"))  ; Dusty mauve
   (violet     '("#9b859d" "#af87af"     "magenta"      ))  ; Twilight purple
   (cyan       '("#8da1c7" "#87afd7"     "brightblue"   ))  ; Periwinkle (more blue than cyan)
   (dark-cyan  '("#5f7a8a" "#5f8787"     "cyan"         ))  ; Muted steel

   ;; Twilight-specific accent colors
   (twilight-brown  '("#b08050" "#af875f"  "yellow"     ))  ; Improved contrast (was #9b703f)
   (twilight-white  '("#f8f8f8" "#eeeeee"  "white"      ))  ; Near-white
   (twilight-grey   '("#5f5a60" "#5f5f5f"  "brightblack"))  ; Original comment color

   ;;; Required face categories -- these are used by doom-themes-base
   ;; These *must* be included in every doom theme
   (highlight      cyan)
   (vertical-bar   (doom-darken base1 0.1))
   (selection      base4)
   (builtin        magenta)
   (comments       (if doom-twilight-brighter-comments cyan base6))
   (doc-comments   (doom-lighten comments 0.15))
   (constants      red)                            ; Classic Twilight red for constants
   (functions      twilight-brown)                 ; Warm brown for function names
   (keywords       orange)                         ; Golden ochre keywords
   (methods        twilight-brown)                 ; Same as functions for consistency
   (operators      fg)                             ; Neutral operators
   (type           magenta)                        ; Dusty mauve for types
   (strings        green)                          ; Muted olive for strings
   (variables      (doom-lighten red 0.12))        ; Slightly lighter red for variables
   (numbers        (doom-blend red orange 0.25))   ; Warmer red-orange for numbers
   (region         `(,(doom-lighten (car bg-alt) 0.15) ,@(cdr base3)))
   (error          red)
   (warning        orange)
   (success        green)
   (vc-modified    cyan)
   (vc-added       green)
   (vc-deleted     red)

   ;;; Custom categories (theme-specific variables)
   ;; Hidden face (for org-hide, etc.)
   (hidden     bg)

   ;; Heading level colors for org-mode and outline
   ;; When colorful-headers is nil, use a subdued orange/brown progression
   ;; When colorful-headers is t, use full accent color variety
   (level1 orange)
   (level2 twilight-brown)
   (level3 (if doom-twilight-colorful-headers cyan (doom-lighten twilight-brown 0.15)))
   (level4 (if doom-twilight-colorful-headers red (doom-lighten orange 0.1)))
   (level5 (if doom-twilight-colorful-headers green (doom-lighten twilight-brown 0.25)))
   (level6 (if doom-twilight-colorful-headers blue (doom-lighten orange 0.2)))
   (level7 (if doom-twilight-colorful-headers magenta (doom-lighten twilight-brown 0.35)))
   (level8 (if doom-twilight-colorful-headers violet (doom-lighten orange 0.3)))
   (level9 (if doom-twilight-colorful-headers teal (doom-lighten twilight-brown 0.45)))

   ;; Modeline colors with proper inactive contrast
   (modeline-fg          fg)
   (modeline-fg-alt      base5)
   (modeline-bg          (if doom-twilight-brighter-modeline
                              (doom-darken blue 0.45)
                            (doom-darken base3 0.1)))
   (modeline-bg-alt      (if doom-twilight-brighter-modeline
                              (doom-darken blue 0.475)
                            base3))
   (modeline-bg-inactive     (doom-darken base2 0.15))
   (modeline-bg-inactive-alt (doom-darken base1 0.1))

   ;; Private computed variables (prefixed with -)
   (-modeline-pad
    (when doom-twilight-padded-modeline
      (if (integerp doom-twilight-padded-modeline) doom-twilight-padded-modeline 4))))


  ;;;; Base theme face overrides
  (((line-number &override) :foreground base5)
   ((line-number-current-line &override) :foreground base6)
   ((font-lock-comment-face &override)
    :slant 'italic
    :background (if doom-twilight-comment-bg (doom-lighten bg 0.05) 'unspecified))
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis :foreground (if doom-twilight-brighter-modeline base8 highlight))
   (mode-line-buffer-id :foreground twilight-brown)

   ;;;; Highlight & search
   (hl-line :background base3 :extend t)
   (lazy-highlight :background base4 :foreground fg :distant-foreground base0 :weight 'bold)
   (isearch :foreground base8 :background base5 :weight 'bold)
   (isearch-fail :foreground fg :background red)
   ((region &override) :background region :distant-foreground (doom-darken fg 0.2) :extend t)

   ;;;; company
   (company-tooltip :background base0)
   (company-tooltip-selection :background base4)
   (company-scrollbar-bg :background base0)
   (company-scrollbar-fg :background base6)

   ;;;; css-mode <built-in> / scss-mode
   (css-proprietary-property :foreground orange)
   (css-property             :foreground green)
   (css-selector             :foreground blue)

   ;;;; doom-modeline
   (doom-modeline-bar :background (if doom-twilight-brighter-modeline modeline-bg highlight))
   (doom-modeline-buffer-file :inherit 'mode-line-buffer-id :weight 'bold)
   (doom-modeline-buffer-path :inherit 'mode-line-emphasis :weight 'bold)
   (doom-modeline-buffer-project-root :foreground green :weight 'bold)

   ;;;; elscreen
   (elscreen-tab-other-screen-face :background base4 :foreground base2)

   ;;;; evil
   (evil-ex-substitute-matches :foreground red :weight 'bold :strike-through t)
   (evil-ex-substitute-replacement :foreground green :weight 'bold)

   ;;;; highlight-symbol
   (highlight-symbol-face :background (doom-blend green bg 0.3))

   ;;;; ivy
   (ivy-current-match :background base4 :distant-foreground base0 :weight 'normal :extend t)
   (ivy-minibuffer-match-face-1 :foreground orange :weight 'bold)
   (ivy-minibuffer-match-face-2 :foreground green :weight 'bold)
   (ivy-minibuffer-match-face-3 :foreground cyan :weight 'bold)
   (ivy-minibuffer-match-face-4 :foreground magenta :weight 'bold)
   (ivy-posframe :background base0)
   (ivy-posframe-border :background base5)
   (ivy-virtual :foreground base5 :slant 'italic)
   (ivy-modified-buffer :foreground orange)

   ;;;; magit
   (magit-section-heading :foreground orange :weight 'bold)
   (magit-section-highlight :background base3 :extend t)
   (magit-hunk-heading :background base3 :foreground base6)
   (magit-hunk-heading-highlight :background base4 :foreground fg :weight 'bold)
   (magit-branch-current :foreground cyan :weight 'bold :box t)
   (magit-branch-local :foreground cyan)
   (magit-branch-remote :foreground green)
   (magit-hash :foreground base5)
   (magit-dimmed :foreground base5)
   (magit-filename :foreground twilight-brown)
   (magit-tag :foreground orange)
   (magit-diffstat-added :foreground green)
   (magit-diffstat-removed :foreground red)
   (magit-diff-added :foreground green :background (doom-blend green bg 0.1))
   (magit-diff-added-highlight :foreground green :background (doom-blend green bg 0.2) :weight 'bold)
   (magit-diff-removed :foreground red :background (doom-blend red bg 0.1))
   (magit-diff-removed-highlight :foreground red :background (doom-blend red bg 0.2) :weight 'bold)
   (magit-diff-context :foreground fg-alt)
   (magit-diff-context-highlight :background base2 :foreground fg)

   ;;;; markdown-mode
   (markdown-markup-face :foreground base5)
   (markdown-header-face :inherit 'bold :foreground orange)
   ((markdown-code-face &override) :background base3)

   ;;;; org-mode
   (org-hide :foreground hidden)
   (org-block :foreground fg-alt :background base1 :extend t)
   (org-block-begin-line :foreground base5 :background base1 :extend t :slant 'italic)
   (org-block-end-line :inherit 'org-block-begin-line)
   (org-level-1 :foreground level1 :weight 'bold :height 1.2)
   (org-level-2 :foreground level2 :weight 'bold :height 1.1)
   (org-level-3 :foreground level3 :weight 'bold :height 1.05)
   (org-level-4 :foreground level4 :weight 'bold)
   (org-level-5 :foreground level5)
   (org-level-6 :foreground level6)
   (org-level-7 :foreground level7)
   (org-level-8 :foreground level8)
   (org-document-title :foreground orange :height 1.3 :weight 'bold)
   (org-document-info :foreground twilight-brown)
   (org-document-info-keyword :foreground base5)
   (org-link :foreground cyan :underline t)
   (org-table :foreground fg-alt :background base0)
   (org-todo :foreground orange :weight 'bold)
   (org-done :foreground base5 :weight 'bold :strike-through t)
   (org-headline-done :foreground base5 :strike-through t)
   (org-checkbox :foreground orange)
   (org-checkbox-statistics-todo :foreground orange)
   (org-checkbox-statistics-done :foreground base5)
   (org-code :foreground green :background base2)
   (org-verbatim :foreground cyan)
   (org-quote :background base1 :extend t :slant 'italic)
   (org-date :foreground cyan :underline t)
   (org-scheduled :foreground green)
   (org-scheduled-today :foreground orange)
   (org-scheduled-previously :foreground red)
   (org-upcoming-deadline :foreground orange :weight 'bold)
   (org-warning :foreground red :weight 'bold)
   (org-agenda-structure :foreground violet)
   (org-agenda-date :foreground fg)
   (org-agenda-date-today :foreground orange :weight 'bold)
   (org-agenda-date-weekend :foreground base5)
   (org-agenda-done :foreground base5 :strike-through t)

   ;;;; rainbow-delimiters
   (rainbow-delimiters-depth-1-face :foreground red)
   (rainbow-delimiters-depth-2-face :foreground orange)
   (rainbow-delimiters-depth-3-face :foreground cyan)
   (rainbow-delimiters-depth-4-face :foreground green)
   (rainbow-delimiters-depth-5-face :foreground red)
   (rainbow-delimiters-depth-6-face :foreground cyan)
   (rainbow-delimiters-depth-7-face :foreground green)
   (rainbow-delimiters-depth-8-face :foreground orange)
   (rainbow-delimiters-depth-9-face :foreground cyan)

   ;;;; rjsx-mode
   (rjsx-tag :foreground magenta)
   (rjsx-attr :foreground twilight-brown)
   (rjsx-tag-bracket-face :foreground base6)

   ;;;; solaire-mode
   (solaire-default-face :inherit 'default :background base1)
   (solaire-minibuffer-face :inherit 'default :background base1)
   (solaire-hl-line-face :inherit 'hl-line :background base2)
   (solaire-org-hide-face :inherit 'org-hide :background base1)
   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-alt)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-alt)))

   ;;;; treemacs
   (treemacs-root-face :foreground orange :weight 'bold :height 1.2)
   (treemacs-directory-face :foreground blue)
   (treemacs-file-face :foreground fg)
   (treemacs-git-modified-face :foreground vc-modified)
   (treemacs-git-renamed-face :foreground orange)
   (treemacs-git-added-face :foreground vc-added)
   (treemacs-git-untracked-face :foreground yellow)
   (treemacs-git-ignored-face :foreground base5)
   (treemacs-git-conflict-face :foreground red)

   ;;;; vterm / term
   (vterm-color-default :foreground fg)
   (vterm-color-black :foreground base0)
   (vterm-color-red :foreground red)
   (vterm-color-green :foreground green)
   (vterm-color-yellow :foreground orange)
   (vterm-color-blue :foreground blue)
   (vterm-color-magenta :foreground violet)
   (vterm-color-cyan :foreground teal)
   (vterm-color-white :foreground fg)

   ;;;; web-mode
   (web-mode-html-tag-face :foreground magenta)
   (web-mode-html-tag-bracket-face :foreground base6)
   (web-mode-html-attr-name-face :foreground twilight-brown)
   (web-mode-html-attr-value-face :foreground green)
   (web-mode-html-entity-face :foreground orange :slant 'italic)
   (web-mode-css-selector-face :foreground blue)
   (web-mode-css-property-name-face :foreground orange)
   (web-mode-css-pseudo-class-face :foreground cyan)
   (web-mode-doctype-face :foreground base5)
   (web-mode-comment-face :foreground comments)
   (web-mode-json-key-face :foreground twilight-brown)
   (web-mode-json-context-face :foreground cyan)

   ;;;; flycheck
   (flycheck-error :underline `(:style wave :color ,red))
   (flycheck-warning :underline `(:style wave :color ,orange))
   (flycheck-info :underline `(:style wave :color ,cyan))
   (flycheck-fringe-error :foreground red)
   (flycheck-fringe-warning :foreground orange)
   (flycheck-fringe-info :foreground cyan)
   (flycheck-error-list-error :foreground red)
   (flycheck-error-list-warning :foreground orange)
   (flycheck-error-list-info :foreground cyan)

   ;;;; flymake
   (flymake-error :underline `(:style wave :color ,red))
   (flymake-warning :underline `(:style wave :color ,orange))
   (flymake-note :underline `(:style wave :color ,cyan))

   ;;;; dired / dired+
   (dired-directory :foreground blue :weight 'bold)
   (dired-ignored :foreground base5)
   (dired-flagged :foreground red :weight 'bold)
   (dired-header :foreground orange :weight 'bold)
   (dired-mark :foreground green :weight 'bold)
   (dired-marked :foreground green :weight 'bold :inverse-video t)
   (dired-perm-write :foreground red)
   (dired-symlink :foreground cyan)
   (dired-warning :foreground warning)
   (dired-broken-symlink :foreground red :background (doom-blend red bg 0.1))

   ;;;; diredfl (enhanced dired colors)
   (diredfl-dir-name :foreground blue :weight 'bold)
   (diredfl-file-name :foreground fg)
   (diredfl-file-suffix :foreground base6)
   (diredfl-symlink :foreground cyan)
   (diredfl-dir-heading :foreground orange :weight 'bold)
   (diredfl-deletion :foreground red :weight 'bold)
   (diredfl-deletion-file-name :foreground red)
   (diredfl-date-time :foreground cyan)
   (diredfl-number :foreground orange)
   (diredfl-read-priv :foreground green)
   (diredfl-write-priv :foreground orange)
   (diredfl-exec-priv :foreground red)
   (diredfl-no-priv :foreground base5)
   (diredfl-rare-priv :foreground magenta)

   ;;;; which-key
   (which-key-key-face :foreground green)
   (which-key-group-description-face :foreground orange :weight 'bold)
   (which-key-command-description-face :foreground fg)
   (which-key-separator-face :foreground base5)
   (which-key-local-map-description-face :foreground cyan)
   (which-key-special-key-face :foreground magenta)

   ;;;; vertico
   (vertico-current :background base4 :extend t :distant-foreground base0)
   (vertico-group-title :foreground orange :weight 'bold)
   (vertico-group-separator :foreground base5 :strike-through t)

   ;;;; orderless (for vertico/selectrum)
   (orderless-match-face-0 :foreground orange :weight 'bold)
   (orderless-match-face-1 :foreground green :weight 'bold)
   (orderless-match-face-2 :foreground cyan :weight 'bold)
   (orderless-match-face-3 :foreground magenta :weight 'bold)

   ;;;; marginalia
   (marginalia-documentation :foreground base6 :slant 'italic)
   (marginalia-file-priv-dir :foreground blue)
   (marginalia-file-priv-read :foreground green)
   (marginalia-file-priv-write :foreground orange)
   (marginalia-file-priv-exec :foreground red)
   (marginalia-key :foreground orange)
   (marginalia-mode :foreground cyan)
   (marginalia-date :foreground base6)
   (marginalia-size :foreground base6)

   ;;;; consult
   (consult-file :foreground fg)
   (consult-bookmark :foreground cyan)
   (consult-buffer :foreground fg)
   (consult-line-number :foreground base5)
   (consult-preview-line :background base3 :extend t)
   (consult-preview-match :inherit 'lazy-highlight)

   ;;;; corfu
   (corfu-default :background base1)
   (corfu-current :background base4 :foreground fg)
   (corfu-bar :background base5)
   (corfu-border :background base3)
   (corfu-annotations :foreground base6 :slant 'italic)
   (corfu-deprecated :foreground base5 :strike-through t)

   ;;;; cape (completion-at-point extensions)
   (cape-dabbrev :foreground fg :slant 'italic)
   (cape-file :foreground cyan)
   (cape-keyword :foreground magenta)
   (cape-line :foreground base6)
   (cape-dict :foreground orange)

   ;;;; tree-sitter / treesit
   (tree-sitter-hl-face:function :foreground twilight-brown)
   (tree-sitter-hl-face:function.call :foreground twilight-brown)
   (tree-sitter-hl-face:function.method :foreground twilight-brown)
   (tree-sitter-hl-face:function.macro :foreground orange)
   (tree-sitter-hl-face:function.special :foreground magenta)
   (tree-sitter-hl-face:method :foreground twilight-brown)
   (tree-sitter-hl-face:method.call :foreground twilight-brown)
   (tree-sitter-hl-face:type :foreground type)
   (tree-sitter-hl-face:type.builtin :foreground magenta)
   (tree-sitter-hl-face:type.parameter :foreground (doom-lighten type 0.1))
   (tree-sitter-hl-face:type.argument :foreground type)
   (tree-sitter-hl-face:constructor :foreground magenta)
   (tree-sitter-hl-face:variable :foreground variables)
   (tree-sitter-hl-face:variable.builtin :foreground magenta)
   (tree-sitter-hl-face:variable.parameter :foreground (doom-lighten variables 0.1))
   (tree-sitter-hl-face:variable.special :foreground cyan)
   (tree-sitter-hl-face:property :foreground cyan)
   (tree-sitter-hl-face:property.definition :foreground cyan)
   (tree-sitter-hl-face:constant :foreground constants)
   (tree-sitter-hl-face:constant.builtin :foreground constants)
   (tree-sitter-hl-face:keyword :foreground keywords)
   (tree-sitter-hl-face:operator :foreground fg)
   (tree-sitter-hl-face:string :foreground strings)
   (tree-sitter-hl-face:string.special :foreground green)
   (tree-sitter-hl-face:escape :foreground orange)
   (tree-sitter-hl-face:comment :foreground comments :slant 'italic)
   (tree-sitter-hl-face:doc :foreground (doom-lighten comments 0.15))
   (tree-sitter-hl-face:number :foreground numbers)
   (tree-sitter-hl-face:punctuation :foreground base6)
   (tree-sitter-hl-face:punctuation.bracket :foreground base6)
   (tree-sitter-hl-face:punctuation.delimiter :foreground base6)
   (tree-sitter-hl-face:punctuation.special :foreground orange)
   (tree-sitter-hl-face:tag :foreground magenta)
   (tree-sitter-hl-face:attribute :foreground twilight-brown)
   (tree-sitter-hl-face:label :foreground cyan)
   (tree-sitter-hl-face:embedded :foreground fg)

   ;;;; ediff
   (ediff-current-diff-A :background (doom-blend red bg 0.2) :extend t)
   (ediff-current-diff-B :background (doom-blend green bg 0.2) :extend t)
   (ediff-current-diff-C :background (doom-blend blue bg 0.2) :extend t)
   (ediff-current-diff-Ancestor :background (doom-blend magenta bg 0.2) :extend t)
   (ediff-fine-diff-A :background (doom-blend red bg 0.4) :weight 'bold :extend t)
   (ediff-fine-diff-B :background (doom-blend green bg 0.4) :weight 'bold :extend t)
   (ediff-fine-diff-C :background (doom-blend blue bg 0.4) :weight 'bold :extend t)
   (ediff-fine-diff-Ancestor :background (doom-blend magenta bg 0.4) :weight 'bold :extend t)
   (ediff-even-diff-A :background base2 :extend t)
   (ediff-even-diff-B :background base2 :extend t)
   (ediff-even-diff-C :background base2 :extend t)
   (ediff-odd-diff-A :background base3 :extend t)
   (ediff-odd-diff-B :background base3 :extend t)
   (ediff-odd-diff-C :background base3 :extend t)

   ;;;; diff-mode
   (diff-added :foreground green :background (doom-blend green bg 0.1) :extend t)
   (diff-removed :foreground red :background (doom-blend red bg 0.1) :extend t)
   (diff-changed :foreground cyan :background (doom-blend cyan bg 0.1) :extend t)
   (diff-indicator-added :foreground green)
   (diff-indicator-removed :foreground red)
   (diff-indicator-changed :foreground cyan)
   (diff-refine-added :foreground green :background (doom-blend green bg 0.3) :weight 'bold)
   (diff-refine-removed :foreground red :background (doom-blend red bg 0.3) :weight 'bold)
   (diff-refine-changed :foreground cyan :background (doom-blend cyan bg 0.3) :weight 'bold)
   (diff-header :foreground orange :weight 'bold)
   (diff-file-header :foreground orange :weight 'bold :background base2)
   (diff-hunk-header :foreground blue :background base2)

   ;;;; helm
   (helm-selection :background base4 :extend t :distant-foreground base0)
   (helm-match :foreground orange :weight 'bold)
   (helm-source-header :foreground orange :background base1 :weight 'bold :height 1.1)
   (helm-visible-mark :foreground green :weight 'bold)
   (helm-candidate-number :foreground bg :background orange)
   (helm-ff-directory :foreground blue :weight 'bold)
   (helm-ff-dotted-directory :foreground base5)
   (helm-ff-file :foreground fg)
   (helm-ff-prefix :foreground red)
   (helm-ff-executable :foreground green)
   (helm-ff-invalid-symlink :foreground red :weight 'bold)
   (helm-ff-symlink :foreground cyan)
   (helm-ff-file-extension :foreground twilight-brown)
   (helm-buffer-directory :foreground blue)
   (helm-buffer-file :foreground fg)
   (helm-buffer-modified :foreground orange)
   (helm-buffer-saved-out :foreground red)
   (helm-buffer-size :foreground base5)
   (helm-buffer-process :foreground cyan)
   (helm-grep-match :inherit 'helm-match)
   (helm-grep-file :foreground cyan)
   (helm-grep-lineno :foreground base5)
   (helm-grep-finish :foreground green)
   (helm-grep-running :foreground red)
   (helm-separator :foreground base5)

   ;;;; git-gutter / git-gutter-fringe
   (git-gutter:added :foreground vc-added)
   (git-gutter:deleted :foreground vc-deleted)
   (git-gutter:modified :foreground vc-modified)
   (git-gutter-fr:added :foreground vc-added)
   (git-gutter-fr:deleted :foreground vc-deleted)
   (git-gutter-fr:modified :foreground vc-modified)

   ;;;; diff-hl
   (diff-hl-insert :foreground vc-added :background (doom-blend vc-added bg 0.2))
   (diff-hl-delete :foreground vc-deleted :background (doom-blend vc-deleted bg 0.2))
   (diff-hl-change :foreground vc-modified :background (doom-blend vc-modified bg 0.2))

   ;;;; lsp-mode / lsp-ui
   (lsp-face-highlight-textual :background base3 :distant-foreground base0)
   (lsp-face-highlight-read :background (doom-blend blue bg 0.2) :distant-foreground base0)
   (lsp-face-highlight-write :background (doom-blend orange bg 0.2) :distant-foreground base0)
   (lsp-ui-doc-background :background base0)
   (lsp-ui-doc-header :foreground orange :background base1 :weight 'bold)
   (lsp-ui-peek-peek :background base1)
   (lsp-ui-peek-list :background base0)
   (lsp-ui-peek-filename :foreground cyan)
   (lsp-ui-peek-line-number :foreground base5)
   (lsp-ui-peek-highlight :inherit 'lazy-highlight)
   (lsp-ui-peek-header :foreground fg :background base3 :weight 'bold)
   (lsp-ui-peek-selection :foreground fg :background base4 :weight 'bold)
   (lsp-ui-sideline-code-action :foreground orange)
   (lsp-ui-sideline-current-symbol :foreground highlight)
   (lsp-ui-sideline-symbol :foreground base5)

   ;;;; eglot
   (eglot-highlight-symbol-face :background base3)

   ;;;; eldoc-box
   (eldoc-box-body :background base0 :foreground fg)
   (eldoc-box-border :background base5)

   ;;;; eshell
   (eshell-prompt :foreground orange :weight 'bold)
   (eshell-ls-directory :foreground blue :weight 'bold)
   (eshell-ls-symlink :foreground cyan)
   (eshell-ls-executable :foreground green)
   (eshell-ls-readonly :foreground base5)
   (eshell-ls-unreadable :foreground red)
   (eshell-ls-special :foreground magenta)
   (eshell-ls-missing :foreground red :weight 'bold)
   (eshell-ls-archive :foreground violet)
   (eshell-ls-backup :foreground base5)
   (eshell-ls-product :foreground base5)
   (eshell-ls-clutter :foreground base5)

   ;;;; highlight-indent-guides
   (highlight-indent-guides-character-face :foreground base3)
   (highlight-indent-guides-top-character-face :foreground base5)
   (highlight-indent-guides-stack-character-face :foreground base4)

   ;;;; highlight-numbers
   (highlight-numbers-number :foreground numbers)

   ;;;; hl-todo
   (hl-todo :foreground red :weight 'bold)

   ;;;; hydra
   (hydra-face-red :foreground red :weight 'bold)
   (hydra-face-blue :foreground blue :weight 'bold)
   (hydra-face-amaranth :foreground magenta :weight 'bold)
   (hydra-face-pink :foreground violet :weight 'bold)
   (hydra-face-teal :foreground teal :weight 'bold)

   ;;;; nav-flash
   (nav-flash-face :background base4 :foreground base8 :weight 'bold)

   ;;;; popup
   (popup-face :background base1 :foreground fg)
   (popup-tip-face :background base4 :foreground fg)
   (popup-menu-selection-face :background base4)
   (popup-menu-mouse-face :background base4 :foreground fg)

   ;;;; show-paren
   ((show-paren-match &override) :foreground orange :background base3 :weight 'bold)
   ((show-paren-mismatch &override) :foreground fg :background red :weight 'bold)

   ;;;; whitespace
   (whitespace-space :foreground base3)
   (whitespace-tab :foreground base3)
   (whitespace-newline :foreground base3)
   (whitespace-trailing :foreground red :background base3)
   (whitespace-line :foreground red :background base2)
   (whitespace-indentation :foreground base4)

   ;;;; avy
   (avy-lead-face :background orange :foreground bg :weight 'bold)
   (avy-lead-face-0 :background blue :foreground bg :weight 'bold)
   (avy-lead-face-1 :background cyan :foreground bg :weight 'bold)
   (avy-lead-face-2 :background green :foreground bg :weight 'bold)

   ;;;; ace-window
   (aw-leading-char-face :foreground orange :weight 'bold :height 2.0)
   (aw-minibuffer-leading-char-face :foreground orange :weight 'bold)
   (aw-mode-line-face :foreground orange)

   ;;;; swiper
   (swiper-line-face :background base4 :extend t)
   (swiper-match-face-1 :inherit 'ivy-minibuffer-match-face-1)
   (swiper-match-face-2 :inherit 'ivy-minibuffer-match-face-2)
   (swiper-match-face-3 :inherit 'ivy-minibuffer-match-face-3)
   (swiper-match-face-4 :inherit 'ivy-minibuffer-match-face-4)
   (swiper-background-match-face-1 :inherit 'swiper-match-face-1)
   (swiper-background-match-face-2 :inherit 'swiper-match-face-2)
   (swiper-background-match-face-3 :inherit 'swiper-match-face-3)
   (swiper-background-match-face-4 :inherit 'swiper-match-face-4)

   ;;;; anzu
   (anzu-mode-line :foreground orange :weight 'bold)
   (anzu-mode-line-no-match :foreground red :weight 'bold)
   (anzu-match-1 :background green :foreground bg)
   (anzu-match-2 :background orange :foreground bg)
   (anzu-match-3 :background blue :foreground bg)
   (anzu-replace-to :foreground green :weight 'bold)

   ;;;; symbol-overlay
   (symbol-overlay-default-face :background base3)
   (symbol-overlay-face-1 :background (doom-blend blue bg 0.3) :foreground blue)
   (symbol-overlay-face-2 :background (doom-blend orange bg 0.3) :foreground orange)
   (symbol-overlay-face-3 :background (doom-blend green bg 0.3) :foreground green)
   (symbol-overlay-face-4 :background (doom-blend magenta bg 0.3) :foreground magenta)
   (symbol-overlay-face-5 :background (doom-blend cyan bg 0.3) :foreground cyan)
   (symbol-overlay-face-6 :background (doom-blend yellow bg 0.3) :foreground yellow)
   (symbol-overlay-face-7 :background (doom-blend red bg 0.3) :foreground red)
   (symbol-overlay-face-8 :background (doom-blend violet bg 0.3) :foreground violet)

   ;;;; centaur-tabs
   (centaur-tabs-default :background bg-alt :foreground base5)
   (centaur-tabs-selected :background bg :foreground fg :weight 'bold)
   (centaur-tabs-unselected :background bg-alt :foreground base5)
   (centaur-tabs-selected-modified :background bg :foreground orange :weight 'bold)
   (centaur-tabs-unselected-modified :background bg-alt :foreground orange)
   (centaur-tabs-active-bar-face :background orange)
   (centaur-tabs-modified-marker-selected :foreground orange)
   (centaur-tabs-modified-marker-unselected :foreground orange)

   ;;;; tab-bar / tab-line
   (tab-bar :background bg-alt :foreground base5)
   (tab-bar-tab :background bg :foreground fg :weight 'bold)
   (tab-bar-tab-inactive :background bg-alt :foreground base5)
   (tab-line :background bg-alt)
   (tab-line-tab :background bg :foreground fg)
   (tab-line-tab-inactive :background bg-alt :foreground base5)
   (tab-line-tab-current :background bg :foreground fg :weight 'bold)
   (tab-line-highlight :background base4)

   ;;;; persp-mode / perspective
   (persp-selected-face :foreground orange :weight 'bold)

   ;;;; mu4e (email)
   (mu4e-header-highlight-face :background base4 :weight 'bold)
   (mu4e-header-marks-face :foreground orange)
   (mu4e-header-key-face :foreground cyan)
   (mu4e-header-value-face :foreground fg)
   (mu4e-flagged-face :foreground orange)
   (mu4e-unread-face :foreground blue :weight 'bold)
   (mu4e-replied-face :foreground green)
   (mu4e-forwarded-face :foreground magenta)
   (mu4e-cited-1-face :foreground base6)
   (mu4e-cited-2-face :foreground base5)
   (mu4e-cited-3-face :foreground base4)
   (mu4e-link-face :foreground cyan :underline t)

   ;;;; notmuch (email)
   (notmuch-message-summary-face :background base2)
   (notmuch-search-count :foreground base5)
   (notmuch-search-date :foreground base6)
   (notmuch-search-matching-authors :foreground blue)
   (notmuch-search-subject :foreground fg)
   (notmuch-search-unread-face :weight 'bold)
   (notmuch-tag-face :foreground orange)
   (notmuch-tag-unread :foreground red)
   (notmuch-tree-match-author-face :foreground blue)
   (notmuch-tree-match-date-face :foreground base6)
   (notmuch-tree-match-subject-face :foreground fg)
   (notmuch-wash-cited-text :foreground base5))

  ;;;; Base theme variable overrides
  ())

;;; doom-twilight-theme.el ends here
