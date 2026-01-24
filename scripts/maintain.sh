#!/usr/bin/env bash
# ------------------------------------------------------------
# Arch "Spring‑Clean" Maintenance Script
# (Prod-Ready: Auto-installs dependencies, protects browsers)
# ------------------------------------------------------------

set -u # Exit on undefined variables

# ---------- Helpers (Defined first for dependency checks) -----------------
confirm() {
  read -r -p "${1:-Are you sure? [y/N]} " ans
  [[ "$ans" =~ ^([yY][eE][sS]|[yY])$ ]]
}

announce() { printf "\n\e[1;34m==> %s\e[0m\n" "$1"; }

# ---------- Detect AUR helper ---------------------------------------------
if command -v paru &>/dev/null; then
  AUR=paru
elif command -v yay &>/dev/null; then
  AUR=yay
else
  AUR=pacman
  echo "⚠️  Warning: No AUR helper (paru/yay) found. Using pacman." >&2
fi

# ---------- Self-Healing Dependency Check ---------------------------------
# Ensures 'paccache' exists. If not, offers to install it.
if ! command -v paccache &>/dev/null; then
  echo "⚠️  Missing dependency: 'pacman-contrib' (needed for safe cache cleaning)."
  if confirm "Install 'pacman-contrib' now? [y/N]"; then
    if sudo pacman -S --noconfirm pacman-contrib; then
      echo "✔ Dependency installed."
    else
      echo "❌ Error: Installation failed. Exiting."
      exit 1
    fi
  else
    echo "❌ Cannot proceed without 'paccache'. Exiting."
    exit 1
  fi
fi

# ---------- Config ---------------------------------------------------------
LOG_DIR="$HOME/.local/var/log"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/spring-clean-$(date +%F_%H-%M-%S).log"

PACCACHE_RETAIN=2   # Keep 2 most recent versions (safest balance)
CACHE_DAYS=30       # Prune ~/.cache files untouched for 30 days
JOURNAL_RETAIN="7d" # Keep only 7 days of logs

# Redirect all output to log file AND terminal
exec > >(tee -a "$LOG_FILE") 2>&1

# ---------- CLI Switches ---------------------------------------------------
DO_UPGRADE=false
while [[ $# -gt 0 ]]; do
  case $1 in
    -u|--upgrade) DO_UPGRADE=true ; shift ;;
    -h|--help)
      echo "Usage: $0 [--upgrade]"
      exit 0 ;;
    *) echo "Unknown option: $1" ; exit 2 ;;
  esac
done

announce "Arch Spring‑Clean starting $(date)  —  using $AUR"

# ---------- 1. Optional System Upgrade ------------------------------------
if $DO_UPGRADE; then
  announce "System upgrade ($AUR)"
  $AUR -Syu
  echo "Tip: Run 'sudo pacdiff' manually if you see .pacnew warnings."
fi

# ---------- 2. Pacman Cache Trim ------------------------------------------
announce "Pacman cache trim (keeping latest $PACCACHE_RETAIN)"
current_cache=$(du -sh /var/cache/pacman/pkg 2>/dev/null | cut -f1)
echo "Current cache usage: ${current_cache:-0}"

if confirm "Clean pacman cache now? [y/N]"; then
  # Keep installed versions + 2 previous
  sudo paccache -vrk$PACCACHE_RETAIN
  # Remove all versions of uninstalled packages
  sudo paccache -ruk0
fi

# ---------- 3. Orphaned Packages ------------------------------------------
announce "Checking for orphaned packages"
# Safely grab orphans; if none, array is empty
if mapfile -t ORPHANS < <($AUR -Qtdq) && [ ${#ORPHANS[@]} -gt 0 ]; then
  printf "Found %d orphan(s):\n%s\n" "${#ORPHANS[@]}" "${ORPHANS[*]}"
  if confirm "Remove these orphans? [y/N]"; then
    sudo pacman -Rns "${ORPHANS[@]}"
  fi
else
  echo "No orphans detected."
fi

# ---------- 4. $HOME/.cache Prune ----------------------------------------
announce "Pruning ~/.cache (unused > $CACHE_DAYS days)"
echo "Note: Excluding Browsers (Firefox/Helium/Chrome) & Spotify to preserve speed."
cache_before=$(du -sh ~/.cache 2>/dev/null | cut -f1)
echo "Before: ${cache_before:-0}"

if confirm "Clean ~/.cache now? [y/N]"; then
  # EXCLUSION EXPLANATION:
  # - mozilla: Protects Firefox & Firefox Developer Edition
  # - helium/Helium: Protects Helium Browser
  # - chromium/google-chrome: Protects standard Chromium browsers
  # - spotify: Protects media cache
  # - Trash: Prevents accidental data loss
  
  find ~/.cache -depth -type f -mtime +$CACHE_DAYS \
    -not -path "*/mozilla/*" \
    -not -path "*/chromium/*" \
    -not -path "*/google-chrome/*" \
    -not -path "*/helium/*" \
    -not -path "*/Helium/*" \
    -not -path "*/spotify/*" \
    -not -path "*/Trash/*" \
    -print -delete
  
  # Remove empty directories (using same exclusions)
  find ~/.cache -depth -type d -empty \
    -not -path "*/mozilla/*" \
    -not -path "*/chromium/*" \
    -not -path "*/google-chrome/*" \
    -not -path "*/helium/*" \
    -not -path "*/Helium/*" \
    -not -path "*/spotify/*" \
    -not -path "*/Trash/*" \
    -print -delete
fi
cache_after=$(du -sh ~/.cache 2>/dev/null | cut -f1)
echo "After: ${cache_after:-0}"

# ---------- 5. Journald Maintenance ---------------------------------------
announce "Vacuuming journald logs (Retain: $JOURNAL_RETAIN)"
if confirm "Rotate & vacuum journald now? [y/N]"; then
  sudo journalctl --rotate
  sudo journalctl --vacuum-time=$JOURNAL_RETAIN
fi

# ---------- 6. Health Check -----------------------------------------------
announce "Scanning for failed systemd services"
failed_units=$(systemctl --failed --no-legend --plain)

if [[ -z "$failed_units" ]]; then
  echo "✔ System is healthy (No failed units)."
else
  echo "⚠️  Failed units detected:"
  systemctl --failed --no-pager
fi

announce "Spring‑Clean finished in ${SECONDS}s — log saved to $LOG_FILE"
