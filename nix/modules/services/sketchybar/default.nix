{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.local.services.sketchybar;
in
{
  options.local.services.sketchybar = {
    enable = lib.mkEnableOption "sketchybar configuration";
  };

  config = lib.mkIf cfg.enable {
    services.sketchybar = {
      enable = true;
      extraPackages = [ pkgs.babashka ];
      config =
        let
          sketchyBarGit = pkgs.fetchgit {
            url = "https://github.com/FelixKratz/SketchyBar.git";
            rev = "v2.21.0";
            sha256 = "hTfQQjx6ai83zYFfccsz/KaoZUIj5Dfz4ENe59gS02E=";
          };
  # Keep this comment for reference
  # FelixKratzDotfiles = pkgs.fetchgit {
  #   url = "https://github.com/FelixKratz/dotfiles.git";
  #   rev = "1589c769e28f110b1177f6a83fa145235c8f7bd6";
  #   sha256 = "";
  # };
          plugins = sketchyBarGit + /plugins;
          sketchybarrc = builtins.readFile ./sketchybarrc;
        in
        builtins.replaceStrings [ "$PLUGINS" ] [ "${plugins}" ] sketchybarrc;
    };
  };
}
