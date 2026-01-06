{ ... }:
{
  imports = [
    ./sketchybar
    ./aerospace.nix
    ./jankyborders.nix
  ];

  services.ipfs.enable = true;

  # cloud based service
  services.nextdns.enable = false;

  local.services.sketchybar.enable = false;
}
