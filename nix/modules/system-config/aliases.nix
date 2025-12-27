{ ... }:
{
  environment.shellAliases = {
    b = "brew";
    bi = "brew install";
    bs = "brew search";
    bd = "brew desc";

    "ga." = "ga .";

    ps = "procs --tree";
    top = "btm";

    em-reset = "brew services restart d12frosted/emacs-plus/emacs-plus@30";
    e = "$EDITOR";

    w = "type -a";

    n = "nix";
    ns = "nix search nixpkgs";
    nre = "sudo darwin-rebuild switch --flake ~/Dev/dotfiles/nix\\#default";
  };
}
