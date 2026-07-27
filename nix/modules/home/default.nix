{ username, ... }:
{
  home-manager.backupFileExtension = "hm-backup";

  home-manager.users.${username} =
    { lib, pkgs, ... }:
    {
      imports = [ ./zsh.nix ];

      home.username = username;
      home.homeDirectory = /Users/${username};
      home.stateVersion = "24.05";
      programs.home-manager.enable = true;
      home.preferXdgDirectories = true;
      home.language.base = "en_US.UTF-8";
      manual.html.enable = true;

      # Keep mise shims pointed at the active (Homebrew) mise on every rebuild.
      # Without this the shims can dangle (e.g. to a stale nix mise path), which
      # silently breaks the mise shims dir added to environment.systemPath.
      home.activation.miseReshim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        /opt/homebrew/bin/mise reshim || true
      '';

      # Codeburn 0.9.19 assumes the OMP session header is the first JSONL row
      # and scans only top-level sessions. OMP 17 writes title metadata first
      # and stores subagent sessions one directory deeper.
      home.activation.codeburnOmpHotfix = lib.hm.dag.entryAfter [ "miseReshim" ] ''
        codeburn_cli=/opt/homebrew/bin/codeburn
        if [ -e "$codeburn_cli" ]; then
          codeburn_main="$(${pkgs.coreutils}/bin/dirname "$(${pkgs.coreutils}/bin/realpath "$codeburn_cli")")/main.js"
          ${pkgs.python3}/bin/python3 - "$codeburn_main" <<'PY'
        import pathlib
        import re
        import sys

        main_js = pathlib.Path(sys.argv[1])
        try:
            source = main_js.read_text()
        except OSError:
            raise SystemExit(0)
        omp_start = source.find("function getOmpSessionsDir")
        if omp_start < 0:
            raise SystemExit(0)

        old_header = re.compile(
            r"""async function readFirstEntry\(filePath\) \{
          const content = await readSessionFile\(filePath\);
          if \(content === null\) return null;
          const line = content\.split\("\\n"\)\[0\];
          if \(!line\?\.trim\(\)\) return null;
          try \{
            return JSON\.parse\(line\);
          \} catch \{
            return null;
          \}
        \}"""
        )
        new_header = """async function readSessionEntry(filePath) {
          const content = await readSessionFile(filePath);
          if (content === null) return null;
          for (const line of content.split("\\n")) {
            if (!line.trim()) continue;
            try {
              const entry = JSON.parse(line);
              if (entry?.type === "session") return entry;
            } catch {
            }
          }
          return null;
        }"""
        source, header_changes = old_header.subn(new_header, source, count=1)
        if header_changes:
            source = source.replace(
                "readFirstEntry(filePath)", "readSessionEntry(filePath)", 1
            )

        parser_start = source.find("function createParser", omp_start)
        recursion_changes = 0
        if parser_start > omp_start:
            discovery = source[omp_start:parser_start]
            discovery, recursion_changes = re.subn(
                r"files = await (readdir\d+)\(dirPath\);",
                r"files = await \1(dirPath, { recursive: true });",
                discovery,
                count=1,
            )
            source = source[:omp_start] + discovery + source[parser_start:]
        if header_changes or recursion_changes:
            try:
                main_js.write_text(source)
            except OSError:
                raise SystemExit(0)
        PY
        fi
      '';
    };
}
