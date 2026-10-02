#!/usr/bin/env bash
# ------------------------------------------------------------
# Symlink these dotfiles into $HOME. Safe to re-run.
#   ./install.sh              link configs (existing files are backed up)
#   ./install.sh --packages   also install tools (Homebrew / pacman)
#   ./install.sh --dry-run    show what would happen, change nothing
# ------------------------------------------------------------
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
DRY_RUN=false
PACKAGES=false

# source (repo-relative) -> destination
LINKS=(
  "zsh/.zshrc:$HOME/.zshrc"
  "git/.gitconfig:$HOME/.gitconfig"
  "starship/starship.toml:$HOME/.config/starship.toml"
  "ghostty/config:$HOME/.config/ghostty/config"
)

announce() { printf '\n\033[1;34m==> %s\033[0m\n' "$1"; }
run() {
  if $DRY_RUN; then printf '  [dry-run] %s\n' "$*"; else "$@"; fi
}

usage() { sed -n '3,6p' "$0" | sed 's/^# \{0,1\}//'; }

while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--packages) PACKAGES=true ;;
    -n|--dry-run)  DRY_RUN=true ;;
    -h|--help)     usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

# ---------- Packages -------------------------------------------------------
install_packages() {
  case "$(uname -s)" in
    Darwin)
      if ! command -v brew >/dev/null; then
        echo "Homebrew not found — install it first: https://brew.sh" >&2
        exit 1
      fi
      announce "Installing packages (Homebrew)"
      run brew bundle --file="$DOTFILES/Brewfile"
      ;;
    Linux)
      if ! command -v pacman >/dev/null; then
        echo "Only Arch (pacman) is automated. See packages/arch.txt for the list." >&2
        return
      fi
      announce "Installing packages (pacman)"
      local pkgs
      pkgs=$(grep -Ev '^\s*(#|$)' "$DOTFILES/packages/arch.txt" | tr '\n' ' ')
      # shellcheck disable=SC2086  # word-splitting the package list is intended
      run sudo pacman -S --needed --noconfirm $pkgs
      if command -v paru >/dev/null; then
        run paru -S --needed --noconfirm fzf-tab-git
      else
        echo "  note: fzf-tab is AUR-only (fzf-tab-git) — install with paru/yay"
      fi
      ;;
  esac
}

# ---------- Git identity ---------------------------------------------------
# The shared .gitconfig includes ~/.gitconfig.local for name/email, so the
# repo never carries anyone's identity. Seed it from the current config once.
seed_git_identity() {
  local local_cfg="$HOME/.gitconfig.local"
  [[ -e "$local_cfg" ]] && return
  local name email
  name=$(git config --global user.name 2>/dev/null || true)
  email=$(git config --global user.email 2>/dev/null || true)
  announce "Creating $local_cfg"
  if $DRY_RUN; then
    printf '  [dry-run] write user.name=%s user.email=%s\n' "${name:-<unset>}" "${email:-<unset>}"
    return
  fi
  touch "$local_cfg"
  [[ -n "$name"  ]] && git config -f "$local_cfg" user.name  "$name"
  [[ -n "$email" ]] && git config -f "$local_cfg" user.email "$email"
  if [[ -z "$name" || -z "$email" ]]; then
    echo "  set your identity: git config -f ~/.gitconfig.local user.name/user.email"
  fi
  # GitHub auth via gh, here rather than in the tracked .gitconfig
  if command -v gh >/dev/null; then
    git config -f "$local_cfg" credential.https://github.com.helper '!gh auth git-credential'
    git config -f "$local_cfg" credential.https://gist.github.com.helper '!gh auth git-credential'
  fi
}

# ---------- Symlinks -------------------------------------------------------
link() {
  local src="$DOTFILES/$1" dest="$2"
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    printf '  ok      %s\n' "$dest"
    return
  fi
  run mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" || -L "$dest" ]]; then
    printf '  backup  %s -> %s.bak-%s\n' "$dest" "$dest" "$STAMP"
    run mv "$dest" "$dest.bak-$STAMP"
  fi
  printf '  link    %s\n' "$dest"
  run ln -s "$src" "$dest"
}

$PACKAGES && install_packages

seed_git_identity   # before linking — reads identity from the current ~/.gitconfig

announce "Linking dotfiles from $DOTFILES"
for pair in "${LINKS[@]}"; do
  link "${pair%%:*}" "${pair#*:}"
done

if [[ ! -e "$HOME/.zshrc.local" ]]; then
  echo
  echo "Tip: machine-only PATHs and secrets go in ~/.zshrc.local (chmod 600)."
fi
announce "Done. Open a new shell (or run: exec zsh)"
