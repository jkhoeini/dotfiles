{ username, ... }:
{
  imports = [
    ./base.nix
  ];

  home.username = username;
  home.homeDirectory = /Users/${username};
}
