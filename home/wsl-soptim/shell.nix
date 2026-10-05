{ ... }:
{
  programs.zsh.siteFunctions = {
    clipcopy = ''
      cat "''${1:-/dev/stdin}" | clip.exe;
    '';
    clippaste = "powershell.exe -noprofile -command Get-Clipboard";
    open =
      # bash
      ''
        if [ -f "$1" ] || [ -d "$1" ]; then
          explorer.exe "$(wslpath -wa "$1")"
        else
          explorer.exe "$1"
        fi
      '';
  };
}
