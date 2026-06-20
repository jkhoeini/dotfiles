{ ... }:
{
  # Push the login PATH into the GUI (Aqua) session domain so apps launched from
  # Finder / Dock / Spotlight inherit the same PATH as a shell. The value is read
  # back from a non-interactive zsh, which sources /etc/zshenv (nix-darwin's
  # environment.systemPath), so it stays in sync with path.nix automatically.
  #
  # Note: processes read their environment at spawn time, so already-running apps
  # (Dock, early login items) only pick this up after relaunch or a logout/login.
  launchd.user.agents.setenv = {
    script = ''
      #!/bin/sh
      /bin/launchctl setenv PATH "$(/run/current-system/sw/bin/zsh -c 'printf %s "$PATH"')"
    '';

    serviceConfig = {
      RunAtLoad = true;
      StandardOutPath = "/tmp/setenv.stdout.log";
      StandardErrorPath = "/tmp/setenv.stderr.log";
    };
  };
}
