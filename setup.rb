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

# use these js in chrome console to sort these.
# function formulaName(str) { return str.trim().replaceAll(/;+/g, ';').replace(/;? ?([^ ]+).*/, "$1").replace(/^(.+\/)?([^/]+)$/, "$2") }
# console.log(str.split('\n').toSorted((a, b) => formulaName(a) < formulaName(b) ? -1 : 1).join('\n'))
formula_list = <<HEREDOC.gsub(/;.*$/, '').split("\n").map(&:strip).reject(&:empty?)
  nikitabobko/tap/aerospace ; window manager
  antidote ; ZSH plugin manager.
  bazelisk ; nice cli for bazel build system
  browserosaurus ; select which browser
  ;; burklee
  ;; c-ares
  ;; concurrencykit
  coreutils
  ;; dav1d
  ;; desktop-file-utils
  ;diffusionbee ; Stable Diffusion mac image tool
  docker ; docker desktop. Uses correct arch
  ;; double-conversion
  ;; edex-ui
  ;; fb303
  firefox
  ;; fizz
  flux ; set color temp at evening
  ;; fmt
  ;; folly
  ;; font-code-new-roman-nerd-font
  ;; font-dejavu-sans-mono-nerd-font
  font-droid-sans-mono-nerd-font
  ;; font-fira-code-nerd-font
  ;; font-firacode-nerd-font
  ;; font-hack-nerd-font
  ;; font-hasklig
  ;; font-hasklig-nerd-font
  font-iosevka-nerd-font
  font-jetbrains-mono-nerd-font
  font-juliamono
  ;; font-lilex
  ;; font-monoid-nerd-font
  ;; font-noto-nerd-font
  font-roboto-mono-nerd-font ; used for alacritty
  ;; font-victor-mono-nerd-font
  mkhoeini/tap/fortune-mod ; beautiful quotes in the terminal. TODO include more quotes
  ;; frei0r
  ;; fx
  ;; fzy
  ;; gd
  ghostty
  git-delta ; show beautiful git diffs in terminal
  ;; glog
  gnu-sed ; standard sed util implementation
  google-cloud-sdk ; cli for google cloud
  ;; graphite2
  ;; guile
  ;; hades-cli
  hammerspoon ; desktop automation tool
  hiddenbar ; make taskbar icons hidden
  ;; highway
  hyperfine ; terminal benchmark util
  ;iina ; greate video player
  ;ijq ; interactive jq for json manipulation
  intellij-idea-ce
  ispell ; emacs uses this for spell checking
  itsycal ; calendar menubar
  jq ; commandline json util
  jupyterlab
  just ; better make alternative
  krita
  ;; lapce ; Rust based GUI editor
  lazygit ; git TUI
  ;; leptonica
  logseq ; personal knowledge management
  lolcat ; make terminal quotes colorful
  luarocks ; package management for lua
  maven ; java package manager
  mise
  ;; mitmproxy
  remotemobprogramming/brew/mob ; mob cli for mobbing
  ;neovide ; GUI for neovim
  neovim ; better vim alternative
  ollama
  ;; onefetch
  ;onething ; TODO doesn't exist - focus on one thing at a time
  ;; oniguruma
  ;; opus
  p7zip ; 7zip compression with new extentions
  pandoc
  ;; pixman
  ponysay ; cowsay alternative
  ;; prettyping
  procs ; better ps alternative
  ;; qutebrowser
  ;rancher ; Docker Desktop replacement
  ;ranger ; terminal file manager
  ;; rav1e
  raycast ; App Launcher
  ;rectangle ; Window management with keyboard
  ;; retinizer
  ripgrep ; cli search util
  rlwrap ; readline cli util
  ;; shellcheck
  ;; showkey
  ;; six
  ;; snappy
  ;; speedtest-cli
  ;; speex
  ;; spgrpcurl
  ;; spotify
  ;; spotify-disco
  ;; spotify-nameless-cli
  ;starship ; zsh prompt. instead use powerlevel10k
  stow ; symlink management
  ;; styx-cli
  ;; swiftdefaultappsprefpane
  ;; tcl-tk
  telegram
  ;; telegram-desktop ; electron based
  tinymist
  ;; todoist
  tomatobar ; pomodoro menubar
  ;; tree-sitter
  triangle ; Convert images to triangulation art
  tribler ; torrent download client
  ;; ttyplot
  ;; unbound
  utm@beta
  uv
  ;; v2ray
  ;vimac ; TODO doesn't exist - mac vim mode hints overlay
  ;vimr ; another vim GUI
  visual-studio-code
  ;; wangle
  watchexec ; run commands on file change
  ;; websocat
  wezterm
  ;; xbar ; menubar super app
  xdg-ninja ; Config dotfiles to be in XDG folders - TODO apply suggestions
  zed
  ;zellij ; better tmux alternative
  ;zoxide ; better cd alternative. z command
  zsh
  ;; zstd
HEREDOC

installed_formulas = `brew list --full-name`
formula_list
  .reject { |formula| installed_formulas.include? formula }
  .each { |formula| `brew install "#{formula}"` }

requested_luarocks_plugins = <<-HEREDOC.gsub(/;.*$/, '').strip.split(/\s+/)
  fennel
HEREDOC

installed_luarocks_plugins = `luarocks list --porcelain`
requested_luarocks_plugins
  .reject { |plugin| installed_luarocks_plugins.include? plugin }
  .each { |plugin| `luarocks install #{plugin}` }
