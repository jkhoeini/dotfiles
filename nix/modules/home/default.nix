{ username, ... }:
{
  home-manager.backupFileExtension = "hm-backup";

  home-manager.users.${username} =
    { lib, ... }:
    {
      imports = [ ./zsh.nix ];

      home.username = username;
      home.homeDirectory = /Users/${username};
      home.stateVersion = "24.05";
      programs.home-manager.enable = true;
      home.preferXdgDirectories = true;
      home.language.base = "en_US.UTF-8";
      manual.html.enable = true;

      # Keep mise shims pointed at the active (Homebrew) mise on every rebuild.
      # Without this the shims can dangle (e.g. to a stale nix mise path), which
      # silently breaks the mise shims dir added to environment.systemPath.
      home.activation.miseReshim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        /opt/homebrew/bin/mise reshim || true
      '';
    };
}
