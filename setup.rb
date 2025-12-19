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

unless exec?('emacs')
  puts 'Installing Emacs'
  system 'brew install d12frosted/emacs-plus/emacs-plus@30 ' \
         '--with-native-comp --with-modern-vscode-icon --with-xwidgets ' \
         '--with-imagemagick --with-compress-install --with-no-frame-refocus'
end

unless exec?('stow')
  puts 'Installing GNU Stow'
  system 'brew install stow'
end

puts 'Linking dotfiles'
system 'stow -t $HOME home_links'

unless File.exist?(File.expand_path('~/dotemacs/doom'))
  puts 'Installing Doom Emacs'
  system 'git clone --depth 1 https://github.com/doomemacs/doomemacs ~/dotemacs/doom'
  system 'ln -s ~/dotemacs/doom ~/.emacs.d'
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

requested_luarocks_plugins = <<-HEREDOC.gsub(/;.*$/, '').strip.split(/\s+/)
  fennel
HEREDOC

installed_luarocks_plugins = `luarocks list --porcelain`
requested_luarocks_plugins
  .reject { |plugin| installed_luarocks_plugins.include? plugin }
  .each { |plugin| `luarocks install #{plugin}` }
