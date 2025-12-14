{ pkgs
, inputs
, system
, username
, ...
}:

{
  users.users.${username} = {
    name = username;
    home = /Users/${username};
  };

  system.primaryUser = username;

  environment.systemPackages = with pkgs; [
    babashka
    bash
    bat
    # blurred ; dim background apps windows
    bottom
    cloc
    coconutbattery
    cowsay
    curlie
    direnv
    dust
    eza
    fd
    fzf
    git
    git-fame
    git-hub
    git-lfs
    google-cloud-sql-proxy
    grpcurl
    helix
    jj-fzf
    kanata
    lazygit
    nil
    nixd
    nixfmt-rfc-style
    typst
    vim
    yabai
    yt-dlp
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  security.pam.services.sudo_local.touchIdAuth = true;
  system.defaults.NSGlobalDomain._HIHideMenuBar = false; # don't autohide menu bar
  system.defaults.dock.autohide = true;
  system.defaults.dock.expose-animation-duration = 1.0e-3;
  system.defaults.dock.launchanim = false;
  system.defaults.dock.mru-spaces = false;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.trackpad.TrackpadThreeFingerDrag = true;
  system.defaults.universalaccess.reduceMotion = true;
  system.keyboard.remapCapsLockToEscape = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;

  nixpkgs.config.allowUnfree = true;
}
