# Omarchy configuration migration review

## Review status

This document preserves the assistant's proposed inventory from the conversation. **The user does not agree with all findings; the classifications and recommendations below are pending item-by-item review, not an approved migration plan.**

No configuration migrations or edits were performed as part of the audit. Saving this document does not approve or apply any proposed changes.

Paths beginning with **`C/`** mean `~/.config/`; **`R/`** means `~/src/dotfiles/home_links/.config/`.

## Audit context

The assistant compared files against the preserved Omarchy 3.8.5 checkout, current packaged defaults, generated configurations, and the dotfiles repo, and checked running Hyprland settings.

The original inventory separated claimed confirmed customizations and missing deployments from unexplained differences, so uncertain files would not be silently discarded. The findings below are preserved for review, rather than revalidated when saving this document.

## 1. Confirmed settings missing after Quattro

These need restoration **and** preservation in dotfiles.

### `C/hypr/monitors.conf` → `C/hypr/monitors.lua`

- Preserve explicit `DP-7` configuration: `3840×2160@60`, position `0×0`, scale `1.6`.
- Restore `eDP-1` position `2400×350`; the running desktop currently places it at `2400×0`.
- Preserve explicit `eDP-1` mode `2560×1600@165` and scale `1.6`, even though automatic selection currently happens to match.
- Reconcile old `GDK_SCALE=1.75` with current `2` rather than silently overwriting the newer choice.
- Keep the existing Lua `1.6` scaling override; that part is already applied.

## 2. Important live settings not adequately preserved in dotfiles

These remain on the machine; the problem is reproducibility or disagreement with existing repo files.

### `C/btop/btop.conf`

- Preserve `update_ms=1000`, `proc_sorting="user"`, `proc_tree=true`, and `proc_per_core=true`.
- Everything else previously highlighted—including its theme and most graph settings—is stock/generated.

### `C/mise/config.toml` ↔ `R/mise/config.toml`

- Preserve Kagi CLI `0.19.0` and `KAGI_API_KEY=false`, which deliberately removes an inherited API key.
- Review the explicit Node `25.2.1` pin; the repo requests `latest`, and its origin is not conclusively personal.
- Reconcile with the repo’s Java, Python, Ruby, Bun, Lua, Deno, Zig, Just, ACP, and other tool selections; **do not replace either file wholesale**.

### `C/git/config` ↔ `R/git/config`

- Reconcile the different Git identities.
- Decide which repo-owned workflow settings should apply on Linux: signing, Delta, merge/diff tools, fast-forward-only pulls, and default branch.
- The rest of the live Linux Git configuration is Omarchy stock—not personal settings to copy over the repo.
- Keep macOS signing-key and repository paths platform-specific.

### `C/jj/config.toml`

- Preserve your Jujutsu identity; there is no corresponding dotfiles configuration.

### `C/jj/repos/d4e2b3df2c60232aabe0/config.toml`

- Preserve `trunk() = main@origin`, specifically for **`~/src/dotfiles`**; its metadata identifies that repository.
- Recreate the repository-scoped setting deliberately rather than copying the hashed directory and metadata.

### `C/guix/channels.scm`

- Preserve the five added channels: Nonguix, Guix Gaming Games, Guix Science, Guix Science Past, and Guix Science Nonfree.
- Preserve their authenticated introductions; this source file is currently absent from dotfiles.
- Do not substitute `C/guix/current`, which is generated profile state.

### `C/cliamp/config.toml`

- Preserve Spotify provider configuration and your chosen client ID handling.
- Empty theme and bitrate `320` are defaults, not custom tuning.
- Keep `spotify_credentials.json` out of the repo.

### `C/user-dirs.dirs`

- Preserve the extra `XDG_PROJECTS_DIR="$HOME/Projects"` declaration.
- The other directory choices and GTK bookmarks are standard/generated Omarchy setup.

### `C/Typora/profile.data` — missed by the first inventory

- Preserve strict Markdown mode, copying Markdown by default, and preserving line breaks on export.
- Preserve these preferences selectively; the file also contains identifiers and window/application state.
- The export-line-break choice differs from the installed application’s default; exact provenance of the other two remains unverified.

### Personal application/theme selections

These are choices worth recording in deployment, not reasons to copy whole default configurations.

**`C/xdg-terminals.list`**

- Preserve Ghostty as your preferred terminal.

**`C/omarchy/defaults/agent`**

- Preserve `omp` as your preferred agent.

**`~/.local/state/omarchy/defaults/editor`**

- Preserve Emacs as your default editor; this important choice lives outside `~/.config`.

**`C/omarchy/shell.json`**

- Its only semantic difference from current stock is the Tailscale widget.
- Preserve the Tailscale integration choice, not the full stock bar layout.

**`~/.local/state/omarchy/current/theme.name` and `current/background`**

- Preserve selected theme `space-monkey` and wallpaper `01-Retro.png`.

**`C/omarchy/themes/`**

- Record installation sources/revisions for `space-monkey`, `pina`, `evergarden`, `bauhaus`, `retropc`, and `mechanoonna`.
- All six checkouts are unmodified, including no ignored local extras; their individual CSS/palette files are **not personal customizations**.

## 3. Already in dotfiles, but missing from Linux deployment

The underlying issue is **`~/src/dotfiles/guix/home-configuration.scm`**: Linux deploys only six explicitly listed configuration files. Unlike the macOS branch of `setup.sh`, it does not Stow the whole tree.

### `~/src/dotfiles/guix/home-configuration.scm`

- Extend the explicit Linux deployment to cover the desired missing sources and newly preserved settings.
- Keep generated shell, Fontconfig, and Shepherd output derived from this source rather than copying `/gnu/store` products.

### `~/src/dotfiles/setup.sh`

- Ensure newly added files actually become part of Linux setup; adding them beneath `home_links` alone currently does not accomplish that.

### Enabled Doom modules: definite deployment gaps

Your live-linked `doom/init.el` explicitly enables both modules below, but their implementation files are absent from `C/doom`.

**`R/doom/modules/tools/agent-sessions/config.el`**

- Loads your agent-session setup and integrations.

**`R/doom/modules/tools/agent-sessions/agent-shell-sessions.el`**

- Implements persistent agent-session management.

**`R/doom/modules/tools/agent-sessions/agent-shell-sessions-consult.el`**

- Provides Consult-based session selection.

**`R/doom/modules/tools/agent-sessions/agent-shell-sessions-embark.el`**

- Provides Embark actions for sessions.

**`R/doom/modules/tools/project-hub/config.el`**

- Configures your project hub and its keybindings.

**`R/doom/modules/tools/project-hub/autoload/project-hub.el`**

- Implements the unified buffer/workspace/project/session picker and pinning.

These omissions are proven; **the audit has not established that Quattro caused them**.

### Other repo-owned files absent on Linux: choose deployment intentionally

**`R/opencode/AGENTS.md`**

- Contains your personal agent instructions and Jujutsu workflow.

**`R/opencode/skills/implement`**

- Links your existing implementation skill; the corresponding live link is absent.

**`R/clojure/deps.edn`**

- Contains your Sayid dependency selection.

**`R/clojure/tools/tools.edn`**

- Contains the selected `tools.tools` registration/version.

**`R/ideavim/ideavimrc`**

- Contains Intellimacs integration and personal navigation/refactoring preferences.

**`R/wezterm/wezterm.lua`**

- Contains Twilight/font, multiplexer, pane, and keybinding preferences.

**`R/zellij/config.kdl`**

- Contains scrollback, clipboard, and pane preferences; `pbcopy` requires Linux adaptation.

**`R/doom/custom.el`**

- Contains selected packages and trusted directory-local values, including macOS-specific Typst paths.
- Review rather than automatically deploying those machine-specific trust entries.

### Existing terminal sources: preserve, do not overwrite with Linux stock

**`R/ghostty/config`**

- Already preserves Twilight and macOS Option-as-Alt preferences, unlike the live Omarchy configuration.

**`R/alacritty/alacritty.toml`**

- Already preserves different fonts, palette, bell, window, and keyboard settings with macOS-specific elements.

**`R/alacritty/alacritty.yml`**

- Retains a legacy-format configuration; reconcile any wanted preferences before retiring it.

## 4. Unexplained differences: retain for review, not automatic migration

These are the remaining files where dropping a difference outright could lose intent. Most appear to be older stock revisions, but that is not proven for every change.

### `C/kitty/kitty.conf`

- Omits `cursor_blink_interval 0` and `shell_integration no-cursor`, both present in the old and current Omarchy defaults.
- Determine whether this cursor behavior was intentional before refreshing or versioning it.

### `C/nvim/lua/config/options.lua`

- Omits current package setting `vim.g.autoformat = false`; retain that behavioral difference for review.
- Relative-number suppression and the remote-clipboard setup are stock.

### `C/nvim/lua/plugins/all-themes.lua`

- Has older theme-plugin repositories/catalog entries and lacks current Aether `branch`/`name` settings.
- Treat as package drift to reconcile, not automatically as a personal plugin list.

### `C/nvim/lua/plugins/omarchy-theme-hotreload.lua`

- Lacks the current package’s branch that reloads an already-loaded theme plugin.
- Review for updating; copying it into dotfiles would otherwise preserve an older integration.

### `C/tmux/tmux.conf`

- Omits the reload notification and newer packaged help popup/binding descriptions.
- Its extensive keymap is stock, and the appended OSC 52 setting was migration-generated.

### `C/systemd/user/voxtype.service`

- Shadows the packaged unit with different startup arguments and missing PipeWire ordering/ydotool dependency.
- Review the user-unit override; do not assume its mere presence means a custom service must be preserved.

### `C/Typora/themes/night.css`

- Differs from the installed theme by square list bullets and missing newer toolbar styling.
- Could be an older bundled theme rather than a personal edit; keep this distinction unresolved for now.

### `C/waybar.omarchy-upgrade-to-quattro.20260823221754.bak/style.css.bak.1782247790`

- The older nested backup has a `5px` clock margin instead of `8.75px`; no exact historical stock match was established.
- Low-priority historical preference only—not a reason to restore Waybar.

### `C/hypr/bindings.conf`: older stock shortcuts

- `Super+Shift+T` → btop was an old stock shortcut; current stock uses `Super+Ctrl+T`.
- `Super+Shift+W` → Typora was old stock; current stock launches Omawrite.
- Restore these only if you want the previous workflow, not because they were proven custom edits.

## 5. Important files already safely source-backed

These six are tracked in dotfiles and their live symlinks resolve back to the same source files. **No live-to-repo copying is needed.**

**`R/zsh/rc.zsh`**

- Preserves your shell, history, completion, aliases, prompt, and integration settings.

**`R/antidote/plugins.txt`**

- Preserves your plugin selections; `plugins.zsh` is generated, machine-specific loader output.

**`R/doom/config.el`**

- Preserves your editor workflows, language setup, agents, Org, and terminal integrations.

**`R/doom/init.el`**

- Preserves module selections, including the two currently undeployed custom modules.

**`R/doom/packages.el`**

- Preserves additional package selections.

**`R/doom/themes/doom-twilight-theme.el`**

- Preserves your Doom Twilight theme implementation.

## What should stay out of the migration list

- **Main Waybar config/style, Walker, Fastfetch, Hypridle, Starship, Ghostty, Foot, Herdr, Voxtype settings, most Neovim files:** verified stock/generated, not personal work to rescue.
- **`hypr/hyprlock.conf`:** its fingerprint changes were produced by Omarchy’s setup command; current fingerprint PAM configuration and enrollment are present, so do not port the obsolete Hyprlock file.
- **Generated theme files, service-enablement links, browser manifests, branding, stock MIME associations, and GTK bookmarks:** reproduce through their owning setup mechanisms.
- **`kagi-cli/config.toml`, Spotify credentials, KDE Connect keys, and Raspberry Pi Imager credentials:** preserve separately if needed, but never copy into ordinary tracked dotfiles.
- **Window geometry, recent-file history, caches, and incidental application state:** intentionally excluded, not overlooked.

## Proposed priority — pending user review

Review the remaining Hyprland monitor overrides, fix Doom module deployment, capture the live-only preferences above, then reconcile the small review bucket. Do not bulk-copy `~/.config` or overwrite existing cross-platform repo files with Omarchy defaults.
