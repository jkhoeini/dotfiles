{ lib
, stdenv
, fetchurl
, gnumake
, zstd
, makeWrapper
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jj-fzf";
  version = "0.34.0";

  src = fetchurl {
    url = "https://github.com/tim-janik/jj-fzf/releases/download/v${finalAttrs.version}/jj-fzf-${finalAttrs.version}.tar.zst";
    sha256 = "sha256-xY7MTcUUfsFNJjzPa1TF2pcipTxXZlSQLYiDoviR0Ww=";
  };

  nativeBuildInputs = [
    gnumake
    zstd
    makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Derive major.minor for the libexec layout used upstream.
    # version is "0.34.0" -> PKGVERSION "0.34"
    PKGVERSION="$(echo "${finalAttrs.version}" | awk -F. '{print $1 "." $2}')"
    LIBEXEC_DIR="$out/libexec/jj-fzf-$PKGVERSION"

    mkdir -p "$LIBEXEC_DIR" "$LIBEXEC_DIR/lib" "$out/bin"

    # Install project scripts and docs (mirrors upstream install list).
    install -m 0644 README.md NEWS.md "$LIBEXEC_DIR/" 2>/dev/null || true
    install -m 0755 jj-fzf "$LIBEXEC_DIR/"

    # Top-level helper scripts (*.sh)
    for f in ./*.sh; do
      [ -e "$f" ] || continue
      install -m 0755 "$f" "$LIBEXEC_DIR/"
    done

    # Library helpers
    if [ -d lib ]; then
      for f in lib/*.awk lib/*.py lib/*.sh; do
        [ -e "$f" ] || continue
        # .py should be readable/executable depending on shebang; keep executable to be safe.
        install -m 0755 "$f" "$LIBEXEC_DIR/lib/"
      done
    fi

    # If a manpage is already shipped in the tarball, install it.
    # (We do not generate it with pandoc during the build.)
    if [ -f doc/jj-fzf.1 ]; then
      mkdir -p "$out/share/man/man1"
      install -m 0644 doc/jj-fzf.1 "$out/share/man/man1/jj-fzf.1"
    fi

    # Provide a stable entrypoint in $out/bin.
    # Use a wrapper so runtime can find its companion files via JJ_FZF_HOME.
    makeWrapper "$LIBEXEC_DIR/jj-fzf" "$out/bin/jj-fzf" \
      --set-default JJ_FZF_HOME "$LIBEXEC_DIR"

    runHook postInstall
  '';

  # If upstream doesn’t compress manpages, Nix is fine with that.
  # If upstream installs manpages somewhere nonstandard, you can fix it here,
  # but with `PREFIX=$out` the conventional location is $out/share/man/man1.

  meta = with lib; {
    description = "Jujutsu (jj) fzf UI";
    homepage = "https://github.com/tim-janik/jj-fzf";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "jj-fzf";
  };
})
