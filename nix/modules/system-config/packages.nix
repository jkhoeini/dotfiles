{ pkgs, ... }:
{
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
}
