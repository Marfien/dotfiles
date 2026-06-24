{
  lib,
  config,
  ...
}:
let
  cfg = config.windows;
  mountPath = "/mnt/c";
  choco = "${mountPath}/ProgramData/chocolatey/bin/choco.exe";
  powershell = "${mountPath}/WINDOWS/System32/WindowsPowerShell/v1.0//powershell.exe";
  wslpath = "/bin/wslpath";
  awk = "/bin/awk";

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

  packageScript =
    packages: upgradeAll:
    let
      packageList = lib.concatStringsSep " " (map (p: "'${p}'") packages);
      upgradeAllString = lib.boolToString upgradeAll;
    in
    requireAdmin
      # bash
      ''
        INSTALLED=$(${choco} list --no-color 2>/dev/null || true)
        INSTALLED=$(echo "$INSTALLED" \
          | grep -E '^[A-Za-z]' \
          | grep -v '^Chocolatey' \
          | ${awk} '{print tolower($1)}')

        DESIRED=(${packageList})

        if ${upgradeAllString}; then
          echo "Upgrading all packages"
          ${choco} upgrade all; >/dev/null || true
        fi

        for pkg in "''${DESIRED[@]}"; do
          pkg_lower="$(echo "$pkg" | tr '[:upper:]' '[:lower:]')"
          if ! ${upgradeAllString} && echo "$INSTALLED" | grep -qx "$pkg_lower"; then
            echo "Upgrading $pkg"
            ${choco} upgrade "$pkg" -y --no-progress >/dev/null || true
          else
            echo "Installing $pkg"
            ${choco} install "$pkg" -y --no-progress >/dev/null || true
          fi
        done
      '';

in
{
  options.windows = {
    enable = lib.mkEnableOption "Chocolatey package manager and Windows symlink management";

    chocoUpgradeAll = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Upgrade all chocolatey packages, not just the ones managed by chocoPackages.";
      example = true;
    };

    chocoPackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Chocolatey packages to keep installed. Packages absent from this list will be removed.";
      example = [
        "spotify"
        "discord"
        "powertoys"
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
    home.activation.windowsChocolatey = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      lib.optionalString (cfg.chocoPackages != [ ]) ''
        if [ -x "${choco}" ] && ${powershell} -NoProfile -NonInteractive -Command "exit 0" 2>/dev/null; then
          echo "syncing choco packages..."
          ${packageScript cfg.chocoPackages cfg.chocoUpgradeAll}
        else
          echo "choco.exe or WSL interop not available, skipping package sync"
        fi
      ''
    );

    home.activation.windowsSymlinks = lib.hm.dag.entryAfter [ "windowsChocolatey" ] (
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
