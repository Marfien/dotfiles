{ ... }:
{
  programs.git = {
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
    settings.alias.cc =
      # bash
      ''
        !
        if [ -z "$(git diff --staged --name-only)" ]; then
          echo "No files staged" >&2
          exit 1
        fi
        f() {
          for i in $(seq 5); do
            claude --settings '{"disableAllHooks": true}' -p 'Write a git commit message for the staged changes. The message MUST follow the conventional commit format. Keep the message in one line under 50 characters. DO NOT add a description. Respond ONLY with the raw commit message - WITHOUT any other tokens.' &
          done
          wait
        }
        git commit -m "$(f | fzf)"
      '';
  };
}
