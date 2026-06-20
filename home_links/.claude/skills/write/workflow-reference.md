# Write Skill - Workflow Reference

Detailed instructions for each phase of the /write workflow. See SKILL.md for the overview.

## Phase 1: Interview

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

## Phase 2: Context Gathering

### Memory Files

Load from memory:
- `~/.claude/skills/write/memory/stakeholders.md` - Known audience preferences
- `~/.claude/skills/write/memory/patterns.md` - Successful formulations
- `~/.claude/skills/write/memory/corrections.md` - Mistakes to avoid

### Few-Shot Exemplars

| Document Type | Exemplar File |
|--------------|---------------|
| Two-pager | `~/.claude/skills/write/memory/exemplars/two-pager-exemplar.md` |
| Strategy doc, Pre-read | `~/.claude/skills/write/memory/exemplars/strategy-exemplar.md` |
| Proposal, Initiative | `~/.claude/skills/write/memory/exemplars/proposal-exemplar.md` |

### Reading Google Workspace

**All document types via CLI:**
```bash
gslides export <id>              # Get slide deck as plain text
gslides info <id>                # Show presentation info

gsheets export <id>              # Get spreadsheet as CSV (first sheet)
gsheets export <id> --sheet "X"  # Get specific sheet by name
gsheets info <id>                # Show spreadsheet info and sheets list
```

### Document Type Taxonomy

| Type | When to Use | Key Difference |
|------|-------------|----------------|
| **RFC** | Technical/architectural decisions needing alignment | Alternatives analysis required, 2-6 pages, explicit reviewers |
| **Proposal** | Strategic initiatives, organizational changes | Governance focus, approver list, business case |
| **PRD** | Product features, requirements definition | User stories, acceptance criteria, metrics |
| **Exec Update** | Status reporting to leadership | Brevity, decisions, TL;DR first |
| **Strategy Doc** | Vision and direction setting | Pillars, roadmap, long-term view |

### Document Type Quick Reference

| Type | Key Focus | Template |
|------|-----------|----------|
| Exec Update | Brevity, decisions | TL;DR → Status → Updates → Ask |
| RFC | Completeness, alternatives | Summary → Problem → Proposal → Alternatives → Success |
| PRD | Requirements, metrics | Overview → Goals → Requirements → Metrics |
| Strategy Doc | Vision, coherence | Context → Vision → Pillars → Roadmap |
| Email | Action, clarity | Ask → Context → Details → Next step |
| Slack | Brevity, tone | [emoji] Key point. Details if needed. |

### RFC Best Practices

For RFCs, load `rfc-reference.md` which covers Spotify-specific guidance including:
- Preparation (RFC Field Guide, Architecture Golf)
- Structure (Spotify template sections)
- TSG kick-off process
- Comment handling and review integration
- ADR connection after acceptance/rejection

### Prior Work Discovery (Knowledge Base)

Search `~/Documents/claude-docs/index.md` for related documents:

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

**Local copies** are stored in `~/Documents/claude-docs/` for faster access. Check there first before fetching via API.

**Document timestamps** - Get creation/modification dates to nuance context (older documents may not reflect current state):
```bash
gdocs info <doc_id>       # Google Docs
gslides info <slide_id>   # Google Slides
gsheets info <sheet_id>   # Google Sheets
```

## Phase 3: Drafting

Use @business-writer agent for complex documents:
```
Spawn @business-writer with:
- Document type
- Audience context
- Referenced content
- Quality rubric
- Few-shot exemplar (include "Sample Text" sections from exemplar file)
- **Include the 10 Principles** (copy from SKILL.md)
- **If persuasive doc**: Include SCQA framework (Situation → Complication → Question → Answer)
```

**Few-shot prompting**: Include 2-3 sample text snippets from the exemplar in your prompt to @business-writer. This is more effective than describing the style - show, don't tell.

For simple emails/Slack, draft directly following patterns.md.

## Phase 4: Quality Gate

### Quick Checks (Before Rubric)

Run these fast checks before the full rubric evaluation:

| Check | Action |
|-------|--------|
| **Read aloud** | Read the opening paragraph aloud. Does it sound natural? Awkward phrasing reveals itself when spoken. |
| **First paragraph ≤ 3 sentences** | Stripe rule: opening paragraph must be 2-3 sentences max. If longer, split or trim. |
| **Examples verified** | For technical docs: Are code snippets, data examples, and screenshots accurate and current? |

### Rubric Evaluation

Evaluate against `rubric.md`:

| Dimension | Weight | Check |
|-----------|--------|-------|
| Clarity | 25% | Main point in first paragraph? |
| Audience Fit | 25% | Tone matches recipient? |
| Brevity | 20% | Every sentence necessary? |
| Actionability | 20% | Clear asks/next steps? |
| Structure | 10% | Logical, scannable? |

**If draft fails**: Revise internally before showing user. Note what was fixed.

### Document-Specific Checks

After the rubric passes, apply checks specific to the document type:

**PRDs and Technical Specs:**
| Vague Requirement | Measurable Version |
|-------------------|-------------------|
| "Fast performance" | "P95 latency < 200ms" |
| "Easy to use" | "Task completion > 90% without help docs" |
| "Scalable" | "Supports 10x current load" |
| "Intuitive" | "Users complete task in < 3 clicks" |
| "Reliable" | "99.9% uptime SLA" |

Scan every requirement. If it uses subjective language, rewrite with a number or observable behavior.

**Status Updates:**
- Exec audience: ≤ 3 bullets, RAG status, one decision/ask
- Team audience: Progress %, blockers with owners
- Standup: Yesterday/Today/Blockers only

### Elevation Check

After rubric passes, evaluate against Quality Ladder (writing-research.md Part 12):

| Level | Criteria | Check |
|-------|----------|-------|
| 2 - Competent | Organized, complete, clear | Rubric passes |
| 3 - Professional | Clear opening, no hedging, scope defined | "So what?" answered in line 1 |
| 4 - World-Class | SCQA structure, invites challenge, third-person voice | Would a McKinsey consultant approve? |

**Target**: All exec-facing docs should reach Level 3+. RFCs and strategy docs should aim for Level 4.

### Reader Testing (Final Validation)

Before delivery, simulate the reader's perspective:

1. **List 3-5 questions** the target reader would likely ask after reading
2. **Check if the document answers them** - if not, add the missing content
3. **Identify ambiguities** - where could a reader misinterpret your intent?
4. **Verify the "so what"** - does every section make clear why it matters?

| Reader Type | Likely Questions |
|-------------|------------------|
| **Executive** | "What do you need from me?", "What's the risk?", "When?" |
| **Engineering** | "How does this work?", "What are the edge cases?", "What's the scope?" |
| **Cross-functional** | "How does this affect my team?", "What's the timeline?", "Who owns what?" |

**Quick test**: If someone reads only the first paragraph and the headings, do they get the main point?

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
| Jargon-heavy | Clarity Audit | Restate core point for a smart 12-year-old |
| Multiple audiences | Audience Variants | Exec (metrics, ask), IC (details, how), Customer (benefits) |

## Phase 5: Delivery

### Slack Messages

Present the drafted message directly to user for copy/paste:
```
Here's your Slack message:

---
TL;DR: [key point] | Context: [1-2 lines] | What I need: [thing] by [date]
---

Ready to paste into #channel-name. Want me to adjust anything?
```

No registration in knowledge base needed for Slack messages.

### Emails

Present the drafted email with subject line:
```
**Subject:** [ACTION] Review caching RFC by Friday

**Body:**
[email content]

---
Ready to send. Want me to adjust anything?
```

No registration in knowledge base needed for emails.

### Google Docs (RFCs, PRDs, Strategy Docs, Exec Updates)

```bash
# New document (from markdown file)
gdocs create "Title" /tmp/draft.md

# Update existing (replaces entire content)
gdocs update <doc_id> /tmp/draft.md

# Patch a specific section (preserves rest of doc)
gdocs patch <doc_id> /tmp/section.md --range "SectionName"

# Rename the document tab (default tab is named "Tab 1")
gdocs rename-tab <doc_id> "Descriptive Tab Name"
```

**Tab naming:** New documents default to "Tab 1" which looks unprofessional. After creating, rename the tab to match the document's purpose.

**Post-upload:**
```bash
gdocs style-tables <doc_id> light  # Apply light gray borders to tables
```

Present link to user with brief summary of what was created.

### Register in Knowledge Base

After successful delivery, **always** register the document:

1. **Export to local storage**:
   ```bash
   gdocs export <new_doc_id>  # Auto-saves to ~/Documents/claude-docs/<doc_id>.md
   gdocs comments <new_doc_id> >> ~/Documents/claude-docs/<doc_id>.md
   ```

   The export command automatically saves to the knowledge base directory. No `-o` flag needed.

2. **Add to index.md** (upsert behavior):
   - Search for the Doc ID in existing entries: `grep "<doc_id>" ~/Documents/claude-docs/index.md`
   - **If found**: Update Last Updated, LocalPath, and regenerate summary (document has been revised)
   - **If not found**: Append new entry with:

   | Field | Source |
   |-------|--------|
   | Date | Current date |
   | Type | From interview (exec-update, RFC, PRD, etc.) |
   | Title | Document title |
   | Audience | Target reader(s) |
   | Topics | Comma-separated keywords |
   | Summary | ~10% of document length |
   | URL | Google Docs link |
   | LocalPath | Path to local copy |
   | ExportDate | Date exported |

This ensures every document becomes part of the searchable knowledge base.

## Phase 6: Iteration

When user says `/write iterate <doc-url>`:

### 1. Extract and Fetch

Extract doc ID from URL (pattern: `/d/([a-zA-Z0-9_-]+)/`)

1. **Check if document exists in index first**:
   ```bash
   grep "<doc_id>" ~/Documents/claude-docs/index.md
   ```

2. **Get document content**:
   ```bash
   # If exists in index, use the LocalPath from index entry
   # If new document, export will create it in knowledge base
   gdocs export <doc_id>  # Auto-saves to ~/Documents/claude-docs/<doc_id>.md

   # Get open comments
   gdocs comments <doc_id>

   # Include resolved comments
   gdocs comments <doc_id> --resolved
   ```

### 2. Contextualize Comments

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
```

### 3. Revise and Update

> **Note:** Google Docs API does not support creating suggestions (tracked changes) programmatically.
> Edits made via the API are direct changes, not suggestions. This is a known limitation
> (Google Issue #287903901). When iterating on others' documents, consider making a copy first.

1. Identify feedback themes and generate revisions
2. Run through quality gate again
3. Update document using gdocs
4. Reply to comments:
   ```bash
   gdocs reply <doc_id> <comment_id> "Addressed: [what was changed]"
   gdocs reply <doc_id> <comment_id> "Fixed!" --resolve
   ```
5. Present summary of changes made

### Formatting Comment Resolution

When addressing formatting-related comments:

1. **Identify document type** from title/structure
2. **Load reference document** of same type from index.md
3. **Visual comparison**: Export both as PNG, compare side-by-side
4. **Structural comparison**: Get structure via MCP, compare heading hierarchy
5. **Check formatting-rules.md** for learned patterns
6. **Before any batchUpdate**: Always fetch current state first (indices change!)
7. **Comprehensive fix**: Address ALL issues found
8. **Verify visually**: Re-export and compare before replying

## Phase 7: Learning Extraction

After user accepts final document:
- Extract successful patterns → patterns.md
- Note stakeholder preferences → stakeholders.md

After rejection or heavy edits:
- Analyze failure → corrections.md
- Review which rubric dimension failed

**Document References**: Log documents referenced during the session to index.md (Referenced Documents section).

## Error Handling

| Issue | Response |
|-------|----------|
| Can't access doc | Ask user to share or paste content |
| Unclear requirements | Interview before proceeding |
| Quality gate fails | Revise and explain changes |
| User rejects draft | Ask what to change, update corrections.md |
