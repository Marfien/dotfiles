{ ... }:
let
  mkIncludeMail =
    {
      urlPattern,
      email,
    }:
    {
      condition = "hasconfig:remote.*.url:${urlPattern}";
      contents = {
        user = {
          email = email;
        };
      };
    };
in
{
  home = {
    file."bin/git-smart-clone" = {
      source = ./git-smart-clone.sh;
      executable = true;
    };
  };
  programs.git = {
    enable = true;
    lfs.enable = true;
    includes = [
      (mkIncludeMail {
        urlPattern = "https://*.soptim.net/*/**";
        email = "marvin.haase@soptim.de";
      })
      (mkIncludeMail {
        urlPattern = "git@*.soptim.net:*/**";
        email = "marvin.haase@soptim.de";
      })
    ];
    settings = {
      user = {
        name = "Marvin Haase";
        email = "contact@marfien.dev";
      };
      alias = {
        ec = "commit --allow-empty -m";
        cm = "commit -m";
        sconf = "config --system";
        gconf = "config --global";
        lconf = "config --local";
        again = "commit -C HEAD --amend --no-edit";
        rollback = "reset --hard";
        push-skip = "push -o ci.skip";
        pfush = "push --force-with-lease";
        s = "status";
        p = "push";
        sdiff = "diff --staged";
      };
      init = {
        defaultBranch = "main";
      };
      core = {
        autocrlf = "input";
      };
      merge = {
        tool = "nvimdiff";
      };
      mergetool = {
        prompt = false;
        keepBackup = false;
        "nvimdiff" = {
          layout = "LOCAL,MERGED,REMOTE";
        };
      };
      pull = {
        rebase = true;
      };
      push = {
        autoSetupRemove = true;
      };
    };
  };
}
