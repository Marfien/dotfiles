{
  config,
  pkgs,
  ...
}:
{
  home = {
    file = {
      "${config.xdg.configHome}/nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink ../../../nvim;
        recursive = true;
        force = true;
      };
    };
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    initLua = with pkgs; ''
      vim.g.nix = {
        jdtls_path = "${jdt-language-server}",
        lombok_path = "${lombok}",

        vsc_java_debug = "${vscode-extensions.vscjava.vscode-java-debug}",
        vsc_java_test = "${vscode-extensions.vscjava.vscode-java-test}",
      }
    '';
    extraPackages = with pkgs; [
      tree-sitter
      texliveFull

      clang-tools
      node

      # shell
      bash-language-server
      shellcheck
      shfmt

      # go
      delve
      gofumpt
      gosimports
      golangci-lint
      golangci-lint-langserver
      gopls

      # java
      jdt-language-server
      lombok
      vscode-extensions.vscjava.vscode-java-debug
      vscode-extensions.vscjava.vscode-java-test

      # python
      python313Packages.jedi-language-server
      python313Packages.debugpy
      black

      # kotlin
      kotlin-language-server
      ktfmt

      # java script
      vtsls
      prettier

      # lua
      lua-language-server
      stylua

      # csharp
      roslyn-ls
      csharpier
      netcoredbg

      # latex
      tex-fmt
      texlab
      ltex-ls-plus

      # tofu/terraform
      tflint
      tofu-ls

      # nix
      nixpkgs-fmt
      nixfmt
      nixd

      # config
      lemminx
      vscode-json-languageserver
      yaml-language-server
      gitlab-ci-ls
    ];
    sideloadInitLua = true;
  };
}
