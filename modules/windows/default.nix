{
  lib,
  config,
  ...
}:
let
  cfg = config.windows;
  mountPath = "/mnt/c";
  powershell = "${mountPath}/WINDOWS/System32/WindowsPowerShell/v1.0//powershell.exe";
  wslpath = "/bin/wslpath";

  requireAdmin =
    script:
    # bash
    ''
      IS_ADMIN=$(${powershell} -noprofile -noprofile '(New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)')
      # Removed the windows line ending (idk why it takes two chars)
      IS_ADMIN=$(echo "$IS_ADMIN" | head -c-2)
      if [ "$IS_ADMIN" == "True" ]; then
        ${script}
      elif [ -n "''${TMUX:-}" ]; then
        echo "Administrator priviledges are not available from within tmux. Please exit before running." 2>&1
      else
        echo "Missing Administrator priviledges." 2>&1
      fi
    '';

  symlinkScript =
    links:
    requireAdmin (
      lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          target: source:
          # bash
          ''
            # The target needs to be removed. Otherwise, wslpath runs into an Input-/Output-Error
            rm -rf "${target}"
            WIN_TARGET="$(${wslpath} -w "${target}")"
            WIN_SOURCE="$(${wslpath} -w "${source}")"

            echo "Setting up link for: ${source} -> ${target}"

            # Remove stale symlink or file at target location via PowerShell
            ${powershell} -NoProfile -NonInteractive -Command "
              \$target = '$WIN_TARGET'
              if (Test-Path -LiteralPath \$target) {
                Remove-Item -Force -Recurse -LiteralPath \$target
              }
              \$parent = Split-Path \$target
              if (-not (Test-Path \$parent)) {
                New-Item -ItemType Directory -Force -Path \$parent | Out-Null
              }
              New-Item -ItemType SymbolicLink -Path \$target -Target '$WIN_SOURCE' | Out-Null
            " >/dev/null || true
          '') links
      )
    );

  copyScript =
    copies:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        target: source:
        # bash
        ''
          echo "Copying: ${source} -> ${target}"
          mkdir -p "$(dirname "${target}")"
          cp -f "${source}" "${target}"
        '') copies
    );

  # winget is an App Execution Alias, so it is invoked through PowerShell instead
  # of relying on the Windows PATH being available inside the activation script.
  winget = args: ''${powershell} -NoProfile -NonInteractive -Command "winget ${args}; exit \$LASTEXITCODE"'';
  wingetFlags = "--silent --accept-package-agreements --accept-source-agreements --disable-interactivity";

  # Not wrapped in requireAdmin: winget elevates per installer via UAC, and some
  # installers (e.g. Spotify) refuse to run from an elevated session.
  packageScript =
    packages: upgradeAll:
    lib.optionalString upgradeAll ''
      echo "Upgrading all packages"
      ${winget "upgrade --all ${wingetFlags}"} >/dev/null || true
    ''
    + lib.concatMapStrings (
      pkg:
      # bash
      ''
        # `winget install` upgrades the package if it is already installed
        echo "Installing/upgrading ${pkg}"
        ${winget "install --id '${pkg}' --exact --source winget ${wingetFlags}"} >/dev/null || true
      '') packages;

in
{
  options.windows = {
    enable = lib.mkEnableOption "winget package and Windows symlink management";

    wingetUpgradeAll = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Upgrade all winget packages, not just the ones managed by wingetPackages.";
      example = true;
    };

    wingetPackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "winget package IDs (from the `winget` source) to keep installed and up to date.";
      example = [
        "Spotify.Spotify"
        "Discord.Discord"
        "Microsoft.PowerToys"
      ];
    };

    symlinks = lib.mkOption {
      type = lib.types.attrsOf lib.types.pathInStore;
      default = { };
      description = ''
        Windows symlinks to create, as { target = source } pairs.
        Paths in /nix/store are translated to \\wsl.localhost\<distro>\... UNC paths.
        Paths under /mnt/c are translated to C:\... style paths.
        Symlinks are recreated on every activation to track nix-store updates.
      '';
      example = {
        "/mnt/c/Users//AppData/Roaming/alacritty/alacritty.toml" = ./xxx-alacritty.toml;
      };
    };

    copy = lib.mkOption {
      type = lib.types.attrsOf lib.types.pathInStore;
      default = { };
      description = ''
        Windows files to copy, as { target = source } pairs.
        Unlike symlinks, the file content is copied to the target location.
        Parent directories are created automatically.
      '';
      example = {
        "/mnt/c/Users//AppData/Local/some-app/config.json" = ./config.json;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.activation.windowsWinget = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      lib.optionalString (cfg.wingetPackages != [ ]) ''
        if ${winget "--version"} >/dev/null 2>&1; then
          echo "syncing winget packages..."
          ${packageScript cfg.wingetPackages cfg.wingetUpgradeAll}
        else
          echo "winget or WSL interop not available, skipping package sync"
        fi
      ''
    );

    home.activation.windowsSymlinks = lib.hm.dag.entryAfter [ "windowsWinget" ] (
      lib.optionalString (cfg.symlinks != { }) ''
        if ${powershell} -NoProfile -NonInteractive -Command "exit 0" 2>/dev/null; then
          echo "updating Windows symlinks..."
          ${symlinkScript cfg.symlinks}
        else
          echo "WSL interop not available, skipping symlinks"
        fi
      ''
    );

    home.activation.windowsCopy = lib.hm.dag.entryAfter [ "windowsSymlinks" ] (
      lib.optionalString (cfg.copy != { }) ''
        echo "copying Windows files..."
        ${copyScript cfg.copy}
      ''
    );
  };
}
