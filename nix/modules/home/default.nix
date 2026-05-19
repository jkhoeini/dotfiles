{ username, ... }:
{
  home-manager.backupFileExtension = "hm-backup";

  home-manager.users.${username} = {
    home.username = username;
    home.homeDirectory = /Users/${username};
    home.stateVersion = "24.05";
    programs.home-manager.enable = true;
    home.preferXdgDirectories = true;
    home.language.base = "en_US.UTF-8";
    manual.html.enable = true;
  };
}
