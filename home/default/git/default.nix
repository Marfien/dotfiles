{ ... }:
{
  home.file."bin/git-smart-clone" = {
    source = ./git-smart-clone.sh;
    executable = true;
  };
  programs.git = {
    enable = true;
    lfs.enable = true;
    includes = [
      {
        condition = "gitdir:~/workspace/soptim/**";
        contents = {
          user = {
            email = "marvin.haase@soptim.de";
          };
        };
      }
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
        # force push
        pfush = "push --force-with-lease";
        # pull push
        ppush = ''!f() { git pull --rebase && git push "$@"; }; f'';
        s = "status";
        p = "push";
        sdiff = "diff --staged";
        cc =
          # bash
          ''
            !
            if [ -z "$(git diff --staged --name-only)" ]; then
              echo "No files staged" >&2
              exit 1
            fi
            f() {
              for i in $(seq 5); do
                claude -p 'Write a git commit message for the staged changes. The message MUST follow the conventional commit format. Keep the message in one line under 50 characters. DO NOT add a description. Respond ONLY with the raw commit message - WITHOUT any other tokens.' &
              done
              wait
            }
            git commit -m "$(f | fzf)"
          '';
      };

      init.defaultBranch = "main";
      core.autocrlf = "input";

      merge.tool = "nvimdiff";
      mergetool = {
        prompt = false;
        keepBackup = false;
        "nvimdiff" = {
          layout = "LOCAL,MERGED,REMOTE";
        };
      };

      pull.rebase = true;
      push.autoSetupRemote = true;
      safe.directory = [ "/etc/nixos/" ];
    };
  };
}
