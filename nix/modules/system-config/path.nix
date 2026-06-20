{ username, ... }:

let
  home = "/Users/${username}";
in
{
  environment.systemPath = [
    # mise-managed runtimes via shims — usable without `mise activate`, so GUI
    # apps and non-interactive shells resolve node/python/etc. Placed first so
    # mise wins over Homebrew, matching interactive precedence. Requires the
    # shims to be regenerated for the active mise (see modules/home reshim).
    "${home}/.local/share/mise/shims"
    # bun
    "${home}/.bun/bin"
    # Homebrew (Apple Silicon)
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"

    "${home}/.local/bin"
    "/opt/spotify-devex/bin"
    "${home}/.poetry/bin"
    "${home}/.cargo/bin"
    "${home}/.deno/bin"
    "${home}/Library/Application\\ Support/JetBrains/Toolbox/scripts"
    "${home}/.config/emacs/bin"
    "${home}/.luarocks/bin"
    "${home}/Library/Application\\ Support/Coursier/bin"
    "${home}/.antigravity/antigravity/bin"
    "${home}/.lmstudio/bin"
  ];
}
