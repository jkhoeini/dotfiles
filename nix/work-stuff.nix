{ ... }:
{
  environment.variables.CC_NO_SESSION_EXPORT = "1";

  homebrew.brews = [
    # User-friendly launcher for Bazel
    "bazelisk"
    # Format bazel BUILD files with a standard convention
    "buildifier"
    # Pure Scala Artifact Fetching
    "coursier"
    # Lightweight DNS forwarder and DHCP server
    {
      name = "dnsmasq";
      restart_service = "changed";
    }
    # Java-based project management
    "maven"
    # Build tool for Scala projects
    "sbt"
    # JVM-based programming language
    "scala"
    # Scala API for Apache Beam and Google Cloud Dataflow
    "spotify/public/scio"
    # Decibel CLI and admin CLI launcher
    "spotify/sptaps/decibel-cli"
    # Kubernetes site plugin
    "spotify/sptaps/kubectl-site"
    # Spotify wrapper for grpcurl
    {
      name = "spotify/sptaps/spgrpcurl";
      args = [ "HEAD" ];
    }
    # Spotify CLI - Internal task runner tool
    "spotify/sptaps/sptcli"
    # Spotify Styx CLI
    "spotify/sptaps/styx-cli"
  ];

  homebrew.casks = [
    # Remote pair programming app
    "tuple"
  ];
}
