{ ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = false;

    initContent = ''
      source ''${XDG_CONFIG_HOME:-$HOME/.config}/zsh/rc.zsh
    '';
  };
}
