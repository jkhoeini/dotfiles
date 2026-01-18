#!/usr/bin/env bash
set -euo pipefail

# Check if a program is installed (available on PATH)
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

macos ()
{
  # get the secrets
  eval "$(gpg --decrypt secrets.sh.gpg)"

  if ! command_exists brew; then
    echo "Installing HomeBrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if ! command_exists nix; then
    echo "Installing Nix"
    sh <(curl -L https://nixos.org/nix/install)
    sudo rm -f /etc/nix/nix.conf
  fi

  echo "Linking dotfiles"
  stow -t "$HOME" home_links

  echo "Applying nix configs"
  sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ./nix

  if [[ ! -e "$HOME/.config/emacs" ]]; then
    echo "Installing Doom Emacs"
    git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
    brew services restart d12frosted/emacs-plus/emacs-plus@30
  fi

  if [[ ! -e "$HOME/.config/nvim" ]]; then
    echo "Installing LazyVim"
    git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
  fi

  if [[ ! -e "$HOME/.intellimacs" ]]; then
    echo "Installing Intellimacs"
    git clone https://github.com/MarcoIeni/intellimacs "$HOME/.intellimacs"
  fi

  # run the ruby setup
  ./setup.rb
}

get_fs () {
  findmnt -n -o fstype $1
}

linux ()
{
  if [[ $(get_fs /) == "btrfs" ]]; then
    if [[ ! -e "/gnu" ]]; then
      sudo btrfs subvolume create /gnu
    fi
    if [[ ! -e "/var/guix" ]]; then
      sudo btrfs subvolume create /var/guix
    fi
  fi

  if ! command_exists guix; then
    if ! command_exists wget; then
      echo "install wget as needed by guix"
      sudo pacman --noconfirm -S wget
    fi

    if ! sudo systemctl list-unit-files nsncd.service; then
      yay --noconfirm -S nsncd-codyps-git
    fi
    
    if ! sudo systemctl is-active nsncd.service; then
      sudo systemctl enable nsncd
      sudo systemctl start nsncd
    fi

    TMPDIR=$(mktemp -d)
    trap "rm -rf '$TMPDIR'" EXIT

    cd "$TMPDIR"

    echo "Downloading Guix install script..."
    curl -fsSL https://git.savannah.gnu.org/cgit/guix.git/plain/etc/guix-install.sh -o guix-install.sh

    echo "Patching install script to use ftp.gnu.org..."
    perl -i -pe 's|ftpmirror\.gnu\.org|ftp.gnu.org|g' guix-install.sh

    chmod +x guix-install.sh

    sudo GUIX_ALLOW_OVERWRITE=1 ./guix-install.sh
  fi

  guix pull
  guix home reconfigure guix/home-configuration.scm
}

os="$(uname -s)"
case "${os}" in 
  Linux*) linux;;
  Darwin*) macos;;
  *) echo "Not supported OS: ${os}";;
esac
