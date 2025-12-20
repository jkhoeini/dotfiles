{
  username,
  hostname,
  inputs,
  system,
  ...
}:
{
  imports = [
    ./packages.nix
    ./aliases.nix
    ./path.nix
    ./env.nix
  ];

  users.users.${username} = {
    name = username;
    home = /Users/${username};
  };

  system.primaryUser = username;

  networking.computerName = "${username}'s work macbook pro";
  networking.hostName = hostname;
  networking.knownNetworkServices = [
    "USB 10/100/1000 LAN"
    "Thunderbolt Ethernet Slot 0"
    "Wi-Fi"
    "Thunderbolt Bridge"
    "iPhone USB"
  ];
  networking.dns = [ ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.watchIdAuth = true;
  system.defaults.NSGlobalDomain._HIHideMenuBar = false; # don't autohide menu bar
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false; # Enable repeat keys
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = false;
  system.defaults.NSGlobalDomain.NSWindowResizeTime = 0.001;
  system.defaults.controlcenter.BatteryShowPercentage = true;
  system.defaults.controlcenter.NowPlaying = true;
  system.defaults.dock.autohide = true;
  system.defaults.dock.expose-animation-duration = 1.0e-3;
  system.defaults.dock.launchanim = false;
  system.defaults.dock.mru-spaces = false;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.finder._FXSortFoldersFirst = true;
  system.defaults.finder._FXSortFoldersFirstOnDesktop = true;
  system.defaults.menuExtraClock.Show24Hour = true;
  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.DragLock = true;
  system.defaults.trackpad.TrackpadFourFingerPinchGesture = 2;
  system.defaults.trackpad.TrackpadFourFingerVertSwipeGesture = 2;
  system.defaults.trackpad.TrackpadPinch = true;
  system.defaults.trackpad.TrackpadRightClick = true;
  system.defaults.trackpad.TrackpadRotate = true;
  system.defaults.trackpad.TrackpadThreeFingerDrag = true;
  system.defaults.universalaccess.mouseDriverCursorSize = 2.0;
  system.defaults.universalaccess.reduceMotion = true;
  system.keyboard.enableKeyMapping = true;
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
