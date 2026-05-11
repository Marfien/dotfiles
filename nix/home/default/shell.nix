{ lib, pkgs, ... }:
{
  home = {
    shell = {
      enableZshIntegration = true;
    };
  };
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;
      history = {
        append = true;
        expireDuplicatesFirst = true;
        ignoreAllDups = true;
        ignoreSpace = true;
        saveNoDups = true;
      };
      historySubstringSearch.enable = true;
      initContent = lib.mkAfter ''
        PATH="$PATH:$HOME/bin:$HOME/.dotnet/tools"

        if [ -n "$WSL_DISTRO_NAME" ]; then
          PATH="$PATH:/mnt/c/WINDOWS:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/"
          alias powershell="powershell.exe"
        fi
      '';
      sessionVariables = {
        LS_COLORS = "di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43";
      };
      shellAliases = {
        zshconfig = "vim ~/.zshrc";
        g = "git";

        rm = "rm -i";
        ls = "ls --color=always";
        lsa = "ls -lAh";
        l = "ls -lAh";
        ll = "ls -lh";
        la = "ls -lAh";
        mkdir = "mkdir -p";

        c = "clipcopy";
        p = "clippaste";

        k = "kubectl";
      };
      siteFunctions = {
        open = ''
          if (( # != 1)); then
            echo "usage: open <file>" >&2
            return 1
          fi

          local openExec=$(command -vp open)
          if (( ? == 0 )); then
            eval "$openExec $1"
          elif [ -n "$WSL_DISTRO_NAME" ]; then
            (
              cd "$(dirname $1)" || return 1
              explorer.exe "$(basename $1)"
            )
          else
            echo 'Could not find native proxy executable.'
            return 1;
          fi
        '';
        dckr = ''
          local image="''${@:$#}"
          local -a args
          if (( $# > 1 )); then
            args=("''${@:1:(( $# - 1 ))}")
          else
            args=();
          fi

          docker run --rm -it -v "$(pwd):/mnt" -w /mnt --entrypoint '/bin/sh' "''${args[@]}" "$image" -c '(command -v zsh && exec zsh) || (command -v bash && exec bash) || (command -v ash && exec ash) || sh'
        '';
      };
      syntaxHighlighting.enable = true;
      localVariables = {
        # This prevents zsh-vi-mode from being lazy loaded and overriding fzf keymaps
        ZVM_INIT_MODE = "sourcing";
      };
      plugins = [
        {
          name = "omz completions";
          file = "lib/completion.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "ohmyzsh";
            repo = "ohmyzsh";
            rev = "master";
            sha256 = "sha256-m81bwO/bw5+grt9q8cGLzSJzk1ajJSCAkLpB6DjzuDo=";
          };
        }
        {
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];
    };
    fzf = {
      enable = true;
      changeDirWidgetCommand = "fd --type d";
      defaultCommand = "fd --type f";
    };
    starship = {
      enable = true;
      settings = {
        format = lib.concatStrings [
          "$fill"
          "$line_break"
          "$directory"
          "$git_branch"
          "$character"
        ];
        add_newline = false;
        continuation_prompt = "    ";
        status = {
          disabled = false;
          format = "[$status]($style)";
        };
        fill = {
          symbol = " ";
          style = "white underline";
        };
        git_branch = {
          format = "[$symbol$branch(:$remote_branch)]($style) ";
          style = "green";
        };
        character = {
          success_symbol = "[❯](bright-black)";
          error_symbol = "[❯](bright-red)";
        };
      };
    };
  };
}
