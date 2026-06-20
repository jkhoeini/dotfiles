# Proposal Exemplar

## Source
- **Doc ID**: `1_HGFT_hAuR8JpDGIOpj4D2hOliXZe98PVGX5S3Yb6hw`
- **Title**: Leveling up foundational recs data quality for unified generative models
- **Type**: Technical proposal / initiative document

## Structure Template

```
# [Full Descriptive Title]

Authors: [Name](mailto:email), [Name](mailto:email), ...
Approvers: [Name](mailto:email), [Name](mailto:email), ...
Reviewers: [Team] ([Subteam]), [Team] ([Subteam]), ...
Last updated: [Month DD, YYYY]
Status: *<Status>*

## Context
[2-3 paragraphs explaining the problem and motivation]
- Link to related docs for background
- State the core requirements with *italicized terms*

## Target State ([Timeframe])
*[Optional: reference to detailed breakdown in appendix]*

• **Outcome 1:** description with specifics
• **Outcome 2:** description with clear criteria
• **Outcome 3:** description with measurable goals
• **Outcome 4:** description with SLOs or metrics
• **Outcome 5:** description with governance/process

## [Implementation Sections as needed]

## Appendix
[Detailed breakdowns, related docs, supporting material]
```

## Key Patterns

### Metadata Block
- Authors: linked names with mailto: emails
- Approvers: same format, separate line
- Reviewers: Team (Subteam) format, comma-separated
- Last updated: "Month DD, YYYY" format
- Status: italicized in angle brackets `*<In Review>*`

### Emphasis
- `*italics*` for technical terms: *presence*, *normalization*, *timeliness*, *governance*
- `**Bold key term:**` description pattern for outcomes
- Underlined links for document references

### Structure
- No cover page - content starts immediately
- Full metadata header block
- Target State with parenthetical timeframe: "Target State (18 Months)"
- Appendix for detailed breakdowns
- Cross-references: "(*see appendix here*)"

### Content Patterns
- "The plan is anchored by four core requirements: *term1* (description), *term2* (description)..."
- Colon-separated bullets: "**Key outcome:** full description..."
- Parenthetical clarifications: "(e.g. native to web)"
- "Without these foundations..." - risk/importance framing
- Consistent definitions used across sections

### Outcomes Format
```
• **Complete timelines:** user journeys stitched end-to-end by event start time, with clear rules for combining events across devices, domains (e.g. native to web), and surfaces
• **Normalized schemas and semantics:** consistent definitions across batch + stream, minimal post-hoc fixes
```

## Sample Text (for few-shot)

### Metadata Header
```
Authors: [Author One](mailto:author1@example.com), [Author Two](mailto:author2@example.com), [Author Three](mailto:author3@example.com)
Approvers: [Approver One](mailto:approver1@example.com), [Approver Two](mailto:approver2@example.com)
Reviewers: Team A (Subteam 1), Team B (Subteam 2), Team C (Subteam 3)
Last updated: Month DD, YYYY
Status: *<In Review>*
```

### Core Requirements Pattern
```
The plan is anchored by four core data quality requirements: *presence* (capturing the full scope and context of user experiences), *normalization* (a shared behavioral language across systems), *timeliness* (data delivery with predictable freshness and measurable guarantees), and *governance* (standards that persist over time).
```

### Risk Framing
```
Without these foundations, the next generation of models are at risk of inheriting the same limitations we see today: incomplete user and content representations, inconsistent instrumentation, and fragmented timelines that prevent generalization across surfaces.
```

---
*Extracted 2026-01-06 from visual + structural analysis*
