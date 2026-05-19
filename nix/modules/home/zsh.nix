{ ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = false;

    shellAliases = {
      b = "brew";
      bi = "brew install";
      bs = "brew search";
      bd = "brew desc";
      c = "/opt/spotify-devex/bin/claude";
      "ga." = "ga .";
      ps = "procs --tree";
      top = "btm";
      em-reset = "brew services restart d12frosted/emacs-plus/emacs-plus@30";
      e = "emacsclient -n -c";
      w = "type -a";
      n = "nix";
      ns = "nix search nixpkgs";
      nre = "sudo darwin-rebuild switch --flake ~/Dev/dotfiles/nix\\#default";
    };

    initContent = ''
      source ''${XDG_CONFIG_HOME:-$HOME/.config}/zsh/rc.zsh
    '';
  };
}
