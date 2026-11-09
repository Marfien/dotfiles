{
  config,
  pkgs,
  lib,
  ...
}:
let
  # Not packaged in nixpkgs. Provides lsp4mp (server) and its jdtls bundles.
  vscode-microprofile = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    publisher = "redhat";
    name = "vscode-microprofile";
    version = "0.18.0";
    hash = "sha256-TG2OrJpS7uPfjpbInNMEJi2bi6dZl28dTlQ2RGuuT5A=";
  };
  # Not packaged in nixpkgs. Provides the quarkus lsp4mp extension, the quarkus jdtls bundle and qute.
  vscode-quarkus = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    publisher = "redhat";
    name = "vscode-quarkus";
    version = "1.24.0";
    hash = "sha256-6vzeLdgqlGpgGmKoEQj9rHnecmC69tKwRsj6BfUOhzE=";
  };
in
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
            vsc_microprofile = "${vscode-microprofile}/share/vscode/extensions/redhat.vscode-microprofile",
            vsc_quarkus = "${vscode-quarkus}/share/vscode/extensions/redhat.vscode-quarkus",
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
      goimports-reviser
      golangci-lint
      golangci-lint-langserver
      gopls

      # java
      jdt-language-server
      lombok
      vscode-extensions.vscjava.vscode-java-debug
      vscode-extensions.vscjava.vscode-java-test

      # kotlin
      kotlin-language-server
      ktfmt

      # java script
      vtsls
      prettier

      # lua
      lua-language-server
      stylua

      # latex
      tex-fmt
      texlab
      ltex-ls-plus

      # tofu/terraform
      tflint
      tofu-ls

      # nix
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
