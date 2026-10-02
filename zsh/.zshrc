# ============================================================================
#  ~/.zshrc  —  portable dev shell (macOS + Linux)
#  Every tool is optional: missing ones are skipped, never an error.
#  Machine-only PATHs and secrets go in ~/.zshrc.local (not in this repo).
# ============================================================================

# ---- Homebrew (macOS / Linuxbrew) — first so brew tools are on PATH --------
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  [ -x "$_brew" ] && { eval "$("$_brew" shellenv)"; break; }
done
unset _brew
typeset -U path fpath   # dedupe PATH/fpath

has() { command -v "$1" >/dev/null 2>&1; }

# Source the first existing file — plugin paths differ between brew and distros
src() { local f; for f in "$@"; do [ -r "$f" ] && { source "$f"; return 0; }; done; return 1; }
_P=("${HOMEBREW_PREFIX:-/opt/homebrew}/share" /usr/share/zsh/plugins /usr/share)

# ---- PATH / env ------------------------------------------------------------
path=(
  $HOME/.local/bin
  $HOME/.bun/bin
  $HOME/.cargo/bin
  $path
)
export BUN_INSTALL="$HOME/.bun"
export EDITOR="${EDITOR:-nvim}"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-R"

# ---- History ---------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE \
       HIST_REDUCE_BLANKS EXTENDED_HISTORY INC_APPEND_HISTORY

# ---- Shell behaviour -------------------------------------------------------
setopt AUTO_CD INTERACTIVE_COMMENTS NO_BEEP

# ---- Completions -----------------------------------------------------------
[ -n "$HOMEBREW_PREFIX" ] && fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
autoload -Uz compinit
compinit -C
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' menu no                               # fzf-tab replaces the menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*:descriptions' format '[%d]'

# fzf-tab — Tab completion through fzf (after compinit, before autosuggestions)
if has fzf && src $^_P/fzf-tab/fzf-tab.zsh $^_P/fzf-tab-git/fzf-tab.zsh; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons=always $realpath'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always --icons=always $realpath'
  zstyle ':fzf-tab:*' switch-group '<' '>'
fi

# ---- Autosuggestions -------------------------------------------------------
if src $^_P/zsh-autosuggestions/zsh-autosuggestions.zsh; then
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  bindkey '^ ' autosuggest-accept    # Ctrl+Space accepts the grey suggestion
fi

# ---- Tool integrations -----------------------------------------------------
has starship && eval "$(starship init zsh)"
has fnm      && eval "$(fnm env --use-on-cd --shell zsh)"
has direnv   && eval "$(direnv hook zsh)"

# fzf — Ctrl-T files, Alt-C cd (Ctrl-R is atuin when installed)
if has fzf; then
  source <(fzf --zsh)
  if has fd; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline'
fi

# ---- Aliases ---------------------------------------------------------------
if has eza; then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -lah --group-directories-first --icons=auto --git'
  alias la='eza -a  --group-directories-first --icons=auto'
  alias lt='eza --tree --level=2 --icons=auto --git-ignore'
  alias tree='eza --tree --icons=auto'
fi

# bat — cat stays untouched for scripts; use `c` (Debian/Ubuntu ship it as batcat)
has batcat && ! has bat && alias bat='batcat'
alias c='bat --paging=never'
export BAT_THEME="ansi"

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias path='echo $PATH | tr ":" "\n"'
alias reload='exec zsh'
alias zshrc='${EDITOR} ~/.zshrc'
alias f='fd'
alias rgi='rg -i'

has btop && alias top='btop'
has dust && alias du='dust'
has duf  && alias df='duf'
has glow && alias md='glow'
has jnv  && alias jqi='jnv'
has xh   && alias http='xh'

# yazi — `y` opens it; quitting cds into the dir you were in
if has yazi; then
  y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
  }
fi

# git
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate -20'
alias gll='git log --oneline --graph --decorate --all'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch --all --prune'
alias gst='git stash'
alias gsp='git stash pop'
alias lg='lazygit'

# bun
alias b='bun'
alias bi='bun install'
alias br='bun run'
alias bx='bunx'

# ---- atuin (history search on Ctrl-R) — near the end ----------------------
has atuin && eval "$(atuin init zsh --disable-up-arrow)"

# zoxide — `cd foo` jumps to the most-frecent match; `cdi` is a fuzzy picker.
# Init after direnv/atuin so its chpwd hook isn't clobbered.
if has zoxide; then
  export _ZO_DOCTOR=0
  eval "$(zoxide init zsh --cmd cd)"
  alias z='cd'
  alias zi='cdi'
fi

# ---- Machine-local overrides: extra PATHs, secrets (never committed) -------
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
path=($path)   # re-apply dedupe after any `export PATH=...`

# ---- Syntax highlighting MUST be sourced last -------------------------------
src $^_P/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
unset _P
