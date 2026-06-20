---
name: doom-theme-creator
description: Create, modify, and design color themes for Doom Emacs using the doom-themes framework. Use when: (1) Creating new doom-themes from scratch, (2) Porting existing color schemes to doom-themes format, (3) Modifying or enhancing existing doom themes, (4) Fixing color issues in doom themes, (5) Working with doom-*-theme.el files, or (6) Designing color palettes for Emacs.
---

# Doom Theme Creator

Create and modify color themes for Doom Emacs. This skill covers the `def-doom-theme` macro, required color variables, face overrides, and color design principles.

## References

This skill includes detailed reference files for specific tasks:

- **[references/color-design-guide.md](references/color-design-guide.md)** - Read when:
  - Designing a new color palette from scratch
  - Porting a theme from another editor (Solarized, Dracula, Catppuccin principles)
  - Troubleshooting terminal/TUI color issues
  - Need WCAG accessibility guidance or color blindness considerations
  - Understanding CIELAB color space for professional palettes

- **[references/base-faces-reference.md](references/base-faces-reference.md)** - Read when:
  - Overriding specific Emacs faces (mode-line, org-mode, magit, etc.)
  - Need to know what faces map to which color variables
  - Looking for face override examples and patterns
  - Customizing package-specific faces (Company, Ivy, Helm)

## Theme File Structure

```elisp
;;; doom-mytheme-theme.el --- Description -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Author: Your Name <https://github.com/username>
;; Maintainer: Your Name <https://github.com/username>
;;
;;; Commentary:
;; Theme description.
;;
;;; Code:

(require 'doom-themes)

;;; Variables (optional customization options)
(defgroup doom-mytheme-theme nil
  "Options for the `doom-mytheme' theme."
  :group 'doom-themes)

(defcustom doom-mytheme-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-mytheme-theme
  :type 'boolean)

;;; Theme Definition
(def-doom-theme doom-mytheme
  "A dark theme inspired by X."
  :family 'doom-mytheme
  :background-mode 'dark  ; or 'light

  ;; Color palette (REQUIRED)
  ((bg         '("#282c34" "#282c34" "black"))
   (fg         '("#bbc2cf" "#bfbfbf" "brightwhite"))
   ;; ... more colors
   )

  ;; Face overrides (optional)
  ((face-name :foreground red :background bg))

  ;; Variable overrides (optional, usually empty)
  ())

;;; doom-mytheme-theme.el ends here
```

## Color Format

Colors use 3-element lists for cross-terminal support:
```elisp
(color-name '("#HEX-GUI" "#HEX-256" "16-color-name"))
;;            ^^^^^^^^   ^^^^^^^^^  ^^^^^^^^^^^^^^^
;;            GUI/True   256-color  16-color terminal
;;            color      terminal   (black, red, green, etc.)
```

**16-color names:** black, red, green, yellow, blue, magenta, cyan, white, brightblack, brightred, brightgreen, brightyellow, brightblue, brightmagenta, brightcyan, brightwhite

## Required Color Variables

Every theme MUST define these. Use `doom-darken`, `doom-lighten`, `doom-blend` to derive related colors.

### Base Colors
| Variable | Purpose |
|----------|---------|
| `bg` | Main background |
| `bg-alt` | Alternate background (sidebars, hl-line) |
| `fg` | Main text color |
| `fg-alt` | Dimmed text |
| `base0`-`base8` | 9-step gradient (dark to light for dark themes) |
| `grey` | Typically `base4` or similar mid-gray |

### Accent Colors
| Variable | Purpose |
|----------|---------|
| `red` | Errors, deletions |
| `orange` | Numbers, constants |
| `green` | Strings, success |
| `teal` | Secondary green/cyan |
| `yellow` | Warnings, types |
| `blue` | Keywords, links |
| `dark-blue` | Selection backgrounds |
| `magenta` | Builtins |
| `violet` | Constants |
| `cyan` | Methods |
| `dark-cyan` | Alternate cyan |

### Syntax Highlighting
| Variable | Purpose |
|----------|---------|
| `builtin` | Built-in functions (often `magenta`) |
| `comments` | Comment text |
| `doc-comments` | Documentation comments |
| `constants` | Constant values (often `violet`) |
| `functions` | Function names (often `magenta` or `cyan`) |
| `keywords` | Language keywords (often `blue`) |
| `methods` | Method names (often `cyan`) |
| `operators` | Operators |
| `type` | Type names (often `yellow`) |
| `strings` | String literals (often `green`) |
| `variables` | Variable names (often `fg`) |
| `numbers` | Numeric literals (often `orange`) |

### UI Elements
| Variable | Purpose |
|----------|---------|
| `highlight` | General highlight (often `blue`) |
| `vertical-bar` | Window divider |
| `selection` | Selection background (often `dark-blue`) |
| `region` | Region/selection face |
| `error` | Error state (often `red`) |
| `warning` | Warning state (often `yellow`) |
| `success` | Success state (often `green`) |
| `vc-modified` | Version control modified |
| `vc-added` | Version control added |
| `vc-deleted` | Version control deleted |

## Color Manipulation Functions

```elisp
;; Darken: 0.0 = no change, 1.0 = pure black
(doom-darken red 0.2)

;; Lighten: 0.0 = no change, 1.0 = pure white  
(doom-lighten bg 0.05)

;; Blend: 1.0 = pure color1, 0.0 = pure color2
(doom-blend blue bg 0.2)  ; 20% blue, 80% background
```

## Face Override Syntax

> For a complete list of base faces, font-lock faces, and package-specific faces with override examples, see [references/base-faces-reference.md](references/base-faces-reference.md).

```elisp
;; Basic override
(face-name :foreground red :background bg :weight 'bold)

;; Override existing base face (add &override)
((line-number &override) :foreground base4)

;; Inherit from another face
((tab-bar &inherit tab-line))

;; Extend a face with additional properties
((centaur-tabs-default &extend tab-bar) :box nil)

;; Mode-specific (dark/light variants)
(lazy-highlight
 (&dark  :background (doom-darken highlight 0.3) :foreground base8)
 (&light :background (doom-blend bg highlight 0.7) :foreground base0))
```

## Color Design Principles

> For in-depth color theory, Solarized/Dracula/Catppuccin principles, and accessibility guidelines, see [references/color-design-guide.md](references/color-design-guide.md).

### Contrast Guidelines
- **Body text:** 4.5:1 minimum contrast ratio (WCAG AA)
- **Large text/headings:** 3:1 minimum
- Reduce brightness contrast, retain hue contrast (Solarized principle)
- Dark themes: `bg` should be 15-25% lightness, `fg` should be 85-95%
- Light themes: invert the relationship

### Base Gradient (base0-base8)
For dark themes, create a smooth progression:
```
base0: Darkest (near bg, for subtle backgrounds)
base1-base3: Dark range (borders, inactive elements)
base4: Middle gray (line numbers, comments base)
base5-base7: Light range (secondary text)
base8: Lightest (emphasized text, headings)
```

For light themes, reverse this progression.

### Color Harmony Approaches
1. **Analogous:** Colors adjacent on wheel (cohesive, low contrast)
2. **Complementary:** Opposite colors (high contrast, use sparingly)
3. **Triadic:** Three equidistant colors (balanced, vibrant)
4. **Split-complementary:** Base + two adjacent to complement

### Terminal (TUI) Considerations

> For detailed ANSI mapping, 256-color approximation, and terminal testing checklists, see [references/color-design-guide.md](references/color-design-guide.md).

- Always provide 256-color and 16-color fallbacks
- Test in actual terminal emulators, not just GUI
- 16-color palette is constrained; map to closest semantic match
- Avoid relying solely on color; use bold/italic for distinction
- ANSI color mapping for terminals:
  ```
  0=black, 1=red, 2=green, 3=yellow, 4=blue, 
  5=magenta, 6=cyan, 7=white (and bright variants 8-15)
  ```

### Semantic Consistency
Apply same colors for same meanings across all contexts:
| Meaning | Typical Color |
|---------|---------------|
| Errors, deletions, danger | Red |
| Success, additions, strings | Green |
| Warnings, caution | Yellow/Orange |
| Information, links, keywords | Blue |
| Special, constants | Purple/Violet |
| Support, regex, secondary | Cyan |

## Common Patterns

### Brighter Comments Option
```elisp
(defcustom doom-mytheme-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-mytheme-theme
  :type 'boolean)

;; In palette:
(comments (if doom-mytheme-brighter-comments
              (doom-lighten base4 0.1)
            base4))
```

### Padded Modeline
```elisp
(defcustom doom-mytheme-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line."
  :group 'doom-mytheme-theme
  :type '(choice integer boolean))

;; In palette (as private var, prefix with -):
(-modeline-pad (when doom-mytheme-padded-modeline
                 (if (integerp doom-mytheme-padded-modeline)
                     doom-mytheme-padded-modeline
                   4)))

;; In face overrides:
(mode-line :background bg-alt :foreground fg
           :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,bg-alt)))
```

### Light/Dark Mode Switching
```elisp
;; Use &dark and &light specifiers
(default
 (&dark  :background bg :foreground fg)
 (&light :background bg :foreground fg))

(lazy-highlight
 (&dark  :background (doom-darken highlight 0.3))
 (&light :background (doom-blend bg highlight 0.7)))
```


