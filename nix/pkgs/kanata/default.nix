{
  stdenvNoCC,
  lib,
  fetchurl,
}:

let
  version = "1.6.1";
in
stdenvNoCC.mkDerivation {
  pname = "kanata";
  inherit version;

  dontUnpack = true;

  src = fetchurl {
    url = "https://github.com/jtroo/kanata/releases/download/v${version}/kanata_macos_arm64";
    sha256 = "6gYIItqnDAKjTCsuqF81qmvaYpYLJ5ipetKo7lXvR/Y=";
  };

  installPhase = ''
    runHook preInstall
    install -D -m 0755 "$src" "$out/bin/kanata"
    runHook postInstall
  '';

  meta = with lib; {
    description = "A keyboard remapping tool";
    homepage = "https://github.com/jtroo/kanata";
    license = licenses.mit;
    platforms = platforms.darwin;
    mainProgram = "kanata";
  };
}
