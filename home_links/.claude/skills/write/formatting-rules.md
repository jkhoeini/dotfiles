# Google Docs Formatting Rules

Reference guide for professional document formatting when uploading markdown to Google Docs.

## Pre-Upload Checklist

| Check | Action |
|-------|--------|
| YAML frontmatter | Title/subtitle in frontmatter (not `# Title`) |
| Prose-first | Lead sections with prose, not bullets |
| Bold sparingly | Reserve for key terms, not labels or list items |
| No horizontal rules | Never use `---` dividers |
| Light borders | Run `gdocs style-tables <id> light` after upload |

## Anti-Patterns

| Anti-pattern | Problem | Fix |
|--------------|---------|-----|
| `---` dividers | Ugly horizontal rules | Use blank lines and headings |
| Bold in list items | `- **Layer 0** - desc` cluttered | Plain text or italic |
| Em dashes for definitions | `Label — desc` heavy | Use colons |
| Numbered lists in markdown | Renders poorly | Use bullets or prose |
| Bold labels everywhere | `**Label:** value` = noise | Italic labels, H3s, or prose |
| Wall of bullets | Every section just bullets | Lead with 1-2 prose sentences |
| Too many list items | 9+ items = no emphasis | Keep to 2-8 items |
| Multiple blank lines | Using for spacing | Configure paragraph styles |
| Trailing `  ` (two spaces) | Fragmented line breaks | Use proper paragraphs |

## Spacing

Google Docs paragraph styles handle spacing. Never use blank lines for visual separation.

| Action | Result | When |
|--------|--------|------|
| Enter | New paragraph (includes spacing) | Between paragraphs, after headings |
| Shift+Enter | Line break within paragraph | Addresses, items in single bullet |
| Format > Line spacing | Set 1.15 body, 6pt after paragraphs | Configure once via styles |

## List Format Selection

| Content Type | Best Format |
|--------------|-------------|
| 2-3 related items | Inline (comma-separated) |
| 4-8 discrete items | Bulleted list |
| Sequential steps | Numbered list (sparingly) |
| Comparative data (4+) | Table |
| Complex relationships | Prose paragraphs |

## List Styling

| Rule | Why | How |
|------|-----|-----|
| Use disc bullets (●) | Dashes look informal | Markdown `-` becomes discs |
| Paragraph spacing | Blank lines fragment | Use `spaceAbove`/`spaceBelow` |
| No empty paragraphs | Visual clutter | Delete blanks, use spacing |

Post-upload: `gdocs fix-bullets <doc_id>`

## Diagrams

ASCII art breaks in Google Docs. Use tables or prose instead.

## Markdown Authoring

**Title/Subtitle**: Use YAML frontmatter, not `# Title`:
```markdown
---
title: Document Title
subtitle: Optional Subtitle
---

**Owner:** Name · **Updated:** Date

## Executive Summary
```

**Headings**:
- `## Section` → HEADING_1
- `### Subsection` → HEADING_2
- Never use `#` for sections
- Never bold inside headings

**Paragraphs**:
- Separate with blank lines
- Never use trailing `  ` for line breaks
- Keep to 3-5 sentences

**Tables**:
- Consistent: all cells bold or none
- Prefer inline for metadata: `**Owner:** Name · **Updated:** Date`
- Reserve tables for 4+ items

## Tables vs Lighter Alternatives

| Content Type | Best Format |
|--------------|-------------|
| Metadata (1-2 pairs) | Inline bold |
| Key-value (2-3 items) | Prose or bold keys |
| Comparable items (4+) | Table |
| Sequential items | Bulleted list |

If table has 2 columns and 2-3 rows, inline is lighter.

## Metadata Labels

Put metadata labels on own paragraph after prose:

```markdown
The milestone delivers a metrics dashboard.

**Scope:** Metrics from Tracking Plan.
```

Not: `The milestone delivers a metrics dashboard. **Scope:** Metrics...`

## Table Borders

After creating documents with tables:
```bash
gdocs style-tables <doc_id> light
```

## Document Inspection

```bash
gdocs inspect <doc_id>   # Show structure
gdocs lint <doc_id>      # Check style rules
gdocs debug <doc_id>     # Debug formatting
```

## Post-Upload Verification

1. Export and review: `gdocs export <id> -o /tmp/check.md`
2. If paragraphs fragmented, check for trailing `  ` spaces
3. Manual fixes: `gdocs fix-headings <id>`, `gdocs fix-tables <id>`
