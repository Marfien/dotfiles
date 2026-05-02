{ ... }:
{
  programs.zsh.siteFunctions = {
    clipcopy = ''
      cat "''${1:-/dev/stdin}" | pbcopy;
    '';
    clippaste = "pbpaste";
  };
}
