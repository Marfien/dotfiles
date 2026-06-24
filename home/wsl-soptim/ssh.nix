{ ... }:
  let
    sshDir = "~/.ssh";
  in 
{
  programs.ssh = {
    enable = true;
    settings = {
      "git-ac.soptim.net" = {
        IdentityFile = "${sshDir}/git-ac";
      };
      "github.com" = {
        IdentityFile = "${sshDir}/github";
      };
    };
  };
}
