# Base Faces Reference

Key faces defined in `doom-themes-base.el` that themes inherit. Override sparingly.

## Table of Contents
1. [Core Emacs Faces](#core-emacs-faces)
2. [Font-Lock Faces](#font-lock-faces)
3. [UI Faces](#ui-faces)
4. [Mode-Line Faces](#mode-line-faces)
5. [Common Package Faces](#common-package-faces)
6. [Override Examples](#override-examples)

## Core Emacs Faces

| Face | Default Definition | Common Overrides |
|------|-------------------|------------------|
| `default` | `:background bg :foreground fg` | Rarely override |
| `bold` | `:weight 'bold :foreground base8` | `:foreground` |
| `italic` | `:slant 'italic` | Rarely override |
| `bold-italic` | Inherits both | Rarely override |
| `cursor` | `:background fg` | `:background` |
| `fringe` | `:background bg-alt` | `:background` |
| `region` | `:background region` | `:background`, `:extend t` |
| `highlight` | `:background highlight :foreground base0` | `:background` |
| `hl-line` | `:background bg-alt :extend t` | `:background` |
| `shadow` | `:foreground base5` | `:foreground` |
| `minibuffer-prompt` | `:foreground highlight` | `:foreground` |
| `tooltip` | `:background bg-alt :foreground fg` | Both |
| `link` | `:foreground highlight :underline t :weight 'bold` | `:foreground` |
| `link-visited` | `:foreground violet :underline t :weight 'bold` | `:foreground` |
| `match` | `:foreground green :weight 'bold` | `:foreground`, `:background` |
| `escape-glyph` | `:foreground cyan` | Rarely override |
| `vertical-border` | `:foreground vertical-bar` | `:foreground` |
| `trailing-whitespace` | `:background red` | `:background` |

## Font-Lock Faces

These are syntax highlighting faces. Override to change language highlighting.

| Face | Default | Maps To |
|------|---------|---------|
| `font-lock-builtin-face` | `:foreground builtin` | `builtin` variable |
| `font-lock-comment-face` | `:foreground comments` | `comments` variable |
| `font-lock-comment-delimiter-face` | Inherits comment-face | |
| `font-lock-doc-face` | `:foreground doc-comments` | `doc-comments` variable |
| `font-lock-constant-face` | `:foreground constants` | `constants` variable |
| `font-lock-function-name-face` | `:foreground functions` | `functions` variable |
| `font-lock-keyword-face` | `:foreground keywords` | `keywords` variable |
| `font-lock-string-face` | `:foreground strings` | `strings` variable |
| `font-lock-type-face` | `:foreground type` | `type` variable |
| `font-lock-variable-name-face` | `:foreground variables` | `variables` variable |
| `font-lock-warning-face` | `:foreground warning` | `warning` variable |
| `font-lock-negation-char-face` | `:foreground operators :weight 'bold` | |
| `font-lock-preprocessor-face` | `:foreground operators` | |
| `font-lock-regexp-grouping-backslash` | `:foreground operators` | |
| `font-lock-regexp-grouping-construct` | `:foreground operators` | |

## UI Faces

| Face | Default | Notes |
|------|---------|-------|
| `line-number` | `:foreground base5` | Line numbers in margin |
| `line-number-current-line` | `:foreground fg :weight 'bold` | Current line number |
| `show-paren-match` | `:foreground red :weight 'ultra-bold` | Matching paren |
| `show-paren-mismatch` | `:foreground base0 :background red :weight 'ultra-bold` | Mismatched |
| `isearch` | `:background highlight :foreground base0` | Current search match |
| `lazy-highlight` | `:background dark-blue :foreground base8` | Other search matches |

## Mode-Line Faces

| Face | Default | Common Customization |
|------|---------|---------------------|
| `mode-line` | `:background bg-alt :foreground fg` | Background, box |
| `mode-line-inactive` | `:background bg :foreground base5` | Dimmed version |
| `mode-line-emphasis` | `:foreground highlight` | Emphasized segments |
| `mode-line-highlight` | `:inherit 'highlight` | Rarely override |
| `mode-line-buffer-id` | `:foreground fg :weight 'bold` | Buffer name |
| `header-line` | Similar to mode-line | Top header |

### Mode-Line Box/Padding Pattern
```elisp
;; Add padding to mode-line
(-modeline-pad 4)

(mode-line 
 :background bg-alt :foreground fg
 :box `(:line-width ,-modeline-pad :color ,bg-alt))
```

## Common Package Faces

### Magit
| Face | Default | Override Reason |
|------|---------|-----------------|
| `magit-header-line` | `:background bg-alt` | Match mode-line |
| `magit-section-heading` | `:foreground blue :weight 'bold` | Heading style |
| `magit-diff-added` | `:foreground vc-added` | Diff additions |
| `magit-diff-removed` | `:foreground vc-deleted` | Diff deletions |
| `magit-diff-hunk-heading` | `:background base3` | Hunk headers |

### Org-mode
| Face | Default | Override Reason |
|------|---------|-----------------|
| `org-block` | `:background bg-alt :extend t` | Code block bg |
| `org-block-begin-line` | `:foreground comments` | Block delimiters |
| `org-level-1` through `org-level-8` | Various colors | Heading levels |
| `org-todo` | `:foreground red :weight 'bold` | TODO keywords |
| `org-done` | `:foreground green :weight 'bold` | DONE keywords |

### Company (completion)
| Face | Default | Override Reason |
|------|---------|-----------------|
| `company-tooltip` | `:background bg-alt` | Popup bg |
| `company-tooltip-selection` | `:background region` | Selected item |
| `company-tooltip-annotation` | `:foreground comments` | Type annotations |

### Ivy/Vertico/Helm
Common selection/completion faces often need consistent treatment.

## Override Examples

### Subtle Line Numbers
```elisp
((line-number &override) :foreground base4)
((line-number-current-line &override) :foreground base8 :weight 'bold)
```

### Brighter Comments
```elisp
((font-lock-comment-face &override) 
 :foreground (doom-lighten comments 0.2))
```

### No Background on Region
```elisp
((region &override) :background base3 :extend t)
```

### Custom Mode-Line Style
```elisp
((mode-line &override) 
 :background bg-alt 
 :foreground fg
 :box `(:line-width 4 :color ,bg-alt))
((mode-line-inactive &override)
 :background bg
 :foreground base5
 :box `(:line-width 4 :color ,bg))
```

### Custom Org Heading Colors
```elisp
((org-level-1 &override) :foreground red :weight 'bold :height 1.3)
((org-level-2 &override) :foreground orange :weight 'bold :height 1.2)
((org-level-3 &override) :foreground yellow :weight 'bold :height 1.1)
```

### Mode-Specific Styling
```elisp
(lazy-highlight
 (&dark  :background (doom-darken highlight 0.3) :foreground base8)
 (&light :background (doom-blend bg highlight 0.7) :foreground base0))
```

## Private Variables Convention

Variables starting with `-` are excluded from color detection:
```elisp
;; This won't be treated as a color variable
(-modeline-pad 4)
(-brighter-comments doom-mytheme-brighter-comments)
```

Use this for internal computation values that aren't colors.
