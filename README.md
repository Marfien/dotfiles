# Dotfiles

Nix flake-based system and home configuration for macOS (nix-darwin) and NixOS (WSL).

## Configurations

| Name         | Type       | System         | User   | Description                  |
|--------------|------------|----------------|--------|------------------------------|
| `mac`        | nix-darwin | aarch64-darwin | marvin | macOS workstation            |
| `wsl-soptim` | NixOS/WSL  | x86_64-linux   | maha   | WSL environment for work     |

## Repository Structure

```
.
├── flake.nix              # Flake entrypoint with all system definitions
├── modules/
│   ├── hm-system.nix      # Shared home-manager integration module
│   └── windows/           # `windows.*` options: Chocolatey, symlinks, file copies
├── darwin/
│   ├── default.nix        # Shared darwin configuration
│   └── mac/               # mac-specific: Homebrew, Dock, fonts
├── nixos/
│   ├── default.nix        # Shared NixOS configuration
│   └── wsl-soptim/        # WSL config: shell, docker, corp certs
└── home/
    ├── default/           # Shared home-manager config (all hosts)
    │   ├── shell.nix      # Zsh, fzf, starship, helpers (cdp, vipe)
    │   ├── cli.nix        # CLI tools (jq, bat, fd, ripgrep, just, ...)
    │   ├── git/           # Git config, aliases, git-smart-clone
    │   ├── tmux.nix       # Tmux
    │   ├── neovim/        # Neovim configuration
    │   ├── term.nix       # WezTerm
    │   ├── sdk.nix        # JDK, .NET, Maven, Gradle, Go
    │   └── devops.nix     # kubectl, fluxcd, opentofu, docker-client
    ├── mac/               # macOS-specific: Zen browser, Neovim theme sync, shell extras
    └── wsl-soptim/        # WSL-specific: SSH, Go, Claude Code, shell extras
        ├── term.nix       # Syncs WezTerm config to the Windows host
        ├── neovim.nix     # Neovim light/dark theme follows Windows
        └── windows/       # Chocolatey packages, AutoHotkey, Windows Terminal, .wslconfig
```

## Highlights

- **Light/dark mode sync** – WezTerm and Neovim follow the OS appearance on both macOS and Windows.
- **Windows management from WSL** – the `windows` home-manager module (`modules/windows`) installs Chocolatey
  packages and creates symlinks/copies on the Windows side during activation. Requires WSL interop and,
  for packages and symlinks, an elevated shell (not inside tmux).
- **Git aliases** – e.g. `git cc` generates five conventional-commit message candidates for the staged
  changes with Claude Code and lets you pick one via `fzf`; `git ppush` pulls with rebase, then pushes.

## Flake Inputs

- **nixpkgs** (nixos-unstable)
- **home-manager** (master)
- **nix-darwin**
- **nix-homebrew**
- **nixos-wsl**
- **zen-browser**

The Nix implementation used is [Lix](https://lix.systems).

## Initial Install

### Prerequisites

Install Nix with flakes support. The [Determinate Systems installer](https://zero-to-nix.com/start/install) is recommended as it enables flakes by default.

### nix-darwin (macOS)

```sh
git clone https://github.com/Marfien/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
nix run nix-darwin -- switch --flake .#mac
```

After the initial build, use `darwin-rebuild` directly:

```sh
darwin-rebuild switch --flake ~/.dotfiles#mac
```

### NixOS (WSL)

1. Install [NixOS-WSL](https://github.com/nix-community/NixOS-WSL) following their instructions.
2. Clone and apply the configuration:

```sh
git clone https://github.com/Marfien/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
sudo nixos-rebuild switch --flake .#wsl-soptim
```

### Home-Manager (standalone)

If you only want the home-manager configuration without a full system rebuild:

```sh
git clone https://github.com/Marfien/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
nix run home-manager -- switch --flake .#<username>
```

> Note: Standalone home-manager configurations are not currently exported by this flake. Use the full system commands above.

## How to Upgrade

Update all flake inputs to their latest versions and rebuild:

```sh
cd ~/.dotfiles
nix flake update
```

Then apply the updated configuration:

```sh
# macOS
darwin-rebuild switch --flake ~/.dotfiles#mac

# NixOS / WSL
sudo nixos-rebuild switch --flake ~/.dotfiles#wsl-soptim
```

To update a single input:

```sh
nix flake update home-manager
```
