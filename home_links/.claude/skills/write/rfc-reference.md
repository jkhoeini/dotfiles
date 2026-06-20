# RFC Writing Reference

Spotify-specific guidance for writing RFCs. Load this when document type is RFC.

> **Note:** The primary reference is backstage.spotify.net/docs/default/component/architecture/rfc-guide/ - use AIKA MCP (`spotify_internal_search` with `data_source: "techdocs"`) to access this and related Backstage content.

## Core Principle

**RFCs are tools, not outcomes.** Perfect is the enemy of good - the goal is alignment on direction.

## Preparation

- Skim the RFC Field Guide (Backstage)
- Read Stack Overflow: "How do I write a good RFC"
- Identify what you want feedback on explicitly
- Consider **Architecture Golf** - a technique to build understanding of the problem space with a small group before/during Draft state

## Structure (Spotify Template)

1. Summary (1-2 paragraphs)
2. Background/Context
3. Problem statement
4. Proposal (the recommended solution)
5. Alternatives Considered (with tradeoffs table)
6. Implementation Plan
7. Success Metrics
8. Risks & Mitigations
9. Timeline

## Writing

- Start from Spotify RFC template, follow italicized prompts
- Aim for 2-6 pages (diagrams can extend this)
- Set explicit end date for feedback (1-2 weeks)
- **Reviews vs Informed**: List critical sign-offs in "Reviews" section with status dropdowns; everyone else in "Informed" section
- Share in Draft state with small audience first for early sense-check

## TSG Kick-off

- Post RFC to your Studio's TSG channel or email (e.g., #content-platform-tsg)
- If you need specific domain expertise, say so: "I would like feedback from someone who understands security since this involves..."
- TSG assigns a facilitator and 2-3 reviewers based on domain expertise

## Seeking Review

- Set clear expectations when nudging: "I especially want feedback on the caching strategy"
- Keep commenters focused on document scope - suggest separate discussions for tangential topics
- Use different text color for significant changes during review (revert to black when Accepted)
- Integrate feedback into document continuously
- If comment thread exceeds 5-7 replies, it's too long - integrate, resolve, or schedule a quick meeting

## Comment Handling

- Aim to close all comments before closing the RFC
- Note disagreements in the Alternatives section rather than leaving threads open
- Modify the RFC to answer questions raised - future readers shouldn't have the same questions
- Sometimes you must agree to disagree - make clear who has decision ownership
- Reviewers: provide clear, actionable feedback; ask focused questions

## After Review

- Move document to Studio/Mission shared drive folder
- Set to view-only to prevent post-close edits
- Resolve any outstanding comment threads within a week
- **Do not leave comments on closed RFCs** - reach out to authors directly instead
- If Accepted: capture outcome in an ADR (Architecture Decision Record)
- If Rejected: still write an ADR documenting why; if problem persists, write a second RFC referencing the first

## ADR Connection

An ADR captures a single technical decision from an RFC. One RFC may produce multiple ADRs.

ADRs must include:
- Tracking number and title (ADR #n)
- Status: proposed, accepted, updates ADR #n, obsoletes ADR #n
- Date when first written
- Consulted squads or authors
- Context, Decision, Consequences
- Links to RFC
