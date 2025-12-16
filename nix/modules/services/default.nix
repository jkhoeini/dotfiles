{ ... }:
{
  imports = [
    ./sketchybar
    ./aerospace.nix
  ];

  services.ipfs.enable = true;
  services.nextdns.enable = true;

  local.services.sketchybar.enable = false;
}
