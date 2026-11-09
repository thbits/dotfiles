{ ... }:
{
  # Homebrew itself is installed separately; nix-darwin drives `brew bundle` from these lists.
  homebrew = {
    enable = true;
    onActivation = {
      # Anything Homebrew-installed that is not listed below is uninstalled on switch.
      cleanup = "uninstall";
      autoUpdate = false;
      upgrade = false;
    };

    taps = [
      "deskflow/tap"
      "allcloud-io/tools"
      "aws/tap"
      "aksarav/kubenodeusage"
      "marcus/tap"
      "hamed-elfayome/claude-usage"
      "thbits/tap"
      "hashicorp/tap"
    ];

    brews = [
      # CLI
      "git"
      "kubectl"
      "kubectx"
      "k9s"
      "helm"
      "argocd" # used in --core mode via ~/.kube/argocd-{dev,prod}.config
      "eks-node-viewer"
      "fzf"
      "jless"
      "lazygit"
      "lusingander/tap/stu"
      "yazi"
      "zoxide"
      "neovim"
      "tmux"
      "stow"
      "starship"
      "bat"
      "zsh-syntax-highlighting"
      "awscli"
      "kubecolor"
      "fd"
      "ripgrep"
      "python"
      "btop"
      "npm"
      "hashicorp/tap/terraform" # core `terraform` is frozen at 1.5.7, the last MPL release
      "kind"
      "ec2-instance-selector"
      "kubenodeusage"
      "rajatjindal/tap/modify-secret"
      "uv"
      "yq"
      "gh"
      "node"
      "pgcli"
      "mongosh"
      "jira-cli"
      "ruff"
      "thbits/tap/naviclaude"
      "robusta-dev/homebrew-krr/krr"
      "grafanactl"
      "eza"
      "go"
      "ollama"
      "can1357/tap/omp" # Oh My Pi
      "herdr"

      # GNU userland
      "watch"
      "wget"
      "wdiff"
      "autoconf"
      "coreutils"
      "binutils"
      "diffutils"
      "findutils"
      "gawk"
      "gnu-indent"
      "gnu-sed"
      "gnu-tar"
      "gnu-which"
      "grep"
      "gzip"
      "bash"
      "emacs"
      "gpatch"
      "less"
      "m4"
      "make"
      "bison"
      "flex"
      "libressl"
      "file-formula"
      "openssh"
      "rsync"
      "unzip"
      "netcat"
    ];

    casks = [
      "firefox"
      "keepassxc"
      "syncthing-app"
      "obsidian"
      "brave-browser"
      "ghostty"
      "deskflow"
      "slack"
      "font-caskaydia-mono-nerd-font"
      "scroll-reverser"
      "keepingyouawake"
      "jordanbaird-ice"
      "sublime-text"
      "cursor"
      "input-source-pro"
      "rectangle"
      "dockdoor"
      "aboudjem/tap/sleepless"
      "lunar"
    ];
  };
}
