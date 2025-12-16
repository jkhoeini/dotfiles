{ username, ... }:

let
  home = "/Users/${username}";
in
{
  environment.systemPath = [
    "${home}/.local/bin/"
    "${home}/.poetry/bin"
    "${home}/.cargo/bin"
    "${home}/.deno/bin"
    "${home}/Library/Application\\ Support/JetBrains/Toolbox/scripts"
    "${home}/dotemacs/doom/bin"
    "${home}/.luarocks/bin"
    "${home}/Library/Application\\ Support/Coursier/bin"
    "${home}/.antigravity/antigravity/bin"
  ];
}
