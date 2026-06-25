{
  config,
  pkgs,
  lib,
  ...
}:
{
  home = {
    file = {
      "${config.xdg.configHome}/nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink ./nvim;
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
    withRuby = false;
    sideloadInitLua = true;
    initLua =
      with pkgs;
      lib.mkBefore
        # lua
        ''
          vim.g.nix = {
            lombok = "${lombok}",
            vsc_java_debug = "${vscode-extensions.vscjava.vscode-java-debug}",
            vsc_java_test = "${vscode-extensions.vscjava.vscode-java-test}",
          }

          -- bootstrap lazy.nvim
          require("config.options")
          require("config.keymaps")
          require("config.autocmds")

          require("config.lazy")
          require("features").setup()

          vim.defer_fn(function()
            require("util.lsp").setup()
            require("config.usercmds")
          end, 100)
        '';
    plugins = [ pkgs.vimPlugins.lazy-nvim ];
    extraPackages = with pkgs; [
      cargo
      tree-sitter
      gnumake
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
  };
}
