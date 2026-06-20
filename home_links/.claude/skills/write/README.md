# Writing Subsystem

Business writing skill with Google Docs integration.

## Components

| Component | Path | Purpose |
|-----------|------|---------|
| **Write Skill** | `skills/write/write.md` | Core business writing patterns |
| **Google Workspace** | `skills/google-workspace/SKILL.md` | Google Workspace integration (Docs, Sheets, Slides) |
| **gwork CLI** | CLI commands (gdocs, gsheets, gslides) | Google Docs operations |
| **Memory** | `skills/write/memory/` | Writing patterns and preferences |

## gdocs Commands

```bash
gdocs export <doc_id> [-o file.md]    # Export as markdown
gdocs create "Title" <file.md>        # Create from markdown
gdocs update <doc_id> <file.md>       # Replace content
gdocs delete <doc_id>                 # Delete document
gdocs info <doc_id>                   # Show document info
gdocs get <doc_id> [--tabs]           # Get raw JSON
gdocs comments <doc_id> [--resolved]  # List comments
gdocs reply <doc_id> <comment_id> <text> [--resolve]
gdocs range-list <doc_id>             # List named ranges
gdocs find-text <doc_id> "text"       # Find text positions
gdocs patch <doc_id> <file.md> --range "Name"
```

## Workflow

1. Export document: `gdocs export <id> -o doc.md`
2. Edit locally in markdown
3. Update: `gdocs update <id> doc.md`
4. Handle comments: `gdocs comments <id>` then `gdocs reply ...`

## Related

- `@business-writer` agent for delegated writing tasks
