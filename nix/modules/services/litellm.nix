{ config, ... }:
{
  launchd.user.agents.litellm = {
    script = ''
      #!/bin/sh
      . /Users/mohammadk/spotify.zsh
      # LiteLLM's os.environ/ syntax is unreliable in extra_headers.
      # Render the config with the actual key value at startup instead.
      sed "s|os.environ/TASKFORCE_API_KEY|$TASKFORCE_API_KEY|g" \
        /Users/mohammadk/.config/litellm/config.yaml \
        > /tmp/litellm-rendered.yaml
      exec /Users/mohammadk/.local/share/mise/shims/litellm \
        --config /tmp/litellm-rendered.yaml \
        --port 4000 \
        --host 127.0.0.1
    '';

    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      EnvironmentVariables = config.environment.variables;
      StandardOutPath = "/tmp/litellm.stdout.log";
      StandardErrorPath = "/tmp/litellm.stderr.log";
    };
  };
}
