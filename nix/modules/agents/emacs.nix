{ config, ... }:
{
  launchd.user.agents.emacs = {
    script = ''
      #!/bin/sh
      export XDG_RUNTIME_DIR="$TMPDIR"
      # Re-derive PATH from /etc/zshenv (kept in sync with path.nix) at daemon
      # start, instead of inheriting the launchd domain. The setenv agent sets
      # launchctl PATH asynchronously at login; racing it leaves the daemon with
      # the bare /usr/bin:/bin PATH, so mise/jj/ispell vanish from exec-path.
      export PATH="$(/run/current-system/sw/bin/zsh -c 'printf %s "$PATH"')"
      exec /opt/homebrew/bin/emacs --fg-daemon
    '';

    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      ProcessType = "Interactive";
      EnvironmentVariables = config.environment.variables;
      StandardOutPath = "/tmp/emacs.stdout.log";
      StandardErrorPath = "/tmp/emacs.stderr.log";
    };
  };
}
