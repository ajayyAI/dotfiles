# dotfiles

[![CI](https://github.com/ajayyai/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/ajayyai/dotfiles/actions/workflows/ci.yml)

A fast, portable zsh + Ghostty setup for macOS and Linux. Every tool is
optional: missing ones are skipped, so the shell never errors on a fresh box.

## Install

```sh
git clone https://github.com/ajayyai/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh --packages   # tools + symlinks  (omit --packages for symlinks only)
```

- Symlinks configs into place; anything already there is moved to `*.bak-<timestamp>`.
- Safe to re-run. Preview with `./install.sh --dry-run`.
- `--packages` uses the [`Brewfile`](Brewfile) on macOS, [`packages/arch.txt`](packages/arch.txt) on Arch.

Update later with `git -C ~/dotfiles pull` — symlinks pick changes up immediately.

## Layout

| Path | Linked to | |
| --- | --- | --- |
| `zsh/.zshrc` | `~/.zshrc` | Shell: completions, plugins, aliases |
| `git/.gitconfig` | `~/.gitconfig` | Git defaults, delta, aliases |
| `starship/starship.toml` | `~/.config/starship.toml` | Prompt |
| `ghostty/config` | `~/.config/ghostty/config` | Terminal |
| `fish/conf.d/` | — (manual) | Fish setup for Arch / ML4W |
| `scripts/maintain.sh` | — | Arch cleanup script |
| `old-configs/` | — | Archived (wezterm, old zsh) |

## Local, never committed

| File | For |
| --- | --- |
| `~/.zshrc.local` | Machine-only PATHs, API keys (`chmod 600`) |
| `~/.gitconfig.local` | Git name/email, credential helper — created by `install.sh` |

Don't run `gh auth setup-git`: it writes into the symlinked `.gitconfig`.
`install.sh` adds the gh credential helper to `~/.gitconfig.local` instead.

## What you get

| Key / command | Does |
| --- | --- |
| <kbd>Tab</kbd> | Fuzzy completion with previews (fzf-tab); <kbd>&lt;</kbd> <kbd>&gt;</kbd> switch groups |
| <kbd>Ctrl-R</kbd> | Search history (atuin) |
| <kbd>Ctrl-T</kbd> / <kbd>Alt-C</kbd> | Fuzzy-pick a file / cd into a dir (fzf) |
| <kbd>Ctrl-Space</kbd> | Accept autosuggestion |
| `cd foo` | Jump to best match (zoxide); `cdi` to pick |
| `y` | File manager (yazi), cds where you quit |
| `ll` `lt` `c` | eza long list / tree, bat |
| `lg` `gs` `gl` | lazygit, status, log graph |
| `du` `df` `top` `md` `http` `jqi` | dust, duf, btop, glow, xh, jnv |

Ghostty: <kbd>Ctrl-\`</kbd> drop-down terminal (macOS), <kbd>Cmd-D</kbd> /
<kbd>Cmd-Shift-D</kbd> split, <kbd>Cmd-Shift-,</kbd> reload config.
Font: JetBrains Mono Nerd Font · Theme: Catppuccin (follows system light/dark).
