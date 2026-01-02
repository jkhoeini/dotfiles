#!/usr/bin/env ruby
# frozen_string_literal: true

# check if program installed
def exec?(cmd)
  system("command -v #{cmd} >/dev/null")
end

unless exec?('brew')
  puts 'Installing HomeBrew'
  system 'bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
end

unless exec?('nix')
  puts 'Installing Nix'
  system 'sh <(curl -L https://nixos.org/nix/install)'
  system 'sudo rm -f /etc/nix/nix.conf'
end

puts 'Linking dotfiles'
system 'stow -t $HOME home_links'

puts 'Applying nix configs'
system 'sudo nix --extra-experimental-features \'nix-command flakes\' run nix-darwin -- switch --flake ./nix'

unless File.exist?(File.expand_path('~/.config/emacs'))
  puts 'Installing Doom Emacs'
  system 'git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs'
  system 'brew services restart d12frosted/emacs-plus/emacs-plus@30'
end

unless File.exist?(File.expand_path('~/.config/nvim'))
  puts 'Installing LazyVim'
  system 'git clone https://github.com/LazyVim/starter ~/.config/nvim'
end

unless File.exist?(File.expand_path('~/.intellimacs'))
  puts 'Installing Intellimacs'
  system 'git clone https://github.com/MarcoIeni/intellimacs ~/.intellimacs'
end
