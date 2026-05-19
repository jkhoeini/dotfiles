{ pkgs, ... }:
{
  programs.zsh.enable = true;
  programs.zsh.enableGlobalCompInit = false;
  environment.shells = [ pkgs.zsh ];
}
