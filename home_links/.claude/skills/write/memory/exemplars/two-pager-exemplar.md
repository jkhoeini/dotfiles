# Two-Pager Exemplar

## Source
- **Doc ID**: `167sHu6tnmNbtO7DMKye0URvudjVWlzuwxnSvdNflZtc`
- **Title**: Towards a PZN Technical North Star
- **Type**: Technical strategy two-pager

## Structure Template

```
[Title Page]
Two-Pager: [Title]

[Content Page]
[Title without prefix]
Authors: [Linked names]
Date: [Month DD, YYYY]

# Background
[1-2 paragraphs: purpose, goals numbered (1), (2)]

# A Tentative [Topic]
[One-line thesis with ***triple emphasis*** on key phrase]

Breakdown:
• **Term.** Description with (*italicized references*). **Illustrative goal:** Metric.
• **Term.** Description. **Illustrative goals:** Multiple metrics.
• **Term.** Description. **Illustrative goal:** Metric.

# [Dimensions/Details]
[Intro paragraph with "two broad buckets" or similar framing]

| Column 1 | Column 2 | Column 3 |
| Category | a. Sub-item | Description with **bold key phrases**. Also: bullet points |

# Complementarities / Conclusion
[How pieces fit together, future direction]
```

## Key Patterns

### Emphasis
- `***triple emphasis***` for thesis/core concepts (bold+italic+underline)
- `**Bold lead word.**` for breakdown items
- `(*italicized parentheticals*)` for references
- `**bold phrases**` within table cells

### Structure
- Title page with type prefix: "Two-Pager: [Title]"
- Authors as linked names, Date below
- Numbered inline references: "(1) first point, (2) second point"
- H1 sections: Background → Proposal → Details → Synthesis

### Tables
- 3-column format: System | Dimension | Why?
- Light blue header row
- Lettered sub-items: a., b., c., d.
- "Also:" sub-sections with nested bullets
- Left column can span multiple rows for categories

### Content Patterns
- `**Illustrative goal:**` for quantified examples
- "Scaling up X by N% yields M% increase" - metric placeholders
- "(likely ~1-2)" - parenthetical estimates
- "deliberately fuzzy" - acknowledging approximation
- Dual framing: "think fast" vs "think slow"

## Sample Text (for few-shot)

### Thesis Statement
```
A high-level description of our technical North Star would be: ***scalable, steerable and reasoned personalization.***
```

### Breakdown Pattern
```
• **Scalable.** Our core personalization quality follows **scaling laws** across key dimensions (*see below*), and our models are sufficiently consolidated (likely ~1-2) to enable aggressive scaling. **Illustrative goal:** Scaling up our model by N% yields an M% active days increase.
```

### Table Cell Pattern
```
Ability to **scale personalization quality** as a function of **input data richness** (granular behavioral data) vs pre-determined bucketized aggregates

Also:
• Looking across the entire experience vs any single experience
• Leveraging transformers for best-in-class modeling
• Learning how to handle temporal evolutions – tastes, ephemeral vs long-lasting interests, etc.
```

---
*Extracted 2026-01-06 from visual + structural analysis*
