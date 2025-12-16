{ ... }:
{
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
    # FlyteCtl is a command line tool to interact with a Flyte cluster.
    "flyteorg/tap/flytectl"
    # Swift handover for remote mobs using git. mob is a CLI tool written in GO. It keeps your master branch clean and creates WIP commits on mob-session branch.
    "remotemobprogramming/brew/mob"
    # Scala API for Apache Beam and Google Cloud Dataflow
    "spotify/public/scio"
    "spotify/sptaps/decibel-cli"
    # Hades CLI utility
    "spotify/sptaps/hades-cli"
    "spotify/sptaps/kubectl-site"
    {
      name = "spotify/sptaps/spgrpcurl";
      args = [ "HEAD" ];
    }
    # Spotify CLI - Internal task runner tool
    "spotify/sptaps/sptcli"
    "spotify/sptaps/styx-cli"
    # A language server for Starlark, the configuration language used by Bazel and Buck2.
    "withered-magic/brew/starpls"
  ];
}
