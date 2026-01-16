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
    # Lua Lisp Language
    "fennel"
    # GNU Privacy Guard (OpenPGP)
    "gnupg"
    # Create, run, and share large language models (LLMs)
    {
      name = "ollama";
      restart_service = "changed";
    }
    # Pinentry for GPG on Mac
    "pinentry-mac"
    # Quickly create and run optimised Windows, macOS and Linux virtual machines
    # "quickemu-project/quickemu/quickemu"
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
    # Desktop automation application
    "hammerspoon"
    # Speech to text application
    "handy"
    # Utility to hide menu bar items
    "hiddenbar"
    # Free and open-source painting and sketching program
    "krita"
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
  ];
}
