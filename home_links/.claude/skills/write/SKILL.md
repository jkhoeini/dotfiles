---
name: write
description: Use when creating exec updates, RFCs, PRDs, strategy docs, Slack messages, emails, or professional communications. Use /write iterate to address comments on existing documents.
depends: [google-workspace]
---

# /write - Business Writing Skill

Orchestrates the full business writing workflow: interview → context → draft → quality check → deliver → iterate → learn.

**References:**
- `workflow-reference.md` - Detailed phase instructions
- `rfc-reference.md` - Spotify RFC best practices (load when writing RFCs)
- `slides-reference.md` - Presentation deck guidance (load when creating slides)
- `formatting-rules.md` - Google Docs formatting guidance
- `writing-research.md` - Frameworks (Pyramid Principle, SCQA, MECE, Rumelt's Kernel)

## Quick Start

```
/write                     # Start new document (will interview)
/write iterate <doc-url>   # Iterate on existing doc based on comments
/write rubric              # View/edit quality rubric
```

**For slide decks:** Same workflow applies. During interview, specify "slides" or "presentation" as the type. See `slides-reference.md` for slide-specific guidance.

## Workflow

| Phase | Summary | Key Actions |
|-------|---------|-------------|
| 1. Interview | Gather requirements | Type, audience, goal, sources |
| 2. Context | Load prior work | Memory files, exemplars, knowledge base (index.md + docs) |
| 3. Drafting | Create content | @business-writer for complex docs, direct for simple |
| 4. Quality Gate | Verify quality | Rubric check, elevation check (Level 3+ for exec docs) |
| 5. Delivery | Publish + register | gdocs create/update, **always** register in knowledge base |
| 6. Iteration | Address feedback | Fetch comments, contextualize, revise, reply |
| 7. Learning | Extract patterns | Update patterns.md, stakeholders.md, corrections.md |

**Full workflow details:** See `workflow-reference.md`

## Formatting Checkpoint (All Documents)

Before uploading to Google Docs, verify against `formatting-rules.md`. Quick checklist:

| Check | Action |
|-------|--------|
| YAML frontmatter | Title/subtitle in frontmatter (not `# Title`) |
| Prose-first | Lead sections with prose, not bullets |
| Bold sparingly | Reserve for key terms, not labels |
| No horizontal rules | Never use `---` dividers |
| Post-upload | Run `gdocs style-tables <id> light` |

**Full formatting guidance:** See `formatting-rules.md`

## The 10 Principles for World-Class Documents

| # | Principle | Application |
|---|-----------|-------------|
| 1 | **Lead with the answer** | First sentence states impact/conclusion |
| 2 | **Diagnose before prescribing** | Start with what's happening, not what you want |
| 3 | **Frame as testable hypotheses** | State assumptions explicitly |
| 4 | **Invite challenge** | Facilitate discovery, don't dictate |
| 5 | **Start with the customer** | Work backwards from their experience |
| 6 | **Omit needless words** | Every word must do work |
| 7 | **Third-person active voice** | Conveys authority |
| 8 | **Define scope AND non-scope** | Prevent scope creep |
| 9 | **Living documents** | Update as implementation progresses |
| 10 | **Clear > Entertaining** | Clarity beats cleverness |

## The 7 Questions Every Document Must Answer

1. **What's the diagnosis?** - What's actually happening?
2. **What's the answer?** - Lead with the conclusion
3. **Who's the customer?** - Their perspective first
4. **What's the hypothesis?** - What are we betting on?
5. **What's in/out of scope?** - Prevent scope creep
6. **What are the coherent actions?** - Steps, not just goals
7. **How do we know if we succeeded?** - Metrics that falsify

## Slack & Email

**Templates:** See `templates-reference.md` for Slack (Ask, Decision, Status) and Email ([ACTION], [DECISION], [FYI], [BLOCKED]) patterns.

**Quality checks:** Slack - single message, thread-safe, scannable. Email - intent in subject, one topic, ask + deadline in first 2 lines.

## Diagrams

When explaining architecture, data flow, or system design: **use the `architecture-diagram` skill instead of ASCII art**. Produces clean D2 diagrams inserted as images.

## Integration

**Tools:** gwork CLI (gdocs/gsheets/gslides), @business-writer (drafting), architecture-diagram (visuals)

**Memory:** `~/.claude/skills/write/memory/` · **Knowledge base:** `~/Documents/claude-docs/`
