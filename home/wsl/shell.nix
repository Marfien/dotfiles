{ ... }:
{
  programs.zsh.siteFunctions = {
    clipcopy = ''
      cat "''${1:-/dev/stdin}" | clip.exe;
    '';
    clippaste = "powershell.exe -noprofile -command Get-Clipboard";
  };
}
