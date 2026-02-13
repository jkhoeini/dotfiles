{ pkgs, ... }:
{
  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Register Nix zsh in /etc/shells so it can be used as a login shell.
  environment.shells = [ pkgs.zsh ];
  programs.zsh.histFile = "$HOME/.histfile";
  programs.zsh.histSize = 10000;
  programs.zsh.enableFzfGit = true;
  programs.zsh.enableFzfHistory = true;
  programs.zsh.enableSyntaxHighlighting = true;
}
