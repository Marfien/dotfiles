{
  config,
  pkgs,
  ...
}: {
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
    extraPackages = with pkgs; [
      tree-sitter
      texliveFull

      clang-tools

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
      # java-debug-adapter
      # java-test

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
