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

MACOS_DEFAULTS = {
  # Enable repeat keys
  ApplePressAndHoldEnabled: '-bool false',

  # opening and closing windows and popovers
  NSAutomaticWindowAnimationsEnabled: '-bool false',

  # smooth scrolling
  NSScrollAnimationEnabled: '-bool false',

  # showing and hiding sheets, resizing preference windows, zooming windows
  # float 0 doesn't work
  NSWindowResizeTime: '-float 0.001',

  # opening and closing Quick Look windows
  QLPanelAnimationDuration: '-float 0',

  # rubberband scrolling (doesn't affect web views)
  NSScrollViewRubberbanding: '-bool false',

  # resizing windows before and after showing the version browser
  # also disabled by NSWindowResizeTime -float 0.001
  NSDocumentRevisionsWindowTransformAnimation: '-bool false',

  # showing a toolbar or menu bar in full screen
  NSToolbarFullScreenAnimationDuration: '-float 0',

  # scrolling column views
  NSBrowserColumnAnimationSpeedMultiplier: '-float 0'
}.freeze

# TODO: app defaults
# showing the Dock
# defaults write com.apple.dock autohide-time-modifier -float 0
# defaults write com.apple.dock autohide-delay -float 0

# showing and hiding Mission Control, command+numbers
# defaults write com.apple.dock expose-animation-duration -float 0

# showing and hiding Launchpad
# defaults write com.apple.dock springboard-show-duration -float 0
# defaults write com.apple.dock springboard-hide-duration -float 0

# changing pages in Launchpad
# defaults write com.apple.dock springboard-page-duration -float 0

# at least AnimateInfoPanes
# defaults write com.apple.finder DisableAllAnimations -bool true

# sending messages and opening windows for replies
# defaults write com.apple.Mail DisableSendAnimations -bool true
# defaults write com.apple.Mail DisableReplyAnimations -bool true

MACOS_DEFAULTS.each_pair do |opt, val|
  system "defaults write -g #{opt} #{val}"
end

requested_luarocks_plugins = <<-HEREDOC.gsub(/;.*$/, '').strip.split(/\s+/)
  fennel
HEREDOC

installed_luarocks_plugins = `luarocks list --porcelain`
requested_luarocks_plugins
  .reject { |plugin| installed_luarocks_plugins.include? plugin }
  .each { |plugin| `luarocks install #{plugin}` }
