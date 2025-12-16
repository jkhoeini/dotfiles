{ ... }:
{
  homebrew.enable = true;
  homebrew.global.brewfile = true;
  homebrew.onActivation.cleanup = "none"; # "none", "uninstall", "zap"

  homebrew.masApps = { };
  homebrew.whalebrews = [ ];

  homebrew.brews = [
    # Plugin manager for zsh, inspired by antigen and antibody
    "antidote"
    # Remove large files or passwords from Git history like git-filter-branch
    # "bfg"
    # Search tool like grep and The Silver Searcher
    "ripgrep"
    # GNU File, Shell, and Text utilities
    "coreutils"
    # Isolated development environments using Docker
    "docker-compose"
    # Embeddable SQL OLAP Database Management System
    "duckdb"
    # Command-line tool to interact with exercism.io
    "exercism"
    # Lua Lisp Language
    "fennel"
    # Fuzzy-find cli jira interface
    "fjira"
    # Command-line fuzzy finder written in Go
    "fzf"
    # GNU compiler collection
    "gcc"
    # OCR (Optical Character Recognition) engine
    # "tesseract"
    # Syntax-highlighting pager for git and diff output
    "git-delta"
    # Tool Command Language
    "tcl-tk"
    # Validating, recursive, caching DNS resolver
    "unbound"
    # GNU Privacy Guard (OpenPGP)
    "gnupg"
    # Open source programming language to build simple/reliable/efficient software
    "go"
    # Post-modern modal text editor
    "helix"
    # Command-line benchmarking tool
    "hyperfine"
    # Lightweight and flexible command-line JSON processor
    "jq"
    # Tools and libraries to manipulate images in many formats
    "imagemagick"
    # International Ispell
    "ispell"
    # Git-compatible distributed version control system
    "jj"
    # Simple terminal UI for git commands
    "lazygit"
    # Rainbows and unicorns in your console!
    "lolcat"
    # Make your console colorful, with OpenSimplex noise
    "lolcrab"
    # Clone of ls with colorful output, file type icons, and more
    "lsd"
    # Package manager for the Lua programming language
    "luarocks"
    # Polyglot runtime manager (asdf rust clone)
    "mise"
    # Ambitious Vim-fork focused on extensibility and agility
    "neovim"
    # Create, run, and share large language models (LLMs)
    {
      name = "ollama";
      restart_service = "changed";
    }
    # Cryptography and SSL/TLS Toolkit
    "openssl@1.1"
    # 7-Zip (high compression file archiver) implementation
    "p7zip"
    # Pinentry for GPG on Mac
    "pinentry-mac"
    # Cowsay but with ponies
    "ponysay"
    # Framework for managing multi-language pre-commit hooks
    "pre-commit"
    # Modern replacement for ps written in Rust
    "procs"
    # Readline wrapper: adds readline support to tools that lack it
    "rlwrap"
    # Fuzzy Finder in rust!
    "sk"
    # Organize software neatly under a single directory tree (e.g. /usr/local)
    "stow"
    # Services for Typst
    "tinymist"
    # Convert images to computer generated art using Delaunay triangulation
    "triangle"
    # Extremely fast Python package installer and resolver, written in Rust
    "uv"
    # Check your $HOME for unwanted files and directories
    "xdg-ninja"
    # Feature-rich command-line audio/video downloader
    "yt-dlp"
    # GNU Emacs text editor
    {
      name = "d12frosted/emacs-plus/emacs-plus@30";
      args = [
        "with-compress-install"
        "with-imagemagick"
        "with-modern-vscode-icon"
        "with-xwidgets"
      ];
    }
    # A window border system for macOS
    "felixkratz/formulae/borders"
    # A tiling window manager for macOS based on binary space partitioning.
    "koekeishiya/formulae/yabai"
    # Quantum Mechanical Keyboard (QMK) Firmware
    "qmk/qmk/qmk"
  ];

  homebrew.casks = [
    # Android SDK component
    "android-platform-tools"
    # Tools for building Android applications
    "android-studio"
    # Memory training application
    "anki"
    # Chromium based browser
    "arc"
    # Web browser focusing on privacy
    "brave-browser"
    # Open-source browser prompter
    "browserosaurus"
    # Run Stable Diffusion locally
    "diffusionbee"
    # App to build and share containerised applications and microservices
    "docker-desktop"
    # Web browser
    "firefox"
    # Screen colour temperature controller
    "flux-app"
    "font-carlito"
    "font-droid-sans-mono-nerd-font"
    "font-inter"
    "font-iosevka-nerd-font"
    "font-jetbrains-mono-nerd-font"
    "font-juliamono"
    "font-libre-baskerville"
    "font-lora"
    "font-merriweather"
    "font-merriweather-sans"
    "font-roboto-mono-nerd-font"
    "font-rubik"
    "font-sf-mono"
    "font-sf-mono-for-powerline"
    "font-sf-pro"
    # Terminal emulator that uses platform-native UI and GPU acceleration
    "ghostty"
    # Free and open-source image editor
    "gimp"
    # Desktop automation application
    "hammerspoon"
    # Utility to hide menu bar items
    "hiddenbar"
    # Menu bar calendar
    "itsycal"
    # Keyboard customiser
    # "karabiner-elements"
    # Free and open-source painting and sketching program
    "krita"
    # Privacy-first, open-source platform for knowledge sharing and management
    "logseq"
    # Knowledge base that works on top of a local folder of plain text Markdown files
    "obsidian"
    # Simple Gtk# Paint Program
    "pinta"
    # Control your tools with a few keystrokes
    "raycast"
    # Tool that provides consistent, highly configurable symbols for apps
    "sf-symbols"
    # Video game digital distribution service
    "steam"
    # Xcode Extension for reformatting Swift code
    "swiftformat-for-xcode"
    # Messaging app with a focus on speed and security
    "telegram"
    # Menu bar pomodoro timer
    "tomatobar"
    # Privacy enhanced BitTorrent client with P2P content discovery
    "tribler"
    # Virtual machines UI using QEMU
    "utm@beta"
    # Virtualization tool
    "virtualbuddy"
    # Open-source code editor
    "visual-studio-code"
    # Multiplayer code editor
    "zed"
  ];
}
