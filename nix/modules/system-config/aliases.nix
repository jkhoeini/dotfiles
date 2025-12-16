{ ... }:
{
  environment.shellAliases = {
    b = "brew";
    bi = "brew install";
    bs = "brew search --desc";
    bd = "brew desc";

    l = "eza -aa";
    ll = "eza -lah --icons --group-directories-first --git";

    ps = "procs --tree";
    top = "btm";

    de = "emacs --init-directory $HOME/dotemacs/doom";
    em-reset = "brew services restart d12frosted/emacs-plus/emacs-plus@30";
    e = "$EDITOR";

    w = "type -a";

    nre = "sudo darwin-rebuild switch --flake ~/Dev/dotfiles/nix\\#default";
  };
}
