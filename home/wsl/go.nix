{ ... }:
{
  programs.go = {
    env = {
      GOPRIVATE = ["git-ac.soptim.net"];
      GOPROXY = "https://artifactory.soptim.net/artifactory/api/go/go-v";
    };
  };
}
