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

Portable [Claude Code](https://code.claude.com) configuration. Only genuinely
machine-independent files live here — no absolute paths, no credentials, no
work-specific content.

```
claudecode/
├── .claude/
│   ├── settings.json      model, theme, hooks, enabled plugins, effort level
│   ├── CLAUDE.md          global instructions
│   ├── hooks/             caffeinate-*.sh — keep the Mac awake while Claude works
│   ├── themes/            catppuccin-mocha
│   └── agents/            generic subagent definitions
└── .config/mcp.json       MCP servers, consumed by the `cc` alias in zsh/.zshrc
```

### Restoring on a new machine

**Always stow this package with `--no-folding`:**

```bash
brew install stow
cd ~/personal/git/dotfiles
stow --no-folding -t ~ claudecode
```

`--no-folding` forces one symlink *per file* instead of symlinking whole
directories. It matters because Claude Code writes ~750&nbsp;MB of runtime state
into `~/.claude` (`projects/`, `plugins/`, `history.jsonl`, `sessions/`). Without
the flag, a fresh machine where `~/.claude` does not yet exist gets
`~/.claude -> dotfiles/claudecode/.claude`, and all of that state lands **inside
this repository**. A deny-by-default whitelist in `.gitignore` blocks it from
ever being committed, but the flag is what stops it happening at all.

If stow refuses because a real file already exists at the target, let stow
resolve it and then restore the repo's version:

```bash
stow --no-folding --adopt -t ~ claudecode   # moves existing files into the repo
git checkout -- claudecode/                  # discard them, keep the repo version
```

### Required environment variables

`.config/mcp.json` uses `${VAR}` expansion, so the private values stay out of
this public repo. Put them in `~/.env`, which `zsh/.zshrc` already sources:

```bash
export OBSIDIAN_VAULT="$HOME/path/to/vault"      # obsidian MCP server
export JIRA_URL="https://your-org.atlassian.net" # mcp-atlassian
export JIRA_USERNAME="you@example.com"           # mcp-atlassian
export JIRA_API_TOKEN="..."                      # mcp-atlassian
export AWS_REGION="us-east-1"                    # optional, defaults to us-east-1
```

Then launch with the alias from `zsh/.zshrc`:

```bash
cc    # claude --mcp-config ${HOME}/.config/mcp.json
```

Skills and plugins restore themselves: the `SessionStart` hook in
`settings.json` runs `npx -y skills update`, and `enabledPlugins` /
`extraKnownMarketplaces` cause plugins to reinstall on first launch.

### Deliberately not tracked

| Path | Why |
|---|---|
| `~/.claude/settings.local.json` | Per-machine permission grants and remote environment ID |
| `~/.claude.json` | `machineID`, `oauthAccount`, `userID`, per-project history |
| `~/.claude/plugins/` | Large cache; rebuilt from `enabledPlugins` |
| `~/.claude/skills/` | Managed by `npx -y skills update` |
| `~/.env` | Secrets and machine-specific paths |

Work-specific agents and skills are intentionally left out of this repo and stay
local to `~/.claude/` on each machine.

### Unstowing

```bash
cd ~/personal/git/dotfiles
stow -D -t ~ claudecode
```
