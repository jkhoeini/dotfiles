# Write Skill - Slides Reference

Guidance for creating presentation decks via the `gslides` CLI. Slides are a visual + meeting medium with different constraints than documents.

**Shared principles apply:** BLUF, SCQA, MECE, interview → draft → quality gate. See SKILL.md and writing-research.md.

**This file covers:** What's different about slides.

## Why Slides Work Differently

**Dual Coding Theory:** The brain processes visual and verbal information through separate channels. When you show text while speaking, both channels compete for the same (verbal) pathway — retention drops. When you show a visual while speaking, both channels engage simultaneously — retention increases.

**Implication:** Slides should be visual anchors, not teleprompters. The slide supports what you say; it doesn't duplicate it.

## Slide Grammar (Not Doc Grammar)

| Docs | Slides |
|------|--------|
| Prose-first, narrative flow | One idea per slide |
| Section headings as labels | Action titles as conclusions |
| Detail supports argument | Scannable in 5-10 seconds |
| Reader controls pace | Presenter/meeting controls pace |

## The Glance Test

A slide should be comprehensible in 3 seconds. If viewers must "solve" the slide to understand it, the design failed.

**Check:** Squint at the slide. What pops out? If it's not the key takeaway, adjust.

## Action Titles

The title IS the takeaway, not a label.

| ❌ Label | ✅ Action Title |
|---------|-----------------|
| "Market Analysis" | "Market share doubled to 20% in 3 years" |
| "Latency Results" | "Moving to Rust reduced P99 latency by 40%" |
| "Roadmap" | "Phase 1 launches in Q2, full rollout by Q4" |
| "Risks" | "Supply chain delay is the critical path risk" |

**Prompt yourself:** "If someone reads only the titles, do they get the story?"

## Visual Hierarchy

Style elements so the most important appears most prominent:

1. **Dominant:** Primary focal point (chart, diagram, key number)
2. **Interpretive:** Action title explaining what viewer sees
3. **Supportive:** Labels, footnotes, sources (smallest)

Whitespace is an active design element, not empty space.

## Reader vs Presenter Mode

| Mode | When | Optimization |
|------|------|--------------|
| **Pre-read** | Deck read async without you | Self-contained, annotated, clearer labels |
| **Presenter** | You'll talk through it live | Lighter slides, heavier speaker notes, pacing |

Ask during interview: "Will this be read standalone or presented?"

## Deck Structure (Story Arc)

Use SCQA to structure the narrative:

| Section | Purpose | Slides |
|---------|---------|--------|
| **Situation** | Status quo, context | 1-2 |
| **Complication** | Problem, opportunity, "why now" | 1-2 |
| **Question** | The problem to solve (often implicit) | 0-1 |
| **Answer** | Recommendation, solution | 2-4 |
| **Next Steps** | Actions, ask, timeline | 1 |

**Total:** Aim for 7-12 slides for a typical strategy or proposal deck.

## Common Slide Types

### Title Slide
```yaml
- layout: TITLE
  placeholders:
    title: "Deck Title"
    subtitle: "Context — Audience — Date"
```

### Problem / Why Now
Action title states the problem or urgency. Use a bold statistic or brief story.

```yaml
- layout: TITLE_AND_BODY
  placeholders:
    title: "25% of new users drop out in week 1"
    body:
      - type: bullets
        items:
          - "Support tickets doubled in Q3"
          - "Onboarding flow unchanged since 2022"
          - "Competitors solving this now"
```

### Solution / Proposal
Show the "what" with diagram or key features.

```yaml
- layout: TITLE_AND_BODY
  placeholders:
    title: "Personalized onboarding reduces dropout by 15%"
    body:
      - type: prose
        text: "Three-step wizard tailored to user intent."
      - type: bullets
        items:
          - "Intent classification on signup"
          - "Customized first-run experience"
          - "Progress tracking with nudges"
```

### Roadmap / Timeline
Prefer horizontal timelines for 16:9 aspect ratio.

```yaml
- layout: TITLE_AND_BODY
  placeholders:
    title: "Full rollout by Q4"
    body:
      - type: bullets
        items:
          - "Q2: Beta to 10% users"
          - "Q3: Iterate based on feedback"
          - "Q4: GA + marketing launch"
```

### Decision Needed
Explicit ask with rationale.

```yaml
- layout: TITLE_AND_BODY
  placeholders:
    title: "Approve $500K for Project X (ROI ~3x in 2 years)"
    body:
      - type: prose
        text: "Decision required: Allocate additional budget in Q4."
      - type: bullets
        items:
          - "Pilot increased conversion by 25%"
          - "Delay costs ~$50K/month in lost opportunity"
          - "If approved, Phase 1 delivers by end of Q3"
```

### Section Header
Transition slide between major sections.

```yaml
- layout: SECTION_HEADER
  placeholders:
    title: "Demo"
  notes: |
    Transition to live demo.
```

### Agenda
For longer presentations, set expectations upfront.

```yaml
- layout: TITLE_AND_BODY
  placeholders:
    title: "Agenda"
    body:
      - type: bullets
        items:
          - "Context & Problem (5 min)"
          - "Proposed Solution (10 min)"
          - "Demo (10 min)"
          - "Discussion & Q&A (15 min)"
```

### Comparison Table
For side-by-side option analysis. Use two-column layout.

```yaml
- layout: TITLE_AND_TWO_COLUMNS
  placeholders:
    title: "Option B is faster with acceptable tradeoffs"
    left:
      - type: prose
        text: "Option A: Build In-House"
      - type: bullets
        items:
          - "Timeline: 6 months"
          - "Cost: $800K"
          - "Control: Full"
          - "Risk: Execution"
    right:
      - type: prose
        text: "Option B: Buy + Customize"
      - type: bullets
        items:
          - "Timeline: 3 months"
          - "Cost: $400K"
          - "Control: Partial"
          - "Risk: Vendor lock-in"
```

## Content Rules

### Text
- **Max 40 words per slide** (excluding title)
- **Max 5 bullets** — if more, split the slide
- **No paragraphs** — bullets or short phrases only
- **Bold sparingly** — only for key terms

### Code
- **Max 10-12 lines** — abstract the rest with `// ...`
- **24pt minimum** for code text
- **Highlight key lines** (the 3-5 lines that matter)
- **Dark mode** with bright syntax highlighting preferred

### Charts & Data
- **One chart = one takeaway** — annotate the "so what"
- **Label directly on chart** — kill legends where possible
- **Show units, timeframe, source** — and "as of" date
- **Avoid 3D effects, unnecessary gridlines**

### Diagrams (Mermaid)
- **Max 10 nodes** for slide-embedded diagrams
- **Left-to-right (LR)** flow for 16:9 aspect ratio
- **Use subgraphs** to group and reduce complexity
- **Label on edges** (`A -- "JSON/HTTP" --> B`) instead of legends

### Options / Tradeoffs
For decisions requiring choice between approaches.

```yaml
- layout: TITLE_AND_BODY
  placeholders:
    title: "Option B recommended: lower risk, faster delivery"
    body:
      - type: bullets
        items:
          - "Option A: Build in-house — 6 months, full control, $800K"
          - "Option B: Buy + customize — 3 months, vendor dependency, $400K"
          - "Option C: Partner integration — 2 months, limited features, $200K"
      - type: prose
        text: "Recommendation: Option B balances speed and capability."
```

### Executive Summary
For longer decks, summarize the entire story on one slide.

```yaml
- layout: TITLE_AND_BODY
  placeholders:
    title: "TL;DR: Approve Project X to capture $2M opportunity"
    body:
      - type: bullets
        items:
          - "Problem: 25% user dropout in onboarding"
          - "Solution: Personalized wizard reduces dropout 15%"
          - "Ask: $500K budget, Q4 allocation"
          - "Impact: $2M ARR uplift by end of year"
```

### Metrics / KPI
For status updates or performance reviews. Use big numbers.

```yaml
- layout: TITLE_AND_BODY
  placeholders:
    title: "Q3 metrics on track — NPS up, churn down"
    body:
      - type: bullets
        items:
          - "MAU: 1.2M (↑15% QoQ)"
          - "NPS: 52 (target: 50) ✓"
          - "Churn: 2.1% (↓0.3pp)"
          - "Revenue: $4.2M (98% of plan)"
```

### Big Number
For a single key metric that deserves its own slide.

```yaml
- layout: TITLE_AND_BODY
  placeholders:
    title: "99.99%"
    body:
      - type: prose
        text: "Uptime in Q3 — our best quarter ever."
  notes: |
    Pause here. Let the number sink in.
```

### Update Summary
For recurring status updates (QBRs, weekly syncs).

```yaml
- layout: TITLE_AND_BODY
  placeholders:
    title: "Project X: On Track (Green)"
    body:
      - type: bullets
        items:
          - "Wins: Shipped auth module, hired 2 engineers"
          - "Risk: Vendor delay — mitigation in place"
          - "Next: Beta launch Oct 15"
```

## Design System Checklist

| Element | Standard |
|---------|----------|
| **Fonts** | Sans-serif (Arial, Roboto). Title 36-44pt, body 20-24pt, caption 14-16pt |
| **Colors** | 2-3 brand colors max. High contrast (dark on light or vice versa) |
| **Alignment** | Consistent left edges, margins, and spacing across slides |
| **Whitespace** | Generous. Cramped = unreadable |
| **Animations** | Rarely. Simple fade/dissolve only. No spinning, bouncing |

## Accessibility & Real-World Testing

| Check | Why |
|-------|-----|
| **Contrast ratio** | Light text on light background disappears on projectors |
| **Color-blind safe** | Don't encode meaning by color alone — add labels or patterns |
| **Minimum font size** | 20pt body, 24pt code — smaller is illegible from back of room |
| **Test on projector** | Colors wash out; what looks good on laptop may fail in meeting room |
| **Test in Zoom** | Remote viewers see smaller screens — verify legibility |

**Rule:** If meaning depends on distinguishing red from green, add a label or icon.

## gslides CLI Workflow

### Create from YAML
```bash
gslides create /tmp/deck.yaml          # Creates presentation, returns ID
gslides info <id>                       # Show presentation info
```

### Update Existing
```bash
gslides update <id> /tmp/deck.yaml     # Full replacement
```

### Export
```bash
gslides export <id>                    # Text export to knowledge base
gslides export <id> --format yaml      # YAML structure
gslides export <id> --format pdf       # PDF download
gslides export <id> --format pptx      # PowerPoint download
```

### Comments
```bash
gslides comments <id>                  # List comments
gslides reply <id> <comment_id> "Done" --resolve
```

## YAML Schema Quick Reference

```yaml
title: "Presentation Title"
slides:
  - id: unique-id           # Required
    layout: TITLE           # See layout options below
    placeholders:
      title: "Slide Title"
      subtitle: "For TITLE layout"
      body:                  # For TITLE_AND_BODY
        - type: prose
          text: "Paragraph text"
        - type: bullets
          items: ["Point 1", "Point 2"]
          style: numbered    # Optional: numbered list
    notes: |                 # Speaker notes (multiline)
      Notes for this slide.
```

### Layout Options
| Layout | Placeholders |
|--------|--------------|
| `TITLE` | title, subtitle |
| `TITLE_AND_BODY` | title, body |
| `SECTION_HEADER` | title |
| `TITLE_AND_TWO_COLUMNS` | title, left, right |
| `BLANK` | (none — use for custom content) |

## Quality Checklist (Slide-Specific)

### The McKinsey 3 Questions
Every executive deck must answer these. If your deck doesn't, it's incomplete:

1. **What's the recommendation?** — State it upfront (not at the end)
2. **Why should I believe you?** — Evidence, data, proof points
3. **What should I do next?** — Clear ask with timeline

| Check | Pass? |
|-------|-------|
| **Glance test** | Main point clear in 3 seconds? |
| **Action titles** | Titles state conclusions, not labels? |
| **One idea per slide** | No cramming multiple concepts? |
| **Scannable** | ≤40 words, ≤5 bullets per slide? |
| **Visual hierarchy** | Key element most prominent? |
| **Code legible** | ≤12 lines, ≥24pt, key lines highlighted? |
| **Charts annotated** | "So what" on the chart, sources cited? |
| **Consistent design** | Same fonts, colors, alignment throughout? |
| **Speaker notes** | For presenter mode: talk track in notes? |

## Anti-Patterns

| ❌ Mistake | ✅ Fix |
|-----------|-------|
| Title as label ("Overview") | Action title ("We recommend X because Y") |
| Wall of bullets (10+ items) | Split into multiple slides |
| Screenshot of spreadsheet | Extract key numbers, rebuild as chart |
| Scrollable code block | Max 10-12 lines, abstract the rest |
| Mixed icon styles | Use one consistent icon set |
| Legend-dependent charts | Label directly on chart elements |
| "Thank You" slide | End with "Next Steps" or "Q&A + Contact" |

## Meeting Mechanics

Slides often drive decisions in a room. Include these elements when appropriate:

### Decision Framing
When asking for approval, clarify:
- **Reversibility:** "This is reversible — we can roll back in 2 weeks" vs "This is a one-way door"
- **Cost of delay:** "Each month we wait costs $50K in lost opportunity"
- **Default outcome:** "If we do nothing, X happens"

### Parking Lot / Open Questions
For longer discussions, include a slide to capture items for later:

```yaml
- layout: TITLE_AND_BODY
  placeholders:
    title: "Open Questions (for follow-up)"
    body:
      - type: bullets
        items:
          - "Integration timeline with Team Y — need their input"
          - "Legal review status — pending response"
          - "Budget reallocation mechanics — finance to clarify"
```

This keeps the main discussion focused while signaling you've thought about loose ends.

## Workflow: Storyboard → Build → Critique → Polish

| Phase | Actions |
|-------|---------|
| **Storyboard** | Write action titles only. Read them in sequence. Does the story hold? |
| **Build** | Add content to each slide. One idea per slide. |
| **Critique** | Scan test: read only titles + visuals. Confusing? Too dense? Weak evidence? |
| **Polish** | Alignment, consistency, speaker notes. Test on projector/Zoom. |

**Storyboard first:** If the titles don't tell a coherent story, adding content won't fix it.

## Specialized Deck Patterns

Different presentation types have proven structures. Use these as starting points.

### Technical Deep Dive (Architecture Review)
**Goal:** Consensus on a technical decision. 7-10 slides.

| Slide | Content |
|-------|---------|
| 1. Context | User problem or business driver |
| 2. Constraints | Latency, cost, legacy compatibility, team capacity |
| 3. Options | Comparison matrix (Option A vs B vs C) |
| 4. Recommendation | The chosen path with rationale |
| 5. Architecture | Mermaid diagram of proposed state |
| 6. Code (optional) | Before vs After snippet (max 10 lines each) |
| 7. Risks & Mitigations | Top 3 risks with mitigation plans |
| 8. Timeline | Phased rollout plan |
| 9. Decision/Ask | What approval is needed |

### Developer Pitch Deck (Internal Tool/Library)
**Goal:** Adoption by the team. 6-8 slides.

| Slide | Content |
|-------|---------|
| 1. The Pain | Why is our current workflow broken? Bold statistic. |
| 2. The Solution | Introduce the tool — what it does in one sentence |
| 3. Hello World | Simplest possible code snippet to get value (5 lines max) |
| 4. Demo | Placeholder for live demo |
| 5. Key Features | 3-4 capabilities that matter most |
| 6. Getting Started | `npm install` or equivalent — make adoption trivial |
| 7. Roadmap (optional) | What's coming next |

**Key insight:** Developers buy based on ease of use and performance. Show, don't tell.

### RFC Summary (Executive Read-Out)
**Goal:** Approval or budget. Max 5-7 slides. No code.

| Slide | Content |
|-------|---------|
| 1. Executive Summary | BLUF: recommendation + key benefit + ask |
| 2. The Ask | What resources needed (headcount, budget, timeline) |
| 3. Why Now | Urgency, cost of delay, competitive pressure |
| 4. ROI / Impact | Business value, metrics expected |
| 5. Timeline | High-level Gantt or milestones (Mermaid) |
| 6. Risks | Top 2-3 with mitigations |
| 7. Decision | Explicit: "Approve X by Y date" |

**Key insight:** Execs want high-level data visualization, zero code snippets, and a clear decision.

## Text-to-Visual Transformation

When converting text to slides, default to visuals:

| If the text describes... | Default to... |
|--------------------------|---------------|
| Sequence of events | Mermaid sequence diagram |
| System interactions | Mermaid flowchart (LR) |
| Numeric trends | Line or bar chart |
| Comparisons | Table or two-column layout |
| Single key metric | Big Number slide |
| Process steps | Numbered list or timeline |

**Bias toward concrete nouns:** Words like "Server", "Database", "User" are easy to visualize. Abstract words like "Optimization", "Strategy", "Alignment" are not — replace with concrete examples or icons.

## Document-to-Slides Conversion

When converting a written document to slides:

1. **Extract governing thought** — the one key conclusion/recommendation
2. **Identify 3-5 supporting pillars** — MECE grouping of arguments
3. **Storyboard titles first** — write action titles before content
4. **Transform text to visuals** — charts, diagrams, key numbers
5. **Cut ruthlessly** — if it doesn't drive the story, appendix or delete
6. **Test scanability** — read only titles; does the story hold?

**Rule:** The slides should allow someone who didn't read the doc to follow the logic and reach the intended conclusion.

## Appendix Discipline

Keep main deck tight. Move supporting material to backup slides:

- Detailed data tables
- Methodology
- Risk register (full version)
- Extended timeline
- Competitive analysis details

Mention in main deck: "(See Appendix for details)" — shows you've done the work without overwhelming.
