{ ... }:
{
  imports = [
    ./sketchybar
    ./aerospace.nix
    ./jankyborders.nix
    ./lgtm.nix
  ];

  services.ipfs.enable = true;

  # cloud based service
  services.nextdns.enable = false;

  local.services.sketchybar.enable = false;
  local.services.lgtm.enable = true;
}
