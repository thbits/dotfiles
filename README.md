# Backup Files Using GNU Stow

This repository provides a generic method to backup your files using GNU Stow. Stow is a symlink farm manager which can be used to manage your dotfiles and backups efficiently.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Usage](#usage)
  - [Step 1: Organize Your Files](#step-1-organize-your-files)
  - [Step 2: Create a Stow Directory](#step-2-create-a-stow-directory)
  - [Step 3: Stow Your Files](#step-3-stow-your-files)
  - [Step 4: Unstow Your Files](#step-4-unstow-your-files)
  - [Step 5: Restore Your Files](#step-5-restore-your-files)
- [Example](#example)
- [Claude Code (`claudecode` package)](#claude-code-claudecode-package)
- [naviclaude (`naviclaude/`)](#naviclaude-naviclaude)
- [KeePassXC (`keepassxc/`)](#keepassxc-keepassxc)
- [macOS settings and packages (`nix/`)](#macos-settings-and-packages-nix)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

Before using Stow, ensure you have the following:

- GNU Stow installed on your system. You can install it using your package manager. For example:
  - On Debian-based systems: `sudo apt-get install stow`
  - On Red Hat-based systems: `sudo yum install stow`
  - On macOS: `brew install stow`

## Usage

### Step 1: Organize Your Files

Organize the files you want to backup into directories. Each directory should represent a category or a specific backup set. For example:
```
backup/
├── documents
│   ├── file1.txt
│   └── file2.txt
├── photos
│   ├── photo1.jpg
│   └── photo2.jpg
└── configs
    ├── .bashrc
    └── .vimrc
```

### Step 2: Create a Stow Directory

Create a directory where you will store your stow packages. This is typically done in your home directory:
```bash
mkdir -p ~/stow-backups
```

### Step 3: Stow Your Files

Navigate to your stow directory and use Stow to create symlinks for your backup files. For example:
```bash
cd ~/stow-backups
stow -t ~ documents
stow -t ~ photos
stow -t ~ configs
```

This will create symlinks in your home directory pointing to the actual files in your backup directory.

### Step 4: Unstow Your Files

If you need to remove the symlinks created by Stow, use the `--delete` option:
```bash
cd ~/stow-backups
stow -D documents
stow -D photos
stow -D configs
```

### Step 5: Restore Your Files

To restore your files, simply navigate to the cloned repository and re-run the stow commands, specifying the target directory with `-t`. This will recreate the symlinks in your home directory or the target directory you specified:
```bash
cd ~/your-repo
stow -t ~ documents
stow -t ~ photos
stow -t ~ configs
```

## Example

Assume you have the following files to backup:

1. `.bashrc`
2. `notes.txt`
3. `photo.jpg`

You can organize them as follows:
```
backup/
├── configs
│   └── .bashrc
├── documents
│   └── notes.txt
└── photos
    └── photo.jpg
```

Then, you can stow them:
```bash
cd ~/stow-backups
stow -t ~ configs
stow -t ~ documents
stow -t ~ photos
```

To unstow (remove) them:
```bash
cd ~/stow-backups
stow -D configs
stow -D documents
stow -D photos
```

To restore (re-stow) them:
```bash
cd ~/your-repo
stow -t ~ configs
stow -t ~ documents
stow -t ~ photos
```

## Claude Code (`claudecode` package)

Portable [Claude Code](https://code.claude.com) config — `settings.json`,
`CLAUDE.md`, the caffeinate hooks, the catppuccin theme, generic agents, and
`.config/mcp.json` (used by the `cc` alias in `zsh/.zshrc`).

```bash
stow -t ~ claudecode
```

`mcp.json` uses `${VAR}` expansion so private values stay out of this repo. The
referenced variables need to be exported in `~/.env`, which `zsh/.zshrc` already
sources.

Skills and plugins reinstall themselves on first launch, via the `SessionStart`
hook and `enabledPlugins` in `settings.json`.

## naviclaude (`naviclaude/`)

Only `config.yaml`. Create the directory first so stow links the file, not the
whole directory (naviclaude writes its state files next to it):

```bash
mkdir -p ~/.config/naviclaude && stow -t ~ naviclaude
```

## KeePassXC (`keepassxc/`)

App settings only: auto-type, browser integration, tray, password generator. Copy it,
don't stow it. KeePassXC writes a generated KeeShare private key into this file, and
through a symlink that key would end up in the repo.

```bash
mkdir -p ~/Library/Application\ Support/keepassxc
cp keepassxc/keepassxc.ini ~/Library/Application\ Support/keepassxc/   # with KeePassXC closed
```

## macOS settings and packages (`nix/`)

[nix-darwin](https://github.com/nix-darwin/nix-darwin) manages everything that is
the Mac rather than a dotfile: Dock, Finder, keyboard and input sources, trackpad,
window tiling and menu bar settings,
Touch ID for `sudo` (works inside tmux too), and every Homebrew tap, formula and cask.
Dotfiles are still stowed as above; nix-darwin doesn't touch them.

- `nix/darwin/system.nix`: macOS defaults and Touch ID
- `nix/darwin/homebrew.nix`: Homebrew packages (replaces the old Brewfile)

**Removing a package from `homebrew.nix` uninstalls it on the next switch**, and so
does anything installed with a plain `brew install` that isn't listed. Add it to the
file first, then switch.

### New Mac

```bash
xcode-select --install
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
git clone https://github.com/thbits/dotfiles.git ~/personal/git/dotfiles

# First run bootstraps darwin-rebuild itself
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/personal/git/dotfiles/nix#tom-mbp
```

If the first switch stops on "unexpected files in /etc", rename the files it lists
(e.g. `sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin`) and run it again.

With Cloudflare WARP on, its TLS inspection can break downloads from `cache.nixos.org`.
Point Nix at the WARP root CA (`ssl-cert-file = /path/to/ca.pem` in `/etc/nix/nix.custom.conf`).

### Day to day

```bash
sudo darwin-rebuild switch --flake ~/personal/git/dotfiles/nix#tom-mbp   # apply
cd ~/personal/git/dotfiles/nix && nix flake update                       # bump nixpkgs / nix-darwin pins
```
