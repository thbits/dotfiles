# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:/usr/local/go/bin:
export PATH=$PATH:~/go/bin

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

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
plugins=(git kubectl compleat zsh-autosuggestions thefuck helm docker cp timer zsh-syntax-highlighting autojump zsh-fzf-history-search)

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

#alias c='k config current-context'
alias aws='aws --no-cli-pager'
alias kx='kubectx'
mkd() {
  mkdir -p "$@" && cd "$@"
} 
#unsetopt share_history

. /usr/share/autojump/autojump.sh

#set KUBECONFIG
export KUBECONFIG=~/.kube/config:~/.kube/aws

fpath=(/home/thalo/.oh-my-zsh/custom/completions /home/thalo/.oh-my-zsh/plugins/autojump /home/thalo/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting /home/thalo/.oh-my-zsh/plugins/timer /home/thalo/.oh-my-zsh/plugins/cp /home/thalo/.oh-my-zsh/plugins/docker /home/thalo/.oh-my-zsh/plugins/helm /home/thalo/.oh-my-zsh/plugins/thefuck /home/thalo/.oh-my-zsh/custom/plugins/zsh-autosuggestions /home/thalo/.oh-my-zsh/plugins/compleat /home/thalo/.oh-my-zsh/plugins/kubectl /home/thalo/.oh-my-zsh/plugins/git /home/thalo/.oh-my-zsh/functions /home/thalo/.oh-my-zsh/completions /home/thalo/.oh-my-zsh/cache/completions /home/thalo/.oh-my-zsh/plugins/autojump /home/thalo/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting /home/thalo/.oh-my-zsh/plugins/timer /home/thalo/.oh-my-zsh/plugins/cp /home/thalo/.oh-my-zsh/plugins/docker /home/thalo/.oh-my-zsh/plugins/helm /home/thalo/.oh-my-zsh/plugins/thefuck /home/thalo/.oh-my-zsh/custom/plugins/zsh-autosuggestions /home/thalo/.oh-my-zsh/plugins/compleat /home/thalo/.oh-my-zsh/plugins/kubectl /home/thalo/.oh-my-zsh/plugins/git /home/thalo/.oh-my-zsh/functions /home/thalo/.oh-my-zsh/completions /home/thalo/.oh-my-zsh/cache/completions /home/thalo/.oh-my-zsh/custom/completions /home/thalo/.oh-my-zsh/plugins/autojump /home/thalo/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting /home/thalo/.oh-my-zsh/plugins/timer /home/thalo/.oh-my-zsh/plugins/cp /home/thalo/.oh-my-zsh/plugins/docker /home/thalo/.oh-my-zsh/plugins/helm /home/thalo/.oh-my-zsh/plugins/thefuck /home/thalo/.oh-my-zsh/custom/plugins/zsh-autosuggestions /home/thalo/.oh-my-zsh/plugins/compleat /home/thalo/.oh-my-zsh/plugins/kubectl /home/thalo/.oh-my-zsh/plugins/git /home/thalo/.oh-my-zsh/functions /home/thalo/.oh-my-zsh/completions /home/thalo/.oh-my-zsh/cache/completions /home/thalo/.oh-my-zsh/plugins/autojump /home/thalo/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting /home/thalo/.oh-my-zsh/plugins/timer /home/thalo/.oh-my-zsh/plugins/cp /home/thalo/.oh-my-zsh/plugins/docker /home/thalo/.oh-my-zsh/plugins/helm /home/thalo/.oh-my-zsh/plugins/thefuck /home/thalo/.oh-my-zsh/custom/plugins/zsh-autosuggestions /home/thalo/.oh-my-zsh/plugins/compleat /home/thalo/.oh-my-zsh/plugins/kubectl /home/thalo/.oh-my-zsh/plugins/git /home/thalo/.oh-my-zsh/functions /home/thalo/.oh-my-zsh/completions /home/thalo/.oh-my-zsh/cache/completions /usr/local/share/zsh/site-functions /usr/share/zsh/vendor-functions /usr/share/zsh/vendor-completions /usr/share/zsh/functions/Calendar /usr/share/zsh/functions/Chpwd /usr/share/zsh/functions/Completion /usr/share/zsh/functions/Completion/AIX /usr/share/zsh/functions/Completion/BSD /usr/share/zsh/functions/Completion/Base /usr/share/zsh/functions/Completion/Cygwin /usr/share/zsh/functions/Completion/Darwin /usr/share/zsh/functions/Completion/Debian /usr/share/zsh/functions/Completion/Linux /usr/share/zsh/functions/Completion/Mandriva /usr/share/zsh/functions/Completion/Redhat /usr/share/zsh/functions/Completion/Solaris /usr/share/zsh/functions/Completion/Unix /usr/share/zsh/functions/Completion/X /usr/share/zsh/functions/Completion/Zsh /usr/share/zsh/functions/Completion/openSUSE /usr/share/zsh/functions/Exceptions /usr/share/zsh/functions/MIME /usr/share/zsh/functions/Math /usr/share/zsh/functions/Misc /usr/share/zsh/functions/Newuser /usr/share/zsh/functions/Prompts /usr/share/zsh/functions/TCP /usr/share/zsh/functions/VCS_Info /usr/share/zsh/functions/VCS_Info/Backends /usr/share/zsh/functions/Zftp /usr/share/zsh/functions/Zle)

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'r:|?=**'

#compdef gpt-engineer
_gpt_engineer_completion() {
  eval $(env _TYPER_COMPLETE_ARGS="${words[1,$CURRENT]}" _GPT_ENGINEER_COMPLETE=complete_zsh gpt-engineer)
}
compdef _gpt_engineer_completion gpt-engineer

#set KUBECONFIG
export KUBECONFIG=~/.kube/config:~/.kube/aws

#cloudlens
alias cl='cloudlens'

#aws-shell
alias awsh='docker container run --rm -it -v /home/thalo/.aws:/home/aws/.aws rneder/aws-shell:2023.06.21'

eval $(thefuck --alias)

function tmux_last_session(){

    LAST_TMUX_SESSION=$(tmux list-sessions | awk -F ":" '{print$1}' | tail -n1);
    tmux attach -t $LAST_TMUX_SESSION
}
bindkey -s '^s' 'tmux_last_session ^M'

alias cs='/home/thalo/automate_input.expect'

source ~/.clisso_autocomplete.zsh

eval "$(starship init zsh)"
