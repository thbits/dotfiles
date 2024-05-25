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
