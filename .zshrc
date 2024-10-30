# ====================
# Oh My Zsh Installation
# ====================
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
    git
    sudo
    aws
    archlinux
    kubectl
    kubectx
    docker
    command-not-found
    history-substring-search
    colored-man-pages
    tmux
    web-search
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-completions
    fzf
)


# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# ====================
# History Configuration
# ====================
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ====================
# Completion Settings
# ====================
# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
autoload -Uz compinit && compinit  # Ensure Zsh autocompletion is initialized

# ====================
# Keybindings
# ====================
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

bindkey '^[[1;5D' backward-word  # Ctrl + Left Arrow for backward word
bindkey '^[[1;5C' forward-word   # Ctrl + Right Arrow for forward word

# History substring search plugin keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


# ====================
# Aliases
# ====================
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias ..='cd ..'
alias ll='ls -alF'
alias gs='git status'
alias gp='git pull'
alias gc='git commit -m'
alias df='df -h'


# ====================
# Path Configuration
# ====================
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# nvim
export PATH="$PATH:/opt/nvim-linux64/bin"

# ====================
# Tool Configurations
# ====================
# Shell integrations
eval "$(zoxide init --cmd cd zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# yazi file manager
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}


# ====================
# Custom Welcome Message
# ====================
# Display ASCII banner with 'figlet' and color it using 'lolcat'
figlet -f ANSI-shadow Aju | lolcat
