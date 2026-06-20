# Color Design Guide for Doom Themes

Extended guidelines for designing effective color schemes.

## Table of Contents
1. [Color Theory Fundamentals](#color-theory-fundamentals)
2. [Solarized Design Principles](#solarized-design-principles)
3. [Dracula Specification Insights](#dracula-specification-insights)
4. [Catppuccin Approach](#catppuccin-approach)
5. [Terminal Color Mapping](#terminal-color-mapping)
6. [Accessibility Guidelines](#accessibility-guidelines)
7. [Common Mistakes](#common-mistakes)

## Color Theory Fundamentals

### CIELAB Color Space
Professional themes like Solarized use CIELAB (L*a*b*) for perceptually uniform colors:
- **L*** = Lightness (0 = black, 100 = white)
- **a*** = Green-Red axis
- **b*** = Blue-Yellow axis

Benefits:
- Equal numeric differences = equal perceived differences
- Enables symmetric light/dark mode inversion
- Better for calculating contrast

### Lightness Relationships
For dark themes:
- Background (bg): L* ~15-20
- Dimmed text: L* ~45-50
- Body text (fg): L* ~60-65
- Emphasized text: L* ~65-70

For light themes (invert):
- Background: L* ~92-97
- Dimmed text: L* ~50-55
- Body text: L* ~35-40
- Emphasized text: L* ~15-20

### Hue Selection Strategies

**Warm Palette (cozy, energetic):**
- Base hue range: Red → Yellow (0° → 60°)
- Accent with cool colors for contrast

**Cool Palette (calm, professional):**
- Base hue range: Cyan → Blue (180° → 240°)
- Accent with warm colors for highlights

**Neutral Base + Vibrant Accents:**
- Desaturate base colors (base0-base8)
- Keep accent colors (red, green, blue) vibrant
- Most readable for long coding sessions

## Solarized Design Principles

From Ethan Schoonover's Solarized:

### Selective Contrast
> "Black text on white from a computer display is akin to reading a book in direct sunlight"

Reduce brightness contrast while retaining hue contrast:
- Foreground/background contrast: ~4:1 (not 21:1 like pure black/white)
- Syntax highlighting relies on color differences, not brightness

### Symmetric Lightness
Base colors have symmetric L* values that invert perfectly:

| Dark Mode | Light Mode | L* Value |
|-----------|------------|----------|
| base03 (bg) | base3 (bg) | 15 / 97 |
| base02 | base2 | 20 / 92 |
| base01 | base1 | 45 / 65 |
| base00 | base0 | 50 / 60 |

### Unified Accent Colors
Same 8 accent colors work for both modes:
- Yellow: 60° hue, L* ~60
- Orange: ~18° hue, L* ~50
- Red: ~1° hue, L* ~50
- Magenta: ~331° hue, L* ~50
- Violet: ~237° hue, L* ~50
- Blue: ~205° hue, L* ~55
- Cyan: ~175° hue, L* ~60
- Green: ~68° hue, L* ~60

## Dracula Specification Insights

From the Dracula theme specification:

### Token Classification (TextMate scoping)

**Primary Tokens:**
- Keywords & Storage → Pink (`#FF79C6`)
- Functions & Methods → Yellow (`#F1FA8C`)
- Classes & Types → Purple (`#BD93F9`)
- Strings & Text → Green (`#50FA7B`)
- Numbers & Constants → Orange (`#FFB86C`)
- Comments → Comment color (`#6272A4`)
- Support & Built-ins → Cyan (`#8BE9FD`)
- Variables → Foreground (`#F8F8F2`)
- Errors → Red (`#FF5555`)

### Styling Modifiers
- **Italic:** Comments, type parameters, documentation
- **Bold:** Strong emphasis (use sparingly)
- **Underline:** Links, misspelled words

### Accessibility Standard
Maintain **4.5:1 minimum contrast ratio** (WCAG 2.1 Level AA)

### Semantic Consistency
> "Same meaning = same color across languages"

A `const` in JavaScript should look the same as `final` in Java.

## Catppuccin Approach

Catppuccin uses 4 flavor variants with consistent naming:

### Color Naming Convention
Instead of generic names, use descriptive terms:
- Rosewater, Flamingo, Pink, Mauve (warm accents)
- Red, Maroon, Peach, Yellow (standard accents)
- Green, Teal, Sky, Sapphire, Blue, Lavender (cool accents)

### Surface Hierarchy
- **Crust:** Darkest background layer
- **Mantle:** Secondary background
- **Base:** Primary background
- **Surface 0-2:** Elevated surfaces (modals, popups)
- **Overlay 0-2:** Overlays on content

### Text Hierarchy
- **Text:** Primary text
- **Subtext 0-1:** Secondary/tertiary text

This naming makes intent clear and helps maintain consistency.

## Terminal Color Mapping

### 16-Color ANSI Palette

```
Standard colors (0-7):
0 = Black     (map to bg or base0)
1 = Red       (map to red)
2 = Green     (map to green)
3 = Yellow    (map to yellow)
4 = Blue      (map to blue)
5 = Magenta   (map to magenta)
6 = Cyan      (map to cyan)
7 = White     (map to fg or base7)

Bright colors (8-15):
8  = Bright Black   (map to base4/grey - comments)
9  = Bright Red     (lighter red)
10 = Bright Green   (lighter green)
11 = Bright Yellow  (lighter yellow)
12 = Bright Blue    (lighter blue)
13 = Bright Magenta (lighter magenta - violet works)
14 = Bright Cyan    (lighter cyan)
15 = Bright White   (map to base8 or bright fg)
```

### 256-Color Approximation
For 256-color terminals, find the closest match:
- Colors 0-15: ANSI palette
- Colors 16-231: 6x6x6 color cube
- Colors 232-255: Grayscale ramp

Tools like `pastel` or online converters can find closest 256-color.

### Terminal Testing Checklist
1. Test in multiple emulators (iTerm2, Alacritty, Terminal.app, etc.)
2. Verify 16-color fallback is readable
3. Check that bold text is distinguishable
4. Test with common TUI apps (htop, vim, tmux)
5. Verify ANSI color vector renders correctly

## Accessibility Guidelines

### WCAG 2.1 Contrast Ratios
| Content Type | Minimum Ratio |
|--------------|---------------|
| Normal text | 4.5:1 |
| Large text (18pt+) | 3:1 |
| UI components | 3:1 |
| Focus indicators | 3:1 |

### Color Vision Deficiency Considerations
~8% of males have some form of color blindness:

**Deuteranopia/Protanopia (red-green):**
- Don't rely solely on red vs green
- Add secondary indicators (underline for errors)
- Use blue instead of green when possible

**Tritanopia (blue-yellow):**
- Less common but consider blue-green confusion
- Ensure sufficient lightness contrast

### Tools for Testing
- Sim Daltonism (macOS)
- Color Oracle (cross-platform)
- WebAIM Contrast Checker

## Common Mistakes

### 1. Insufficient Base Color Steps
**Wrong:** Only defining bg, fg, and 2-3 grays
**Right:** Full base0-base8 gradient for subtle UI differentiation

### 2. Over-Saturated Colors
**Wrong:** Pure, vibrant colors (#FF0000, #00FF00)
**Right:** Slightly desaturated for reduced eye strain

### 3. Ignoring Terminal Fallbacks
**Wrong:** Leaving 256/16 color columns empty or wrong
**Right:** Carefully chosen fallbacks that preserve semantic meaning

### 4. Inconsistent Contrast
**Wrong:** Some text hard to read, some too bright
**Right:** Consistent lightness relationships across all elements

### 5. Mode-Line Visibility
**Wrong:** Mode-line blends with content or is too distracting
**Right:** Clearly distinct but not overwhelming

### 6. Selection/Region Invisibility
**Wrong:** Selection color too similar to background
**Right:** Clear visual distinction (typically 10-15% lighter than bg)

### 7. Forgetting Doc Comments
**Wrong:** doc-comments same as comments
**Right:** doc-comments slightly lighter/different for distinction

### 8. Hardcoding Instead of Deriving
**Wrong:** Manually picking every shade
**Right:** Use doom-darken/lighten/blend for related colors

```elisp
;; Good: derived colors
(doc-comments (doom-lighten comments 0.15))
(region `(,(doom-lighten (car bg-alt) 0.15) ,@(cdr base1)))

;; Bad: hardcoded colors that may not harmonize
(doc-comments '("#889988" "#888888" "white"))
```
