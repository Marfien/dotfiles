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

  symlinkScript =
    links:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        target: source:
        # bash
        ''
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
    );

  packageScript =
    packages:
    let
      packageList = lib.concatStringsSep " " (map (p: "'${p}'") packages);
    in
    # bash
    ''
      INSTALLED=$(${choco} list --no-color 2>/dev/null || true)
      INSTALLED=$(echo "$INSTALLED" \
        | grep -E '^[A-Za-z]' \
        | grep -v '^Chocolatey' \
        | ${awk} '{print tolower($1)}')

      DESIRED=(${packageList})

      IS_ADMIN=$(${powershell} -noprofile -noprofile '(New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)')
      if [ "$(echo "$IS_ADMIN" | cut -c1-1)" != "T" ]; then
        echo "Cannot install packages without administrator permissions."
        echo "|$IS_ADMIN|"
        exit
      fi

      for pkg in "''${DESIRED[@]}"; do
        pkg_lower="$(echo "$pkg" | tr '[:upper:]' '[:lower:]')"
        if echo "$INSTALLED" | grep -qx "$pkg_lower"; then
          ${choco} upgrade "$pkg" -y --no-progress 2>/dev/null || true
        else
          ${choco} install "$pkg" -y --no-progress 2>/dev/null || true
        fi
      done
    '';

in
{
  options.windows = {
    enable = lib.mkEnableOption "Chocolatey package manager and Windows symlink management";

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
        Paths in /nix/store are translated to \\wsl.localhost\NixOS\... UNC paths.
        Paths under /mnt/c are translated to C:\... style paths.
        Symlinks are recreated on every activation to track nix-store updates.
      '';
      example = {
        "/mnt/c/Users/User/AppData/Roaming/alacritty/alacritty.toml" = "/nix/store/xxx-alacritty.toml";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.activation.windowsChocolatey = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      lib.optionalString (cfg.chocoPackages != [ ]) ''
        if [ -x "${choco}" ]; then
          echo "syncing choco packages..."
          ${packageScript cfg.chocoPackages}
        else
          echo "choco.exe not found, skipping package sync"
        fi
      ''
    );

    home.activation.windowsSymlinks = lib.hm.dag.entryAfter [ "windowsChocolatey" ] (
      lib.optionalString (cfg.symlinks != { }) ''
        if [ -x "${powershell}" ]; then
          echo "updating Windows symlinks..."
          ${symlinkScript cfg.symlinks}
        else
          echo "powershell.exe not found, skipping symlinks"
        fi
      ''
    );
  };
}
