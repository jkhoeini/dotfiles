#!/usr/bin/env zsh
set -euo pipefail

# get the secrets
eval "$(gpg --decrypt secrets.sh.gpg)"

# Check if a program is installed (available on PATH)
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

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
