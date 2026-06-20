---
name: write
description: Business writing workflow with interview, drafting, quality gates, and Google Suite integration. Use when creating exec updates, RFCs, PRDs, strategy docs, or professional communications.
---

# /write - Business Writing Skill

Orchestrates the full business writing workflow: interview → context → draft → quality check → deliver → iterate → learn.

**Deep-dive reference**: See `writing-research.md` for comprehensive frameworks (Pyramid Principle, SCQA, MECE, Rumelt's Kernel, Amazon/Google/Stripe practices, interview techniques).

## Quick Start

```
/write                     # Start new document (will interview)
/write iterate <doc-url>   # Iterate on existing doc based on comments
/write rubric              # View/edit quality rubric
```

## Formatting Checkpoint (All Document Creation)

**This applies to ALL Google Doc creation**, whether through `/write` or direct `gdocs create`:

Before uploading any document to Google Docs, verify:

| Check | Action |
|-------|--------|
| **YAML frontmatter** | Title/subtitle in frontmatter (not `# Title`) |
| **Prose-first** | Lead sections with prose, not bullets |
| **Bold sparingly** | Reserve for key terms, not labels or list items |
| **No horizontal rules** | Never use `---` dividers in markdown |
| **Pageless format** | Automatic with `gdocs create`; use `gdocs pageless <id>` for existing docs |
| **Light borders** | Run `gdocs style-tables <id> light` after upload |

**Post-upload commands** (run after document creation):
```bash
gdocs style-tables <doc_id> light
```

Note: Pageless format is applied automatically by `gdocs create`. For existing docs, run `gdocs pageless <id>` explicitly.

**Quick documents**: Even for fast docs created directly with `gdocs create`, apply these principles. The formatting guidance in this skill applies universally, not just to `/write` sessions.

### Formatting Anti-Patterns to Avoid

| Anti-pattern | Problem | Fix |
|--------------|---------|-----|
| `---` dividers | Creates ugly horizontal rules in Google Docs | Use blank lines and headings for separation |
| Bold in list items | `- **Layer 0** - description` looks cluttered | Use plain text or italic: `- Layer 0: description` or `- *Layer 0:* description` |
| Em dashes for definitions | `Label — description` feels heavy | Use colons: `Label: description` |
| Numbered lists in markdown | Google Docs often renders them poorly | Use bullet lists or prose instead |
| Bold labels everywhere | `**Label:** value` repeated = visual noise | Use italic labels, H3 subheadings, or prose |
| Wall of bullets | Every section is just bullets | Lead with 1-2 prose sentences first |
| Too many list items | Lists with 9+ items lose emphasis | Keep lists to 2-8 items max |
| Multiple blank lines | Using blank lines for spacing | Configure paragraph styles instead |
| Trailing `  ` (two spaces) | Causes fragmented line breaks | Use proper paragraphs (Enter) |

### Spacing: Use Styles, Not Line Breaks

Google Docs paragraph styles handle spacing automatically. Never use extra blank lines or trailing spaces to create visual separation.

| Action | Result | When to Use |
|--------|--------|-------------|
| Enter | New paragraph (includes defined spacing after) | Between paragraphs, after headings |
| Shift+Enter | Line break within same paragraph | Addresses, items within a single bullet |
| Format > Line spacing | Set 1.15 for body, 6pt after paragraphs | Configure once via styles |

**Key rule**: If you're adding blank lines for spacing, you're doing it wrong. Set paragraph spacing in styles and let the document format itself.

### List Format Selection

| Content Type | Best Format | Example |
|--------------|-------------|---------|
| 2-3 related items | Inline (comma-separated) | "Covers: auth, logging, metrics" |
| 4-8 discrete items | Bulleted list | Requirements, deliverables |
| Sequential steps | Numbered list (use sparingly) | Installation steps |
| Comparative data (4+) | Table | Feature comparison |
| Complex relationships | Prose paragraphs | Architecture rationale |

**Key rule**: Lists with 2-8 items work best. More than 8 items emphasizes nothing - restructure or use headings to group.

### Google Docs List Styling Rules

When creating lists in Google Docs, these styling rules ensure professional appearance:

| Rule | Why | How |
|------|-----|-----|
| **Use disc bullets (●)** | Dashes look informal | Markdown `-` becomes discs via `fix_bullet_styles` |
| **Paragraph spacing, not line breaks** | Blank lines create fragmentation | Use `spaceAbove`/`spaceBelow` (12pt works well) |
| **No empty paragraphs around lists** | Visual clutter | Delete blank lines, use paragraph spacing |
| **Preserve document mode** | Uploads can reset pageless to pages | `gdocs update` auto-restores original mode |

**Post-upload**: Run `gdocs fix-bullets <doc_id>` to convert dash lists to proper bullets with spacing.

### Diagrams: Tables Over ASCII Art

ASCII art diagrams break in Google Docs. The markdown-to-docs conversion fragments text into many runs, destroying character alignment.

**Instead of:**
```
┌─────────────┐
│  Component  │
└─────────────┘
```

**Use a table:**
| From | To | Description |
|------|-----|-------------|
| Raw Events | Canonical Events | Schema validation |
| Canonical Events | Semantic Layer | Metrics + timeline |
| Semantic Layer | Consumer Views | Batch, NRT, Analytics |

Or prose: "Raw events flow through canonical events (with schema validation) to the semantic layer, which feeds all consumer views."

## Workflow

### 1. Interview Phase

When user says `/write` or requests a document, gather:

| Required | Ask if missing |
|----------|----------------|
| **Type** | What kind of document? (exec update, RFC, PRD, email, Slack, strategy doc) |
| **Audience** | Who will read this? |
| **Goal** | What should they do/know/feel after? |
| **Sources** | Any docs to reference? (can paste URLs or content) |

Optional (only ask if truly unclear):
- Tone (formal/casual)
- Length constraints
- Deadline

**Don't over-interview** - if the request is clear, skip to drafting.

**For complex requirements**: Consult writing-research.md Part 6:
- Frame the session (restate goal, confirm understanding)
- The 5 Whys (probe beyond superficial answers)
- Content discovery questions by category (problem, solution, success, risks, stakeholders)

### 2. Context Gathering

Load from memory:
- `~/.claude/skills/write/memory/stakeholders.md` - Known audience preferences
- `~/.claude/skills/write/memory/patterns.md` - Successful formulations
- `~/.claude/skills/write/memory/corrections.md` - Mistakes to avoid

**Load few-shot exemplar** based on document type:

| Document Type | Exemplar File |
|--------------|---------------|
| Two-pager | `~/.claude/skills/write/memory/exemplars/two-pager-exemplar.md` |
| Strategy doc, Pre-read | `~/.claude/skills/write/memory/exemplars/strategy-exemplar.md` |
| Proposal, Initiative | `~/.claude/skills/write/memory/exemplars/proposal-exemplar.md` |

Read referenced documents via CLI:
```bash
gdocs export <id> -o /tmp/doc.md  # Export Google Doc to markdown
gdocs info <id>                   # Show document info

gslides export <id>               # Get slide deck as plain text
gsheets export <id>               # Get spreadsheet as CSV
```

**When structure unclear**: Consult writing-research.md Part 5:
- PRD: Overview → Goals → Requirements → Metrics
- RFC: Summary → Background → Problem → Proposal → Success
- Strategy: Vision → Pillars → Roadmap → Success
- 6-Pager: Intro → Goals → Tenets → State → Lessons → Priorities

**Prior Work Discovery**: Search `~/Documents/claude-docs/index.md` for related documents:

1. Read index.md
2. Scan summaries for topic/audience relevance
3. Present relevant documents with their summaries
4. Offer to fetch full documents for deeper context

Example:
```
Found related prior work:

1. "Data Application Portal" (milestones, 2026-01-18)
   → Delivery milestones for compliance visibility, LPM/GenRecs focus

2. "Data Quality Strategy" (proposal, referenced)
   → 18-month roadmap for foundational data quality across missions

Would you like me to incorporate context from any of these?
```

### 3. Drafting

Use @business-writer agent for complex documents:
```
Spawn @business-writer with:
- Document type
- Audience context
- Referenced content
- Quality rubric
- Few-shot exemplar (include "Sample Text" sections from exemplar file)
- **Include the 10 Principles** (copy from this file)
- **If persuasive doc**: Include SCQA framework (Situation → Complication → Question → Answer)
```

**Few-shot prompting**: Include 2-3 sample text snippets from the exemplar in your prompt to @business-writer. This is more effective than describing the style - show, don't tell.

For simple emails/Slack, draft directly following patterns.md.

### 4. Quality Gate

Before presenting, evaluate against `rubric.md`:

| Dimension | Weight | Check |
|-----------|--------|-------|
| Clarity | 25% | Main point in first paragraph? |
| Audience Fit | 25% | Tone matches recipient? |
| Brevity | 20% | Every sentence necessary? |
| Actionability | 20% | Clear asks/next steps? |
| Structure | 10% | Logical, scannable? |

**If draft fails**: Revise internally before showing user. Note what was fixed.

**Elevation check** (for important documents):

After rubric passes, evaluate against Quality Ladder (writing-research.md Part 12):

| Level | Criteria | Check |
|-------|----------|-------|
| 2 - Competent | Organized, complete, clear | Rubric passes |
| 3 - Professional | Clear opening, no hedging, scope defined | "So what?" answered in line 1 |
| 4 - World-Class | SCQA structure, invites challenge, third-person voice | Would a McKinsey consultant approve? |

**Target**: All exec-facing docs should reach Level 3+. RFCs and strategy docs should aim for Level 4.

### Natural Writing Checklist

Avoid robotic patterns that make AI-generated text obvious:

| Robotic | Natural |
|---------|---------|
| All bullets, no prose | Lead with prose, bullets for short lists only |
| `**Label:** Description` repeated | Vary structures between sections |
| "It is", "cannot", "will not" | Contractions: "It's", "can't", "won't" |
| Same sentence length throughout | Mix short and long sentences |
| No transitions between sections | Connect sections with flow |

**Self-check**: Read aloud. If it sounds like a template, rewrite.

### Tables vs Lighter Alternatives

Tables add visual weight. Use the lightest format that serves the content:

| Content Type | Best Format | Example |
|--------------|-------------|---------|
| Metadata (1-2 pairs) | Inline bold | `**Owner:** Name · **Updated:** Date` |
| Key-value (2-3 items) | Prose or bold keys | "Target: Mid-Jan. Scope: Core metrics." |
| Comparable items (4+) | Table | Milestones, metrics, reference docs |
| Sequential items | Bulleted list | Deliverables, criteria, steps |

**Rule of thumb**: If a table has only 2 columns and 2-3 rows, inline formatting is usually lighter.

### Paragraph Structure for Metadata Labels

When a section has a description followed by metadata (Scope, Dependencies, Note, etc.), put the metadata label on its **own paragraph**:

**Correct:**
```markdown
The milestone delivers a metrics dashboard showing compliance status.

**Scope:** Metrics defined in the Tracking Plan.
```

**Incorrect:**
```markdown
The milestone delivers a metrics dashboard showing compliance status. **Scope:** Metrics defined in the Tracking Plan.
```

This creates visual separation and makes documents more scannable. The rule applies to any `**Label:**` pattern that follows descriptive prose.

### Table Border Styling

Google Docs defaults to harsh black table borders. For professional documents, use **light gray borders** (RGB 0.8, 0.8, 0.8 / #CCCCCC, 0.5pt width).

After creating or updating a document with tables:
```bash
gdocs style-tables <doc_id> light
```

This applies light gray borders to all tables in the document.

### Document Inspection

Before finalizing documents, verify formatting with inspection commands:

```bash
# Show document structure
gdocs inspect <doc_id>

# Check against style rules
gdocs lint <doc_id>

# Debug formatting issues
gdocs debug <doc_id>
```

These commands are read-only and safe to run anytime.

### When Stuck

| Symptom | Consult | Fix |
|---------|---------|-----|
| Opening is weak | Part 2 (SCQA, BLUF) | Pull conclusion to first sentence |
| Too much hedging | Part 2 (Confidence) | Remove "seems", "tends", "I believe" |
| Structure unclear | Part 5 (Templates) | Match to document type template |
| Requirements vague | Part 6 (Interview) | Use 5 Whys, probe deeper |
| Draft too long | Part 1 (Strunk) | "Omit needless words" pass |
| Sounds AI-generated | Part 2A (Stripe) | First para 2-3 sentences, vary structure |
| Tables everywhere | Tables vs Lighter | Inline for 2-3 items, prose for relationships |

### Markdown for Google Docs

When authoring markdown that will be uploaded to Google Docs via `gdocs`:

**Title and Subtitle (use YAML frontmatter):**

```markdown
---
title: Data Application Portal
subtitle: Spring 2026 Milestones
---

**Owner:** Name · **Updated:** Date

## Executive Summary
...
```

The `gdocs` tool parses frontmatter and applies proper TITLE/SUBTITLE styles automatically. This is the foundational fix - semantic markup at authoring time, not post-hoc fixing.

**Headings (sections, not title):**
- `## Section` becomes HEADING_1 (top-level section)
- `### Subsection` becomes HEADING_2
- Never use `#` for section headings - reserve for frontmatter title
- Never use bold inside headings: `## Summary` not `## **Summary**`
- One blank line before and after headings

**Paragraphs:**
- Separate paragraphs with blank lines
- **NEVER use trailing `  ` (two spaces) for line breaks** - causes fragmented formatting
- Keep paragraphs to 3-5 sentences for scannability
- Executive summaries work best as 3 clear paragraphs (not 2 dense blocks)

**Tables:**
- Be consistent: all cells bold or no cells bold (not mixed)
- For metadata, prefer inline: `**Owner:** Name · **Updated:** Date`
- Reserve tables for 4+ comparable items

**Typography (see writing-research.md Part 7):**
- Bold sparingly for emphasis
- Left-aligned text (ragged right)
- Lists: 2-8 items max

**Anti-patterns to avoid** (see writing-research.md Part 7):
- Repetitive section openings ("Furthermore...", "It is important...")
- Bold/italics everywhere (let headings do the work)
- Uniform paragraph lengths (vary naturally)
- Tables for everything (use prose for narrative)
- Excessive horizontal dividers

**Google Docs style consistency:**
- Clear formatting on pasted content before styling
- Update style definitions, not individual instances
- Configure paragraph spacing in Format menu, not blank lines

**Why markdown upload works best:**
- Direct markdown upload preserves Google Docs native styles (115% line spacing, non-bold headings)
- HTML/Pandoc conversion was removed - it caused bold headings, cramped spacing, and fixed-width tables
- The `gdocs` tool now uploads markdown directly to Google Docs

**Post-upload verification:**
1. Export and review: `gdocs export <id> -o /tmp/check.md`
2. If paragraphs look fragmented, check source for trailing `  ` spaces
3. Manual fixes if needed: `gdocs fix-headings <id>`, `gdocs fix-tables <id>`

### 5. Delivery

Create or update Google Doc:
```bash
# Write draft to markdown file
cat > /tmp/draft.md << 'EOF'
# Document Title

Content here...
EOF

# New document (from markdown file)
gdocs create "Title" /tmp/draft.md

# Update existing (replaces entire content)
gdocs update <doc_id> /tmp/draft.md

# Patch a specific section (preserves rest of doc)
gdocs patch <doc_id> /tmp/section.md --range "SectionName"

# Rename the document tab (default tab is named "Tab 1")
gdocs rename-tab <doc_id> "Descriptive Tab Name"
```

**Tab naming:** New documents default to "Tab 1" which looks unprofessional. After creating or updating, rename the tab to match the document's purpose (e.g., "Spring 2026 Milestones").

Present link to user with brief summary of what was created.

### Document Registry

After successful delivery, log the document to `~/Documents/claude-docs/index.md`:

| Field | Source |
|-------|--------|
| Date | Current date |
| Type | From interview (exec-update, RFC, PRD, milestones, etc.) |
| Title | Document title |
| Audience | Target reader(s) |
| Topics | Comma-separated keywords |
| Summary | ~10% of document length: what, why, key details |
| URL | Google Docs link |
| LocalPath | Path to local markdown copy (optional) |
| ExportDate | Date of last local export (optional) |

**Summary**: Read the full document and generate a summary at ~10% of the original length. Cover what it delivers, why it matters, and key constraints or decisions.

### Knowledge Base: Local Document Copies

For frequently referenced documents, store local copies for faster access:

**Storage location**: `~/Documents/claude-docs/`

**When to export locally**:
- Documents referenced during writing sessions
- Source documents that inform new writing
- Historical context documents

**Process**:
```bash
# Export document to knowledge base
gdocs export <doc_id> -o ~/Documents/claude-docs/<filename>.md

# Capture comments and append to local copy
gdocs comments <doc_id> >> ~/Documents/claude-docs/<filename>.md

# Example: Export Q1 Strategy with comments
gdocs export 1abc123xyz -o ~/Documents/claude-docs/q1-strategy.md
gdocs comments 1abc123xyz >> ~/Documents/claude-docs/q1-strategy.md
```

**For presentations** (Google Slides), use `gslides export` instead of `gdocs export`.

**Naming convention**: Use lowercase kebab-case matching the document title (e.g., `data-quality-strategy.md`, `q1-roadmap.md`).

**Get document timestamps** (important for context nuancing - documents may reflect outdated information):
```bash
# Get creation and modification dates
gdocs info <doc_id>       # Google Docs
gslides info <slide_id>   # Google Slides
gsheets info <sheet_id>   # Google Sheets
# Output includes: Created: YYYY-MM-DDTHH:MM:SS.sssZ, Modified: YYYY-MM-DDTHH:MM:SS.sssZ
```

**Index entry**: When adding to index.md, include:
- `LocalPath`: Full path to local copy (e.g., `~/Documents/claude-docs/q1-strategy.md`)
- `ExportDate`: Date exported (e.g., `2026-01-25`)
- `CreatedDate`: Original document creation date (for context nuancing - older documents may not reflect current state)
- `ModifiedDate`: Last modification date (indicates how recently the document was updated)

**Comments**: Always capture comments when exporting to preserve discussion context and open questions. Comments are appended after the document content.

This builds a knowledge base that enables:
- Quick reference when writing new documents
- Offline access to key context
- Faster document loading (no API calls)
- Preserved discussion history from comments

### Auto-Catalog Created Documents

After successfully creating or updating a document with `/write`, **always** add it to the knowledge base:

1. **Export to local storage**:
   ```bash
   gdocs export <new_doc_id> -o ~/Documents/claude-docs/<filename>.md
   gdocs comments <new_doc_id> >> ~/Documents/claude-docs/<filename>.md
   ```

2. **Add to index.md** in the "Documents Created" section with:
   - Date, Type, Title, Audience, Topics, Summary, URL
   - LocalPath and ExportDate columns

This ensures every document written through /write becomes part of the searchable knowledge base for future reference.

### 6. Iteration Loop

When user says `/write iterate <doc-url>`:

1. **Extract doc ID** from URL (pattern: `/d/([a-zA-Z0-9_-]+)/`)

2. **Fetch comments AND document** (both needed for context):
   ```bash
   # Get document content as markdown
   gdocs export <doc_id> -o /tmp/doc.md

   # Get open comments
   gdocs comments <doc_id>

   # Include resolved comments
   gdocs comments <doc_id> --resolved
   ```

3. **Contextualize each comment**:
   For each comment, match `quotedFileContent` to document location:

   | Scenario | Action |
   |----------|--------|
   | **Unique match** | Show with surrounding context |
   | **Multiple matches** | Find Nth occurrence, show all if unclear |
   | **No match** | Text may have been edited, flag it |
   | **No quotedFileContent** | Document-level comment, applies broadly |

   Present contextualized view:
   ```
   Comment #1 by [author]:
   → "This is unclear"
   → On: "...Key blocker resolved.\n\n[Status: On Track]\n\nKey Updates..."

   Comment #2 by [author]:
   → "Add more detail"
   → On: "...[Started performance optimization]\n\nDecisions..."
   ```

4. **Identify feedback themes** and generate revisions addressing each

5. **Run through quality gate** again

6. **Update document** using gdocs or present suggestions

7. **Reply to comments** acknowledging what was addressed:
   ```bash
   # Reply to a comment
   gdocs reply <doc_id> <comment_id> "Addressed: [what was changed]"

   # Reply and mark as resolved
   gdocs reply <doc_id> <comment_id> "Fixed!" --resolve
   ```

8. **Present summary** of changes made

#### Formatting Comment Resolution

When addressing formatting-related comments (e.g., "formatting looks bad", "fix the layout"):

1. **Identify document type** from title/structure (exec update, RFC, proposal, etc.)

2. **Load reference document** from `~/Documents/claude-docs/index.md`:
   - Find a reference doc of the same type
   - Export reference doc: `gdocs-to-png.sh <reference_id> /tmp/reference`

3. **Visual comparison**:
   - Export target doc: `gdocs-to-png.sh <target_id>`
   - Read both PNGs and compare side-by-side
   - Note ALL discrepancies, not just the obvious ones

4. **Structural comparison**:
   - Get structure of both via MCP `get_document_structure`
   - Compare heading hierarchy, bullet usage, spacing
   - Check for issues like: bullets on headings, redundant prefixes, missing emphasis

5. **Check formatting-rules.md** for learned patterns

6. **Before any batchUpdate**:
   ```bash
   # ALWAYS fetch current state first - indices change!
   # Use gdocs export for content, or direct API for structure:
   gdocs export <id> -o /tmp/current.md
   ```
   - Use fresh indices in all range specifications
   - Apply updates in reverse index order to avoid shifting issues

7. **Comprehensive fix** - address ALL issues found, not just the commented one

8. **Verify visually** - re-export and compare before replying

### 7. Learning Extraction

After user accepts final document:
- Extract successful patterns → patterns.md
- Note stakeholder preferences → stakeholders.md

After rejection or heavy edits:
- Analyze failure → corrections.md
- Review which rubric dimension failed

**Document References**: Log documents referenced during the session to `~/Documents/claude-docs/index.md` (Referenced Documents section). Include: date, writing context, title, summary (~10% length), and doc ID.

## Commands

### `/write`
Start a new document. Will interview if needed.

### `/write iterate <url>`
Read comments from existing doc and generate revisions.

Example:
```
/write iterate https://docs.google.com/document/d/1abc.../edit
```

### `/write rubric`
Display current quality rubric. User can suggest adjustments.

### `/write learn`
Review recent writing sessions and extract patterns.

## Document Type Quick Reference

| Type | Key Focus | Template |
|------|-----------|----------|
| Exec Update | Brevity, decisions | TL;DR → Status → Updates → Ask |
| RFC/PRD | Completeness, alternatives | Summary → Goals → Proposal → Tradeoffs |
| Strategy Doc | Vision, coherence | Context → Vision → Pillars → Roadmap |
| Email | Action, clarity | Ask → Context → Details → Next step |
| Slack | Brevity, tone | [emoji] Key point. Details if needed. |

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

## Slack & Email Quick Reference

### Slack Templates

**Ask**: `TL;DR: <ask> | Context: <1-2 lines> | What I need: <thing> by <date>`

**Decision**: `Decision needed by <date>: <decision> | Options: A) ... B) ... | Recommendation: <line>`

**Status**: `TL;DR: <green/yellow/red> | Progress: <bullets> | Risks: <bullets> | Next: <bullets>`

### Email Subject Prefixes

| Prefix | When |
|--------|------|
| [ACTION] | Needs recipient action |
| [DECISION] | Needs approval/choice |
| [FYI] | Informational only |
| [BLOCKED] | Waiting on something |

### Quality Checks

**Slack**: Single message? Thread-safe? Scannable? Mentions justified?

**Email**: Intent in subject? One topic? Ask + deadline in first 2 lines?

**Full templates with context**: See writing-research.md Part 9 for:
- 4 Slack templates (Ask, Decision, Status, Close-the-loop)
- 3 Email templates ([ACTION], [DECISION], [FYI])
- Quality checklists for each medium

## Integration Points

- **Google Drive MCP**: Read docs, sheets, slides
- **gdocs helper**: Create and modify Google Docs
- **@business-writer agent**: Complex document drafting
- **Writing memory**: Stakeholders, topics, patterns, corrections, rubric

## Error Handling

| Issue | Response |
|-------|----------|
| Can't access doc | Ask user to share or paste content |
| Unclear requirements | Interview before proceeding |
| Quality gate fails | Revise and explain changes |
| User rejects draft | Ask what to change, update corrections.md |

---
*Skill integrates with google-workspace skill for document operations (loaded automatically via dependency)*
