#16384,zmodload zsh/zprof
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:/usr/local/go/bin:
export PATH=$PATH:~/go/bin
export PATH=$PATH:/.local/bin
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
 zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(git kubectl compleat zsh-autosuggestions helm docker cp timer zsh-syntax-highlighting zsh-fzf-history-search fzf-tab wsl-notify-zsh)
plugins=(git kubectl compleat zsh-autosuggestions helm docker cp timer zsh-syntax-highlighting zsh-fzf-history-search fzf-tab ohmyzsh-full-autoupdate)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

#unsetopt share_history
HISTDUP=erase
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

autoload -Uz compinit && compinit
source <(kubectl completion zsh)
complete -C $(which aws_completer) aws
# zstyle ':completion:*' matcher-list 'r:|?=**' use-cache on

### Aliases ###
alias aws='aws --no-cli-pager'
alias kx='kubectx'
alias cs='/home/thalo/automate_input.expect'
alias bin='sudo bin'

# Use kubecolor if exists else use kubectl
command -v kubecolor >/dev/null 2>&1 && alias kubectl="kubecolor"
# make completion work with kubecolor
compdef kubecolor=kubectl

# bat as cat
command -v bat >/dev/null 2>&1 && alias cat="bat --style=plain --paging=never"

#clisso loglevel to error
alias clisso='clisso --log-level error'

#eks-node-viewer with current context for multiple region/profiles
alias eksnv='env $(kubectl config view --context $CONTEXT --minify -o json | jq -r ".users[0].user.exec.env[] | select(.name == \"AWS_PROFILE\") | \"AWS_PROFILE=\" + .value" && kubectl config view --context $CONTEXT --minify -o json | jq -r ".users[0].user.exec.args | \"AWS_REGION=\" + .[1]") eks-node-viewer --context $CONTEXT --resources cpu,memory --extra-labels karpenter.sh/nodepool,eks-node-viewer/node-age --node-sort=creation=dsc'

alias cg='function _cg(){ wslview "https://chatgpt.com/?q=$*"; };_cg'

alias vcfg='nvim ~/.config/nvim'

notify-send() { wsl-notify-send.exe --category $WSL_DISTRO_NAME "${@}"; }

#set nvim as default editor
alias vi='nvim'
export EDITOR="nvim"
export KUBE_EDITOR="nvim"

### Useful functions ###

mkd() {
  mkdir -p "$@" && cd "$@"
} 

function tmux_last_session(){
    LAST_TMUX_SESSION=$(tmux list-sessions | awk -F ":" '{print$1}' | tail -n1);
    tmux attach -t $LAST_TMUX_SESSION
    if [[ $? -eq 1 ]] && tmux new-session -s default
}
bindkey -s '^s' 'tmux_last_session ^M'

# Function to open files with Neovim or navigate directories using fzf with bat preview
v() {
  if [[ -n "$1" ]]; then
    # If an argument is provided, open it with Neovim
    nvim "$1"
  else
    # Ensure 'fd' is installed
    if ! command -v fd &> /dev/null; then
      echo "Error: 'fd' is not installed. Please install it to use this function."
      return 1
    fi

    # Ensure 'bat' is installed
    if ! command -v bat &> /dev/null; then
      echo "Error: 'bat' is not installed. Please install it to use the preview feature."
      return 1
    fi

    # Use fd to list both files and directories, then pipe to fzf
    local selection
    selection=$(fd --type f --type d --hidden --follow --exclude .git | fzf \
      --preview 'if [[ -f {} ]]; then bat --theme="Catppuccin Mocha" --style=numbers --color=always {}; else echo "📁 Directory: {}"; fi' \
      --preview-window=right:60% \
      --layout=reverse \
      --height=80% \
      --border \
      --prompt="🔍 Select file or directory: " \
      --ansi) || return
    # Perform actions based on the type of selection
    if [[ -d "$selection" ]]; then
      # If a directory is selected, change into it
      cd "$selection"
    elif [[ -f "$selection" ]]; then
      # If a file is selected, open it with Neovim
      nvim "$selection"
    else
      # If no valid selection is made, provide feedback
      echo "No valid selection made."
      return
    fi
  fi
}

### Override config files path that are not in ~/.config ###
export STU_ROOT_DIR="${HOME}/.config/stu"

#add krew to PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# export KUBECONFIG=~/.kube/config:~/.kube/aws
export KUBECONFIG=~/.kube/config

# Kubeswitch
source <(switcher init zsh)
alias s='switch > /dev/null 2> >(grep -vE "WARN|warning")'
source <(switch completion zsh)
switch . > /dev/null 2>&1 # disable this if you with to start new session without any kube-context

# DISABLE_AUTO_TITLE=true

#start starship.rs
eval "$(starship init zsh)"

eval "$(fzf --zsh)"

[[ "$TERM" == "xterm" ]] && export TERM=xterm-256color

#start zeoxide
eval "$(zoxide init zsh)"

#zprof
