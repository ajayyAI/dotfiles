# -----------------------------------------------------
# INIT
# -----------------------------------------------------

set -U fish_greeting ""

# -----------------------------------------------------
# Exports
# -----------------------------------------------------
export EDITOR=nvim

set -U fish_user_paths /usr/lib/ccache/bin/
set -U fish_user_paths $fish_user_paths $HOME/.cargo/bin/
set -U fish_user_paths $fish_user_paths $HOME/.local/bin/


# ============================================
# Web Dev Tools Initialization
# ============================================

if command -q zoxide
    zoxide init fish | source
end

# Starship - Beautiful shell prompt
if command -q starship
    starship init fish | source
end

# FNM - Fast Node Manager
if command -q fnm
    fnm env --use-on-cd | source
end

if test -d ~/.deno
    set -gx DENO_INSTALL "$HOME/.deno"
    set -gx PATH $DENO_INSTALL/bin $PATH
end

# Bun Runtime
if test -d ~/.bun
    set -gx BUN_INSTALL "$HOME/.bun"
    set -gx PATH $BUN_INSTALL/bin $PATH
end

# Locale settings for UTF-8
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
