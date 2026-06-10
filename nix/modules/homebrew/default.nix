{ username, ... }:
{
  homebrew.enable = true;
  homebrew.global.brewfile = true;
  homebrew.onActivation.cleanup = "none"; # "none", "uninstall", "zap"
  homebrew.onActivation.extraEnv.XDG_CONFIG_HOME = "/Users/${username}/.config";

  homebrew.masApps = { };

  homebrew.brews = [
    # Plugin manager for zsh, inspired by antigen and antibody
    "antidote"
    # Resource monitor. C++ version and continuation of bashtop and bpytop
    "btop"
    # See where your AI coding tokens go - by task, tool, model, and project
    "codeburn"
    # Lua Lisp Language
    "fennel"
    # GitHub command-line tool
    "gh"
    # Distributed revision control system
    "git"
    # GNU Privacy Guard (OpenPGP)
    "gnupg"
    # AI coding agent, built for the terminal
    "opencode"
    # Create, run, and share large language models (LLMs)
    {
      name = "ollama";
      restart_service = "changed";
    }
    # Pinentry for GPG on Mac
    "pinentry-mac"
    # Paste PNG into files
    "pngpaste"
    # Quickly create and run optimised Windows, macOS and Linux virtual machines
    # "quickemu-project/quickemu/quickemu"
    # Search tool like grep and The Silver Searcher
    "ripgrep"
    # Interactive TUI scratchpad for building shell pipelines
    "rura"
    # Send macOS User Notifications from the command-line
    "terminal-notifier"
    # Check your $HOME for unwanted files and directories
    "xdg-ninja"
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
  ];

  homebrew.casks = [
    # Flashcard learning app
    "anki"
    # Android SDK component
    "android-platform-tools"
    # Tools for building Android applications
    "android-studio"
    # Private desktop AI chat application
    "anythingllm"
    # Chromium based browser
    "arc"
    # Web browser focusing on privacy
    "brave-browser"
    # Open-source browser prompter
    "browserosaurus"
    # Ghostty-based terminal with vertical tabs and notifications for AI coding agents
    "cmux"
    # OpenAI's coding agent that runs in your terminal
    "codex"
    # Claude code parallelisation
    "conductor"
    # App to build and share containerised applications and microservices
    "docker-desktop"
    # UI for running multiple coding agents in parallel
    "emdash"
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
    # Speech to text application
    "handy"
    # Utility to hide menu bar items
    "hiddenbar"
    # Free and open-source painting and sketching program
    "krita"
    # Privacy-first knowledge base
    "logseq"
    # Discover, download, and run local LLMs
    "lm-studio"
    # Simple Gtk# Paint Program
    "pinta"
    # app launcher. kept as brew since it's more uptodate
    "raycast"
    # Tool that provides consistent, highly configurable symbols for apps
    "sf-symbols"
    # Video game digital distribution service
    "steam"
    # Minimal GUI for AI code agents
    "t3-code"
    # Xcode Extension for reformatting Swift code
    "swiftformat-for-xcode"
    # Messaging app with a focus on speed and security
    "telegram"
    # Menu bar pomodoro timer
    "tomatobar"
    # Privacy enhanced BitTorrent client with P2P content discovery.
    # Disabled: Homebrew reports Gatekeeper failure; local signature is invalid/ad-hoc.
    # "tribler"
    # Virtual machines UI using QEMU
    "utm@beta"
    # Virtualization tool
    "virtualbuddy"
    # Open-source code editor
    "visual-studio-code"
  ];
}
