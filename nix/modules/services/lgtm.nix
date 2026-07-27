{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.local.services.lgtm;

  tempoConfig = pkgs.writeTextFile {
    name = "tempo-config";
    destination = "/tempo-config.yaml";
    text = ''
      server:
        http_listen_port: 3200
        grpc_listen_port: 9096

      distributor:
        receivers:
          otlp:
            protocols:
              grpc:
                endpoint: "127.0.0.1:4417"
              http:
                endpoint: "127.0.0.1:4418"

      ingester:
        trace_idle_period: 1s
        max_block_duration: 1s
        flush_check_period: 1s
        lifecycler:
          address: 127.0.0.1
          ring:
            kvstore:
              store: inmemory
            replication_factor: 1
          min_ready_duration: 1s

      memberlist:
        bind_addr: [127.0.0.1]
        bind_port: 7947

      query_frontend:
        mcp_server:
          enabled: true

      querier:
        frontend_worker:
          frontend_address: 127.0.0.1:9096

      storage:
        trace:
          backend: local
          wal:
            path: /data/tempo/wal
          local:
            path: /data/tempo/blocks

      metrics_generator:
        processor:
          local_blocks:
            filter_server_spans: false
          span_metrics:
            dimensions:
              - service_name
              - operation
              - status_code
        traces_storage:
          path: /data/tempo/generator/traces
        storage:
          path: /data/tempo/generator/wal
          remote_write:
            - url: http://127.0.0.1:9090/api/v1/write
              send_exemplars: true

      overrides:
        metrics_generator_processors: [service-graphs, local-blocks, span-metrics]

      compactor:
        compaction_interval: 5m
        retention_enabled: true
        retention_block_max_bytes: 104857600

      limits:
        retention_period: 48h
    '';
  };

  lgtmWatchdog = pkgs.writeTextFile {
    name = "lgtm-watchdog";
    destination = "/bin/lgtm-watchdog";
    executable = true;
    text = ''
      #!${pkgs.zsh}/bin/zsh
      set -euo pipefail

      export PATH="${
        lib.makeBinPath [
          pkgs.coreutils
          pkgs.curl
          pkgs.docker-client
        ]
      }:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/Docker.app/Contents/Resources/bin"

      container_name="lgtm"
      image="grafana/otel-lgtm:latest"
      health_url="http://127.0.0.1:3000/api/health"
      check_interval_seconds=30
      max_consecutive_failures=10

      log() {
        print -r -- "$(date -u '+%Y-%m-%dT%H:%M:%SZ') $*"
      }

      docker_ready() {
        docker system info >/dev/null 2>&1
      }

      start_docker_desktop() {
        if [[ -d /Applications/Docker.app ]]; then
          /usr/bin/open -gj -a Docker >/dev/null 2>&1 || true
        fi
      }

      wait_for_docker() {
        start_docker_desktop

        until docker_ready; do
          log "waiting for Docker Desktop"
          sleep 10
        done
      }

      container_exists() {
        docker container inspect "$container_name" >/dev/null 2>&1
      }

      container_running() {
        [[ "$(docker inspect --format '{{.State.Running}}' "$container_name" 2>/dev/null)" == "true" ]]
      }

      container_has_volume() {
        docker inspect --format '{{range .Mounts}}{{.Name}}{{"\n"}}{{end}}' "$container_name" 2>/dev/null \
          | grep -qx "lgtm-data"
      }

      ensure_container() {
        wait_for_docker

        if container_exists && ! container_has_volume; then
          log "$container_name container predates volume config; recreating"
          docker rm -f "$container_name" >/dev/null 2>&1
          create_container
        elif container_exists; then
          docker update --restart unless-stopped "$container_name" >/dev/null 2>&1 || true

          if ! container_running; then
            log "starting existing $container_name container"
            docker start "$container_name" >/dev/null
          fi
        else
          create_container
        fi
      }

      create_container() {
        log "creating $container_name container"
        docker run -d \
          --name "$container_name" \
          --label "com.mohammadk.nix-darwin-service=lgtm" \
          --restart unless-stopped \
          -p 3000:3000 \
          -p 3200:3200 \
          -p 4317:4317 \
          -p 4318:4318 \
          -v lgtm-data:/data \
          -v ${tempoConfig}/tempo-config.yaml:/otel-lgtm/tempo-config.yaml:ro \
          -e TEMPO_EXTRA_ARGS="--query-frontend.mcp-server.enabled=true" \
          -e PROMETHEUS_EXTRA_ARGS="--storage.tsdb.retention.time=7d" \
          "$image" >/dev/null
      }


      healthcheck_ok() {
        container_running && curl --fail --silent --show-error --max-time 5 "$health_url" >/dev/null
      }

      restart_container() {
        log "restarting $container_name after repeated healthcheck failures"
        docker restart "$container_name" >/dev/null
      }

      consecutive_failures=0
      ensure_container

      while true; do
        if ! docker_ready; then
          log "Docker Desktop is unavailable; waiting for it to recover"
          consecutive_failures=0
          ensure_container
        elif ! container_exists; then
          log "$container_name container is missing; recreating it"
          consecutive_failures=0
          create_container
        elif ! container_running; then
          log "$container_name container is stopped; starting it"
          consecutive_failures=0
          docker start "$container_name" >/dev/null
        elif healthcheck_ok; then
          consecutive_failures=0
        else
          consecutive_failures=$((consecutive_failures + 1))
          log "$container_name healthcheck failed ($consecutive_failures/$max_consecutive_failures)"

          if (( consecutive_failures >= max_consecutive_failures )); then
            restart_container
            consecutive_failures=0
          fi
        fi

        sleep "$check_interval_seconds"
      done
    '';
  };
in
{
  options.local.services.lgtm.enable = lib.mkEnableOption "Grafana OpenTelemetry LGTM Docker service";

  config = lib.mkIf cfg.enable {
    launchd.user.agents.lgtm = {
      script = ''
        #!${pkgs.zsh}/bin/zsh
        exec ${lgtmWatchdog}/bin/lgtm-watchdog
      '';

      serviceConfig = {
        RunAtLoad = true;
        KeepAlive = true;
        ProcessType = "Background";
        ThrottleInterval = 30;
        StandardOutPath = "/tmp/lgtm.stdout.log";
        StandardErrorPath = "/tmp/lgtm.stderr.log";
        EnvironmentVariables = config.environment.variables;
      };
    };
  };
}
