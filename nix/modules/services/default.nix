{ ... }:

{
  imports = [ ./sketchybar ];

  services.ipfs.enable = true;
  services.nextdns.enable = true;

  local.services.sketchybar.enable = false;
}
