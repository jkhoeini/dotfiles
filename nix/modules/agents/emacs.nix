{ config, ... }:
{
  launchd.user.agents.emacs = {
    script = ''
      #!/bin/sh
      export XDG_RUNTIME_DIR="$TMPDIR"
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
