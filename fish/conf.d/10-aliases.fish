# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------

# -----------------------------------------------------
# General
# -----------------------------------------------------
alias c='clear'
alias nf='fastfetch'
alias pf='fastfetch'
alias ff='fastfetch'
alias ls='eza -a --icons=always'
alias ll='eza -al --icons=always'
alias lt='eza -a --tree --level=1 --icons=always'
alias shutdown='systemctl poweroff'
alias v='$EDITOR'
alias vim='$EDITOR'
alias ts='~/.config/ml4w/scripts/arch/snapshot.sh'
alias wifi='nmtui'
alias cleanup='~/.config/ml4w/scripts/arch/cleanup.sh'

# -----------------------------------------------------
# ML4W Apps
# -----------------------------------------------------
alias ml4w='flatpak run com.ml4w.welcome'
alias ml4w-settings='flatpak run com.ml4w.settings'
alias ml4w-calendar='flatpak run com.ml4w.calendar'
alias ml4w-hyprland='flatpak run com.ml4w.hyprlandsettings'
alias ml4w-sidebar='flatpak run com.ml4w.sidebar'
alias ml4w-options='ml4w-hyprland-setup -m options'
alias ml4w-diagnosis='~/.config/hypr/scripts/diagnosis.sh'
alias ml4w-hyprland-diagnosis='~/.config/hypr/scripts/diagnosis.sh'
alias ml4w-qtile-diagnosis='~/.config/ml4w/qtile/scripts/diagnosis.sh'
alias ml4w-update='~/.config/ml4w/scripts/installupdates.sh'

# -----------------------------------------------------
# Window Managers
# -----------------------------------------------------

alias Qtile='startx'
# Hyprland with Hyprland

# -----------------------------------------------------
# Git
# -----------------------------------------------------
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gst="git stash"
alias gsp="git stash; git pull"
alias gfo="git fetch origin"
alias gcheck="git checkout"
alias gcredential="git config credential.helper store"

# -----------------------------------------------------
# Scripts
# -----------------------------------------------------
alias ascii='~/.config/ml4w/scripts/figlet.sh'

# -----------------------------------------------------
# System
# -----------------------------------------------------
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# -----------------------------------------------------
# Qtile
# -----------------------------------------------------
alias res1='xrandr --output DisplayPort-0 --mode 2560x1440 --rate 120'
alias res2='xrandr --output DisplayPort-0 --mode 1920x1080 --rate 120'
alias setkb='setxkbmap de;echo "Keyboard set back to de."'


# ============================================
# Web Development Aliases
# ============================================

# Git TUI tools
if command -q lazygit
    alias lg="lazygit"
end

if command -q lazydocker
    alias ld="lazydocker"
end

# Better grep (ripgrep)
if command -q rg
    alias grep="rg"
    alias rgi="rg -i"  # Case-insensitive
end

# File manager
if command -q yazi
    alias fm="yazi"
    alias y="yazi"
end

# Better find (fd) 
if command -q fd
    alias fdf="fd"  # ML4W might have 'ff' for fastfetch
end

# Docker management (manual start/stop saves RAM)
alias docker-start="sudo systemctl start docker"
alias docker-stop="sudo systemctl stop docker"
alias docker-status="systemctl status docker"
alias docker-clean="docker system prune -af"
alias docker-logs="docker logs -f"

# PostgreSQL management
alias pg-start="sudo systemctl start postgresql"
alias pg-stop="sudo systemctl stop postgresql"
alias pg-status="systemctl status postgresql"

# Node.js with FNM
if command -q fnm
    alias node-list="fnm list"
    alias node-install="fnm install"
    alias node-use="fnm use"
    alias node-latest="fnm install --lts && fnm default lts-latest"
end

# Bun shortcuts
if command -q bun
    alias b="bun"
    alias br="bun run"
    alias bi="bun install"
    alias ba="bun add"
    alias bd="bun add -d"
    alias bt="bun test"
    alias bx="bunx"  # Like npx
end

# NPM shortcuts
alias ni="npm install"
alias nr="npm run"
alias ns="npm start"
alias nt="npm test"

# Better cat 
if command -q bat
    alias cat="bat"
    alias catn="bat --style=plain"
    alias bathelp="bat --plain --language=help"
end

# Quick config edits
alias fishconfig="$EDITOR ~/.config/fish/conf.d/00_init.fish"
alias fishalias="$EDITOR ~/.config/fish/conf.d/10-aliases.fish"
alias kittyconfig="$EDITOR ~/.config/kitty/kitty.conf"
alias hyprconfig="$EDITOR ~/.config/hypr/hyprland.conf"

# Reload Fish config
alias reload="source ~/.config/fish/config.fish"

# Extra directory shortcuts (ML4W has some, adding more)
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Project shortcuts
alias code="cd ~/Code"

# Quick Git shortcuts (additions)
alias glog="git log --oneline --graph --decorate --all"
alias gdiff="git diff"
alias gundo="git reset --soft HEAD~1"
alias gwip="git add -A && git commit -m 'WIP'"

# Development shortcuts
alias serve="python -m http.server 8000"
alias ports="sudo netstat -tulpn | grep LISTEN"
