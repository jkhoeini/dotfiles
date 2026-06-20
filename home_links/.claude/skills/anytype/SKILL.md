---
name: anytype
description: Comprehensive guide for working with the Anytype gRPC CLI. Use when helping users work with the Anytype desktop app via gRPC, including bootstrapping credentials, discovering spaces, listing objects, querying, and manipulating dataview filters/sorts. Covers authentication flows, proto structures, filter conditions, layout enums, and Full-scope gRPC operations.
---

# Anytype gRPC CLI Skill

This skill provides operational knowledge for working with the Anytype Full-scope gRPC CLI.

## What the CLI Does

The Anytype gRPC CLI (`anytype` command) provides **Full-scope gRPC access** to a running Anytype desktop app on macOS. The desktop REST API covers ~20% of the gRPC surface; this CLI authenticates with Full scope (scope=2) and exposes every `anytype.ClientCommands` method, including dataview manipulation methods that the REST API cannot touch.

## Common CLI Commands

| Command | Purpose | Requires Auth |
|---------|---------|---------------|
| `anytype port` | Print the discovered gRPC port | No |
| `anytype version` | Print anytype-heart version | No |
| `anytype bootstrap` | One-time setup: create Full-scope appKey from mnemonic | No |
| `anytype session` | Print a fresh session token (for debugging) | Yes |
| `anytype list-spaces` | List all spaces with IDs, names, defaults | Yes |
| `anytype list-objects [spaceId]` | List objects in a space (defaults to default space) | Yes |
| `anytype get-object <objectId>` | Fetch a single object with full block tree and dataview config | Yes |
| `anytype search <spaceId> "<query>"` | Full-text search within a space | Yes |
| `anytype call <Method> [json]` | Call any `anytype.ClientCommands` method directly | Depends |
| `anytype list-apps` | List registered local-link apps with scopes | Yes |

## Bootstrap (One-Time Setup)

```bash
# 1. Get your 12-word mnemonic from: Anytype → Settings → Recovery phrase
# 2. Run bootstrap:
anytype bootstrap
# 3. Paste mnemonic when prompted (input is hidden)
```

This creates a persistent Full-scope `appKey` in `$XDG_CONFIG_HOME/anytype/credentials` (or `~/.config/anytype/credentials`). The mnemonic is never stored; you'll never need it again.

## Authentication Flow

**Bootstrap (one-time)**:
1. `WalletCreateSession(mnemonic)` → Full-scope ephemeral token
2. `AccountLocalLinkCreateApp(scope=2)` → persistent `appKey`
3. Store `appKey` in XDG config directory

**Per-run**:
1. `WalletCreateSession(appKey)` → Full-scope ephemeral token
2. Pass token in gRPC header for all subsequent calls

## Key Design Facts

1. **Port is dynamic**: Anytype binds to a random TCP port on each desktop restart. The CLI auto-discovers it via `lsof`.

2. **Spaces via tech space**: User-visible space IDs are the `targetSpaceId` of SpaceView objects (layout=18) in the internal "tech space". Use `anytype list-spaces` to get real space IDs.

3. **Auth scopes** (from models.proto):
   - Limited (0): Challenge-based, ~12 whitelisted methods only
   - JsonAPI (1): REST API tier
   - Full (2): All methods; requires mnemonic or Full-scope appKey
   - No-auth methods: `AppGetVersion`, `WalletCreateSession`, `AccountLocalLink*Challenge`

4. **Credentials storage**: Stored in XDG-compliant directories:
   - `$XDG_CONFIG_HOME/anytype/credentials` (or `~/.config/anytype/credentials` if XDG_CONFIG_HOME unset)

## Common Operations

### List all spaces
```bash
anytype list-spaces
```

Returns name, iconEmoji, spaceId, and which is the default.

### List objects in a space
```bash
anytype list-objects bafyrei...spaceid
# or omit space ID to use default space:
anytype list-objects
```

Returns id, name, type, snippet, layout, lastModifiedDate.

### Search a space
```bash
anytype search bafyrei...spaceid "my search query"
```

### Get a single object with its block tree and dataview config
```bash
anytype get-object bafyrei...objectid
```

Response includes `objectView.blocks[]` — every block on the page, including `dataview` blocks with full view/filter/sort config.

### Inspect an inline query's views and filters
```bash
anytype get-object <pageId> | jq '
  .objectView.blocks[]
  | select(.dataview != null)
  | {
      blockId: .id,
      source: .dataview.TargetObjectId,
      activeView: .dataview.activeView,
      views: [.dataview.views[] | {id, name, filters: .filters}]
    }
'
```

### Call any gRPC method directly
```bash
anytype call AppGetVersion '{}'
anytype call ObjectSearch '{"spaceId":"...","fullText":"parser","limit":5}'
anytype call WorkspaceOpen '{"spaceId":"..."}'
```

## Dataview Manipulation (Full-Scope Only)

These methods require Full scope and are **not available** via the REST API.

### Add a filter to a dataview view
```bash
anytype call BlockDataviewFilterAdd '{
  "contextId": "<pageId>",
  "blockId": "<dataviewBlockId>",
  "viewId": "<viewId>",
  "filter": {
    "RelationKey": "done",
    "condition": 1,
    "value": false,
    "format": "checkbox"
  }
}'
```

Filter condition values (numeric):
- 1 = Equal
- 2 = NotEqual
- 7 = Like (contains)
- 9 = In
- 11 = Empty
- 12 = NotEmpty
- 13 = GreaterOrEqual
- 14 = LessOrEqual

### Remove a filter
```bash
anytype call BlockDataviewFilterRemove '{
  "contextId": "<pageId>",
  "blockId": "<dataviewBlockId>",
  "viewId": "<viewId>",
  "ids": ["<filterId>"]
}'
```

### Update a filter
```bash
anytype call BlockDataviewFilterReplace '{
  "contextId": "<pageId>",
  "blockId": "<dataviewBlockId>",
  "viewId": "<viewId>",
  "id": "<filterId>",
  "filter": {
    "RelationKey": "priority",
    "condition": 13,
    "value": 2,
    "format": "number"
  }
}'
```

### Add a sort to a view
```bash
anytype call BlockDataviewSortAdd '{
  "contextId": "<pageId>",
  "blockId": "<dataviewBlockId>",
  "viewId": "<viewId>",
  "sort": {
    "RelationKey": "lastModifiedDate",
    "type": "Desc"
  }
}'
```

## Searching with Filters

ObjectSearch supports complex filters and sorts:

```bash
anytype call ObjectSearch "$(jq -n '{
  "spaceId": "bafyrei...",
  "filters": [
    {"RelationKey": "layout", "condition": 1, "value": 2},
    {"RelationKey": "done", "condition": 1, "value": false},
    {"RelationKey": "isArchived", "condition": 2, "value": true}
  ],
  "sorts": [{"RelationKey": "priority", "type": "Asc"}],
  "keys": ["id", "name", "priority", "dueDate"],
  "limit": 50
}')"
```

## Object Layout Enum

Numeric values (from models.proto):
- 0 = basic
- 1 = profile
- 2 = todo (Task)
- 3 = set
- 4 = objectType
- 5 = relation
- 6 = file
- 7 = dashboard
- 9 = note
- 10 = space
- 11 = bookmark
- 14 = collection
- 18 = spaceView

## Security

The credentials file is a Full-scope persistent key — treat it like a password. It's stored with `chmod 600`. Revoke it if compromised:

```bash
# Find the appHash
anytype list-apps | jq '.apps[] | select(.appName == "anytype-cli") | .appHash'

# Revoke it
anytype call AccountLocalLinkRevokeApp '{"appHash": "<hash>"}'
```

## When to Use Authenticated vs Non-Auth Calls

**Non-auth methods** (no session token needed):
- `AppGetVersion` — Get version
- `WalletCreateSession` — Create a session (with mnemonic or appKey)
- `AccountLocalLink*Challenge` — Challenge-based auth

**Auth methods** (Full-scope token required):
- Everything else: `ObjectSearch`, `ObjectShow`, `BlockDataviewFilterAdd`, dataview operations, space discovery, etc.

The CLI automatically handles this — use authenticated calls for most operations.

## Proto Structure

```
proto/                                 (grpcurl import root)
├── pb/protos/
│   ├── service/service.proto         (anytype.ClientCommands service)
│   ├── commands.proto                (all Rpc.*Request/Response types)
│   ├── events.proto
│   ├── snapshot.proto
│   └── changes.proto
└── pkg/lib/pb/model/protos/
    ├── models.proto                  (Block, Layout enum, FilterConditionType enum)
    └── localstore.proto
```

When inspecting gRPC responses, consult `models.proto` for enum values (Layout, FilterConditionType, etc.).
