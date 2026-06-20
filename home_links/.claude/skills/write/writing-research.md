# World-Class Writing Research

Deep-dive reference for writing frameworks, product thinker insights, tech company practices, and professional communication patterns.

**Usage**: Referenced from `write.md`. Consult when drafting complex documents or when quality needs elevation.

---

## Part 1: Core Writing Principles

### The 4 Cs of Professional Writing

| Principle | Definition | Application |
|-----------|------------|-------------|
| **Clarity** | Convey purpose immediately | Match vocabulary to audience; avoid jargon unless explained |
| **Conciseness** | Use least words for most meaning | "Omit needless words" - Strunk; cut padding, redundancy |
| **Coherence** | Ideas flow logically | Use transitions; one idea leads to next |
| **Consistency** | Uniform style throughout | Same terms, tone, structure |

### Strunk & White Core Rules

1. **"Make every word tell"** - Omit needless words
2. **Use active voice** - "The team delivers" not "Delivery is performed by the team"
3. **Put statements in positive form** - "He forgot" not "He did not remember"
4. **Use definite, specific, concrete language**
5. **Keep related words together**

### Zinsser's Additions

1. **Simplicity** - Fight clutter; every word must do work
2. **Unity** - One voice, one tense, one mood per piece
3. **The Lead** - Most important sentence; must capture reader
4. **Rewriting** - "There is no writing, only rewriting"

---

## Part 2: Consulting Frameworks

### The Pyramid Principle (McKinsey)

**Core Concept**: "Lead with the answer" - conclusion first, then supporting arguments.

**SCQA Framework**:
1. **Situation** - Context everyone agrees on
2. **Complication** - The problem creating urgency
3. **Question** - What naturally arises
4. **Answer** - Your main point (lead with this)

**Structure**:
```
                    [Main Point / Answer]
                   /          |          \
          [Key Point 1]  [Key Point 2]  [Key Point 3]
         /     |    \         |             |
      [Data] [Data] [Data]  [Data]       [Data]
```

### MECE Framework

**Mutually Exclusive, Collectively Exhaustive** - problems broken into distinct, non-overlapping categories that cover all possibilities.

### BLUF (Bottom Line Up Front)

State your most important point FIRST, then provide detail. Don't bury the lede.

**Example**:
```
BLUF: "Project X is six weeks behind schedule due to two supplier issues,
so we are re-prioritizing features to launch on time."

[Then provide the context and explanation...]
```

**Test**: If your draft has a conclusion in the final paragraph starting with "In short," or "The key takeaway is...," that sentence likely belongs at the beginning.

### Consulting Tone

- Third-person active voice for authority
- Every sentence adds value
- Lead with the conclusion
- Minimize cognitive load with clean design

### Executive Summary Best Practices

- Keep to **10% of document length**
- **Strong opening**: State the impact, not just the topic
  - Weak: "This report outlines the status of the XXX project"
  - Strong: "This report explains the estimated 2-week delay..."
- **Must stand alone** as a complete picture
- Lead with "so what" - implications and recommendations first

### Confidence Without Hedging

Remove qualifiers that undermine authority:

| Hedging | Direct |
|---------|--------|
| "It seems like we should..." | "We should..." |
| "I believe this approach..." | "This approach..." |
| "We tend to see..." | "We see..." |
| "It's possible that..." | State the fact or omit |
| "I think maybe..." | Make a clear recommendation |

### Insight Density

Every paragraph must deliver value - a fact, an analysis, a decision - rather than meandering.

**Techniques**:
- Ruthless editing: After drafting, cut 10-20% of words without losing content
- Avoid filler phrases: "In order to" -> "To", remove redundant adjectives
- Favor specifics over generalities:
  - Weak: "We have a significant latency issue"
  - Dense: "Latency has increased 250% (to 500ms) in 3 months, exceeding our 200ms target"

---

## Part 3: Product Thinkers' Frameworks

### Marty Cagan (SVPG) - Discovery vs Documentation

**Core Insight**: Documentation is NOT a substitute for product discovery.

**Key Principles**:
1. PRDs should come AFTER discovery, not replace it
2. "As soon as the product manager writes an actual PRD, there is a certain gravity to that document, and people are much less likely to challenge or question"
3. Collaboration between product, design, and engineering is crucial
4. Without prototyping, testing, and iterative collaboration, solutions are unlikely to succeed

**Empowered Teams**:
- Assigned **problems to solve**, not features to build
- Accountable for **outcomes** (business results), not output (shipped features)
- The largest barrier to empowerment is **trust**

**Application to Writing**: Documents should invite challenge, not shut it down. Write to facilitate discovery, not to dictate solutions.

### Eric Ries (Lean Startup) - Hypothesis-Driven Documents

**Core Insight**: Frame documents around testable hypotheses, not assumptions.

**Two Critical Hypotheses**:
1. **Value Hypothesis**: Does the product deliver value once customers use it?
2. **Growth Hypothesis**: How will new customers discover the product?

**Build-Measure-Learn Loop**:
```
IDEAS -> BUILD -> PRODUCT -> MEASURE -> DATA -> LEARN -> IDEAS
```

**Application to Writing**:
- State leap-of-faith assumptions explicitly
- Define what would falsify your hypothesis
- Identify the metric to measure success/failure
- Documents are living artifacts, not static plans

### Richard Rumelt - The Strategy Kernel

**Core Insight**: Good strategy has a logical structure called "the kernel."

**Three Essential Elements**:

| Element | Definition | Application |
|---------|------------|-------------|
| **Diagnosis** | What's actually going on? Simplify complexity by identifying critical aspects | "LPM needs behavioral signals but has no unified compliance view" |
| **Guiding Policy** | Overall approach to overcome obstacles (guardrails, not tactics) | "Build a compliance dashboard for data producers and leadership" |
| **Coherent Actions** | Coordinated steps that implement the policy | The milestones: M1->M2->M3->M4 |

**Four Hallmarks of Bad Strategy**:
1. **Fluff** - Jargon masking lack of substance
2. **Failure to face the challenge** - Dodging the core difficulty
3. **Mistaking goals for strategy** - Ambitious without actionable approach
4. **Bad strategic objectives** - Targets as hard as the original problem

**Application to Writing**: Every strategy document needs diagnosis -> guiding policy -> coherent actions. Goals are not strategy.

---

## Part 4: Tech Company Writing Cultures

### Google - Design Docs

**Philosophy**: "Our job is not to produce code per se, but rather to solve problems."

**Typical Structure**:
1. Context and scope
2. Goals and non-goals
3. Actual design (system context diagram, API overview, data storage)
4. Alternatives considered
5. Cross-cutting concerns

**Best Practices**:
- Keep docs concise (10-20 pages ideal)
- Focus on trade-offs and decision-making
- Avoid copy-pasting formal interface definitions
- Update docs as implementation progresses
- Define scope AND non-scope explicitly

**When to Write**: High problem complexity, ambiguous design, need for consensus, identifying issues early.

### Amazon - Working Backwards PR/FAQ

**Philosophy**: "Start with the customer and work backwards."

**Press Release Structure**:
1. **Headline** - Product name in one sentence
2. **Subheading** - Customer segment and benefits
3. **Summary Paragraph** - Launch details, overview
4. **Problem Paragraph** - Customer perspective on the issue
5. **Solution Paragraphs** - How product addresses problem, differentiation
6. **Quotes** - Spokesperson + hypothetical customer
7. **Getting Started** - Initial access instructions

**FAQ Structure**:
- **External FAQs**: Practical customer questions (functionality, warranty, installation)
- **Internal FAQs**: Stakeholder questions (technical, financial, legal challenges)

**Amazon 6-Pager** (Six Sections):
1. Introduction
2. Goals
3. Tenets
4. State of the Business
5. Lessons Learned
6. Strategic Priorities

**Writing Rules**:
- No bullet points - full sentences/paragraphs
- No author names
- Minimal visual aids
- Remove weasel words
- Support claims with data
- Distinguish assumptions from facts

### Mailchimp - Voice & Tone

**Philosophy**: "Don't market at people; communicate with them."

**Voice Characteristics** (consistent):
- **Plainspoken** - Value clarity, strip hyperbolic language
- **Genuine** - Relate to customers' challenges warmly
- **Dry humor** - Straight-faced, subtle, a touch eccentric

**Tone Adjustments** (contextual):
- Consider reader's state of mind
- Adapt to situation (more serious for errors, lighter for success)
- "More important to be clear than entertaining"

**Writing Principles**:
| Principle | Definition |
|-----------|------------|
| **Clear** | Simple words and sentences |
| **Useful** | Identify purpose and reader needs before writing |
| **Friendly** | Write like a human; warm and relatable |
| **Appropriate** | Adapt tone to context and audience |

### Microsoft - Spec-Driven Development

**Philosophy**: Surface assumptions early, when changing direction costs keystrokes instead of sprints.

**Key Insight**: Specs are "living documents that evolve alongside your code, not dusty artifacts that you write once and forget."

**Spec-Driven Development (SDD)**:
- NOT exhaustive dry requirements documents
- NOT waterfall planning or predicting the future
- IS a lightweight way to think through edge cases, coordinate across teams, onboard people

### Stripe's Writing Practices

**First paragraph rule**: Keep the very first paragraph to only 2-3 sentences for maximum clarity.

**Footnotes technique**: Use academic-style footnotes in internal communications to provide depth without derailing the narrative.

**Writing = Code**: "Engineers do this with their code, and we do it with our writing" - have colleagues review drafts.

**Sample docs > Templates**: Provide rich examples showing what good looks like, not just fill-in-the-blank templates.

---

## Part 5: Document Types & Templates

### PRD (Product Requirements Document)

**Key Sections**:
1. Title and Change History
2. Overview (what and why)
3. Goals and Non-Goals
4. User Personas
5. User Stories / Use Cases
6. Functional Requirements
7. Non-Functional Requirements
8. Success Metrics
9. Timeline / Milestones
10. Open Questions

**Best Practices**:
- Modern PRDs "read like blog posts" but have all needed information
- Should excite the team to build, not just inform
- Living document - continuously updated

### RFC (Request for Comments)

**Google Structure**:
- Context and scope
- Goals and non-goals
- Actual design (diagrams, APIs, data storage)
- Alternatives considered
- Cross-cutting concerns

**Uber Structure**:
- Abstract
- Architecture changes
- Service SLAs
- Dependencies
- Security considerations
- Testing & rollout
- Metrics & monitoring

**Sourcegraph Structure** (minimal):
- Summary
- Background
- Problem
- Proposal
- Definition of success

### Strategy Document

**Recommended Format**:
- Vision for technology's role
- Principles/guidelines for decisions
- Architecture vision and roadmap
- Cross-functional requirements
- Accepted defaults for tools/tech
- Architecture Operating Model

**Strategy-on-a-Page**:
- Executive-facing alignment highlights
- Key initiatives with summaries
- Strategic roadmap
- Success definition
- Goals

---

## Part 6: Interview Questions for Content Gathering

### Document Type Detection

| Question | Purpose |
|----------|---------|
| "What decision does this document need to support?" | Identifies if persuasive (proposal) or informational (spec) |
| "Who is the primary audience?" | Determines tone and detail level |
| "What action should readers take after reading?" | Clarifies call-to-action |
| "Will this be a living document or point-in-time snapshot?" | Affects structure |

### Advanced Interview Techniques

**Frame the Session**: Clarify problem statement and what document aims to achieve upfront. Rephrase the ask ("Let me restate the goal as I understand it...") and confirm.

**The 5 Whys**: When an answer is superficial, probe deeper with "Tell me more about that" or "Why is that a problem?" Repeated "Why?" questions uncover root causes.

**Challenge Assumptions (Tactfully)**: If stakeholder presents a predetermined solution, ask: "What outcome are you expecting from X? Have we confirmed that's the root cause?"

**Bridging to Refocus**: When stakeholders digress, acknowledge the tangent then connect back: "That's an interesting point about last year's project - it actually brings us back to our current challenge of [topic]."

**Silence Technique**: Don't rush to fill pauses. A short silence encourages elaboration.

**Close with Alignment**: Summarize what you heard and ask "Have I missed anything important?" Then ask "Who or what else might provide valuable input?"

### Content Discovery Questions

**Problem/Opportunity**:
- What problem are we solving?
- Why does this matter now?
- What happens if we don't solve it?
- How is the problem currently being addressed?
- What's the cost of the current approach?

**Solution**:
- What does the ideal solution look like?
- What's in scope vs. out of scope?
- What are the key features/capabilities?
- What are the dependencies?
- What are the alternatives considered?

**Success**:
- How will we measure success?
- What are the key milestones?
- What does "done" look like?
- What are the quality gates?

**Risks**:
- What could go wrong?
- What are the technical risks?
- What are the organizational risks?
- What mitigations exist?

**Stakeholders**:
- Who needs to approve this?
- Who is impacted?
- Who needs to be informed?
- Who will execute?

### Depth Questions

- "Can you give me an example of..."
- "What's the story behind..."
- "How does this connect to..."
- "What's the biggest misconception about..."
- "If you could only communicate one thing, what would it be?"

---

## Part 7: Formatting Guidelines

### White Space

- **Margins**: 1 inch all around (2 inch left if binding)
- **Paragraph spacing**: 12 points between single-spaced paragraphs
- **Heading spacing**: More space above than below
- **Lists**: 2-8 items max; more emphasizes nothing

### Typography

- **Font**: 12pt minimum; serif or sans-serif both readable
- **Avoid**: ALL CAPS (reduces readability), excessive italics
- **Bold**: Use sparingly for emphasis
- **Alignment**: Left-aligned with ragged right is most readable

### Lists vs Prose

| Content | Format |
|---------|--------|
| 2-3 related items | Inline (comma-separated or semicolons) |
| 4-8 discrete items | Bulleted list |
| Sequential steps | Numbered list |
| Comparative data | Table |
| Complex relationships | Prose paragraphs |

### Tables

- Reserve for truly comparable data (4+ items)
- Light borders or no borders
- Clear headers
- Consistent alignment

### Google Docs Style Defaults

- **Use built-in styles** (Heading 1, 2, etc.) - ensures consistency and auto-generates outline
- **Update style definition** to change all instances: Format > Paragraph styles > Update 'Heading X' to match
- **Paragraph spacing** via Format menu, not multiple blank lines (6pt after paragraphs is typical)
- **Clear formatting** on pasted or AI-generated text to match document defaults
- **One or two fonts max** - e.g., sans-serif for headings, serif or same sans for body
- **11pt body text** is standard; 10pt minimum, 12pt maximum

### Paragraph Spacing vs Line Breaks

| Action | Use Case |
|--------|----------|
| Enter | New paragraph (includes defined spacing after) |
| Shift+Enter | Line break within same paragraph (addresses, lists in bullets) |
| Format > Line spacing | Set 1.15 for body text, space after paragraph |

**Never**: Use multiple blank lines to create spacing - configure paragraph styles instead.

### Anti-Patterns That Reveal AI-Generated Documents

| Anti-Pattern | Symptom | Fix |
|--------------|---------|-----|
| **Repetitive structure** | Every section starts identically ("Furthermore, it is important...") | Vary phrasing and paragraph length |
| **Overusing emphasis** | Bold/italics on every key point | Let headings and placement emphasize; use bold rarely |
| **Inconsistent fonts** | Mixed Calibri/Times/random sizes | Select all → Clear formatting → Apply Normal style |
| **Over-tabular layout** | Document feels like spreadsheet or slides | Convert tables to prose; use tables only for data |
| **Excessive dividers** | Horizontal lines between every section | Remove; let headings and spacing separate sections |
| **Uniform paragraph length** | Every paragraph exactly 3 sentences | Vary length naturally |

### Tech Company Formatting Patterns

**Amazon 6-Pager**:
- Plain narrative prose, minimal bullets
- Times New Roman or Arial 11pt
- Standard 1" margins to fit 6 pages of content
- No slides, no decorative formatting

**Stripe**:
- First paragraph 2-3 sentences max
- Footnotes for tangential details (like academic papers)
- Structured but reads as narrative

**Google Design Docs**:
- Semantic formatting: headings denote content type
- Bullet list for Goals/Non-goals (clear enumeration)
- Diagrams/tables only where text insufficient
- Consistent mono font for code snippets

---

## Part 8: Knowledge Reuse Patterns

### The Exemplar Library Approach

Instead of rigid templates, maintain a library of excellent past documents as reference models.

**What to Catalog**:
- PRDs by document type (new feature, enhancement, technical)
- Strategy docs by scope (team, org, company)
- RFCs with clear alternatives sections
- Incident post-mortems that drove change
- Project retrospectives with learnings

### Modular Content and Single Sourcing

Identify content that repeats across documents and manage it centrally:
- Vision statement (current version)
- Architecture overview
- Standard metrics definitions
- Privacy/compliance boilerplate
- Team structure descriptions

### Before Writing Any Section

Ask: "Has someone in the company solved or documented this before?"

### Version Control for Documents

- "Last Updated" date on all living documents
- Designate certain docs as "source of truth" (canonical references)
- Other docs LINK to canonical sources rather than duplicating

---

## Part 9: Slack & Email Playbook

### Medium Selection Rules

| Medium | When to Use | Key Characteristic |
|--------|-------------|-------------------|
| **Slack** | Fast alignment, lightweight coordination, quick asks | Async, public channels preferred |
| **Email** | Formal asks, wider distribution, longer-lived record | One topic per thread |
| **Doc/RFC/PRD** | Durable context, alternatives, decision history | Link from Slack/email |

**Escalation Rule**: If a thread is turning into ping-pong, move to sync chat, then write down the conclusion.

### Slack Best Practices

| Practice | Why |
|----------|-----|
| **Default to channels (not DMs)** | Transparency + future reuse |
| **"Single-message" rule** | Don't send "hey" then wait - send full message in one go |
| **Write for scan-speed** | Bold key terms, bullets, short paragraphs |
| **Threads for discussion** | Keep channels clean; broadcast outcome back to channel |
| **Reactions instead of "+1"** | Reduces message volume |
| **Stingy with @mentions** | Include full ask/context when you ping |

### Slack Templates

**1. Ask (low-friction request)**
```
TL;DR: <the ask in one sentence>

Context: <1-2 lines; link if needed>
What I need: <specific thing> (by <date/time + tz>)
Constraints: <important caveat, if any>
```

**2. Decision request (exec/lead-friendly)**
```
Decision needed by <date>: <decision>

Options:
A) <option> - pros/cons
B) <option> - pros/cons

Recommendation: <one line>
Details: <doc link> (optional)
```

**3. Status update**
```
TL;DR: <green/yellow/red + why>

Progress: <2-3 bullets>
Risks/Blockers: <bullets + what you need>
Next: <bullets + dates>
Links: <doc / dashboard / ticket>
```

**4. Close-the-loop summary (after messy thread)**
```
Thread summary:
- Decision: <...>
- Owner(s): <...>
- Due dates: <...>
- Open questions: <...>
```

### Email Best Practices

| Practice | Why |
|----------|-----|
| **Subject lines encode intent** | Use keywords: [ACTION], [DECISION], [FYI], [BLOCKED] |
| **One topic per thread** | Start new email for new topics |
| **Open with ask + by-when** | Main point first |
| **Keep it scannable** | 1-2 sentence opener, bullets for requirements |
| **Recipient hygiene** | BCC for large groups; FYI markers when forwarding |

### Email Templates

**1. [DECISION]**
```
Subject: [DECISION] <topic> - by <date>

Hi <Name/Team>,

I'm asking for a decision on <decision> by <date/time>.

Recommendation: <one line>
Options:
1) <option> - tradeoffs
2) <option> - tradeoffs

If approved, next steps are <1-2 bullets>.

Thanks,
<You>
```

**2. [ACTION] request**
```
Subject: [ACTION] <ask> - by <date>

Hi <Name>,

Could you <specific ask> by <date/time>?

Context: <1-2 lines>
Details: <bullets>

Thank you,
<You>
```

**3. [FYI] update (exec-friendly)**
```
Subject: [FYI] <topic> - status <green/yellow/red>

TL;DR: <one sentence>

What changed:
- <bullets>

What's next:
- <bullets + dates>

Links: <doc/dashboard>
```

### Quality Gates

**Slack Checks**:
- [ ] Single message? (not "hey" then content)
- [ ] Thread-safe? (discussion in thread, outcomes broadcast)
- [ ] Scannable? (bold, bullets, short paragraphs)
- [ ] Mentions justified? (full context included)
- [ ] Decision broadcasted? (if decision made in thread)

**Email Checks**:
- [ ] Intent encoded in subject? ([ACTION], [DECISION], [FYI], [BLOCKED])
- [ ] One topic per thread?
- [ ] Ask + deadline in first 2 lines?
- [ ] Scannable? (opener, bullets, background last)

---

## Part 10: The 10 Principles for World-Class Documents

| # | Principle | Source | Application |
|---|-----------|--------|-------------|
| 1 | **Lead with the answer** | Pyramid Principle | First sentence states the impact/conclusion |
| 2 | **Diagnose before prescribing** | Rumelt | Start with what's actually happening, not what you want |
| 3 | **Frame as testable hypotheses** | Lean Startup | State assumptions explicitly, define success metrics |
| 4 | **Invite challenge, don't shut it down** | Cagan | Documents facilitate discovery, not dictate solutions |
| 5 | **Start with the customer** | Amazon | Work backwards from customer experience |
| 6 | **Omit needless words** | Strunk & White | Every word must do work |
| 7 | **Third-person active voice** | Consulting | Conveys authority and confidence |
| 8 | **Define scope AND non-scope** | Google | Prevent scope creep by stating what's out |
| 9 | **Living documents, not artifacts** | Microsoft SDD | Update as implementation progresses |
| 10 | **Clear > Entertaining** | Mailchimp | Clarity beats cleverness |

---

## Part 11: The 7 Questions Every Document Must Answer

1. **What's the diagnosis?** (Rumelt) - What's actually happening?
2. **What's the answer?** (Pyramid) - Lead with the conclusion
3. **Who's the customer?** (Amazon) - Start with their perspective
4. **What's the hypothesis?** (Lean Startup) - What are we betting on?
5. **What's in/out of scope?** (Google) - Prevent scope creep
6. **What are the coherent actions?** (Rumelt) - Not just goals, but steps
7. **How do we know if we succeeded?** (Lean Startup) - Metrics that falsify

---

## Part 12: Document Quality Ladder

```
LEVEL 4: WORLD-CLASS
  - Passes 4 Cs check (Clarity, Conciseness, Coherence, Consistency)
  - Uses Pyramid Principle (lead with answer)
  - Has Rumelt's Kernel (diagnosis -> guiding policy -> actions)
  - States hypotheses explicitly (Lean Startup)
  - Invites challenge (Cagan)
  - Third-person active voice (Consulting)

LEVEL 3: PROFESSIONAL
  - Clear opening that answers "so what?"
  - Logical flow between sections
  - Tables for comparative data only
  - No hedging language
  - Defined scope and non-scope

LEVEL 2: COMPETENT
  - Organized with headings
  - Complete information
  - Generally clear prose
  - Appropriate formatting

LEVEL 1: BASIC
  - Information present
  - Some structure
```

---

## Quick Reference: Before/After Patterns

| Pattern | Before (Weaker) | After (Stronger) |
|---------|-----------------|------------------|
| **Lead with answer** | "This document describes the portal..." | "The portal enables +1-3% Active Days by..." |
| **Diagnosis first** | "We should build a dashboard" | "Teams lack visibility into compliance (diagnosis). A dashboard provides unified view (policy)." |
| **Testable hypothesis** | "Users will find this valuable" | "Value hypothesis: >80% of data producers log in weekly" |
| **Invite challenge** | "The solution is to..." | "Proposed approach: ... What alternatives should we consider?" |
| **Customer-first** | "The system will support..." | "Data producers can see their compliance status in real-time" |
| **Third-person voice** | "We need to..." | "The team delivers..." / "This requires..." |
| **Active voice** | "The data will be processed by the system" | "The system processes the data" |
| **Scope boundaries** | [only lists what's included] | "In scope: X, Y, Z. Out of scope: A, B, C" |

---

## Sources

**Books & Foundational Resources**
- The Elements of Style - Strunk & White
- On Writing Well - William Zinsser
- The Pyramid Principle - Barbara Minto (McKinsey)
- HBR Guide to Better Business Writing - Bryan Garner

**Product Thinkers**
- Marty Cagan - INSPIRED & EMPOWERED (SVPG)
- Eric Ries - The Lean Startup
- Richard Rumelt - Good Strategy Bad Strategy

**Tech Company Practices**
- Google Design Docs
- Amazon Working Backwards PR/FAQ
- Amazon 6-Pager Method
- Mailchimp Content Style Guide
- Microsoft Spec-Driven Development
- Stripe Writing Practices
