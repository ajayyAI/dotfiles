# dotfiles

Personal configs. Two setups live here:

| Dir | What | Where it goes |
| --- | --- | --- |
| `zsh/.zshrc` | Portable zsh (macOS + Linux), every tool optional | `~/.zshrc` |
| `ghostty/config` | Ghostty terminal | `~/.config/ghostty/config` |
| `starship/starship.toml` | Prompt | `~/.config/starship.toml` |
| `git/.gitconfig` | Git + delta + aliases | `~/.gitconfig` |
| `fish/conf.d/` | Fish shell (Arch / ML4W) | `~/.config/fish/conf.d/` |
| `scripts/maintain.sh` | Arch cleanup script | anywhere |

## Install (zsh setup)

```sh
git clone https://github.com/ajayyai/dotfiles ~/dotfiles
ln -sf ~/dotfiles/zsh/.zshrc              ~/.zshrc
ln -sf ~/dotfiles/git/.gitconfig          ~/.gitconfig
mkdir -p ~/.config/ghostty
ln -sf ~/dotfiles/ghostty/config          ~/.config/ghostty/config
ln -sf ~/dotfiles/starship/starship.toml  ~/.config/starship.toml
gh auth setup-git
```

Machine-only PATHs and secrets (API keys) go in `~/.zshrc.local` — sourced
automatically, never committed. `chmod 600 ~/.zshrc.local`.

## Tools

Core (the shell is built around these):

```sh
# macOS
brew install --cask ghostty font-jetbrains-mono-nerd-font
brew install zsh-autosuggestions zsh-syntax-highlighting fzf-tab \
  starship fzf fd ripgrep eza bat zoxide atuin git-delta lazygit gh fnm direnv

# Arch
sudo pacman -S ghostty ttf-jetbrains-mono-nerd zsh-autosuggestions \
  zsh-syntax-highlighting starship fzf fd ripgrep eza bat zoxide atuin \
  git-delta lazygit github-cli fnm direnv
paru -S fzf-tab-git
```

Extras (aliased only when installed): `btop`→`top`, `dust`→`du`, `duf`→`df`,
`glow`→`md`, `jnv`→`jqi`, `xh`→`http`, `yazi`→`y`.

## Keys

- **Tab** — fuzzy completion (fzf-tab), `<` `>` switch groups
- **Ctrl-R** history (atuin) · **Ctrl-T** files · **Alt-C** cd (fzf)
- **Ctrl-Space** accept autosuggestion
- Ghostty: **Ctrl-`** quick terminal (macOS) · **Cmd-D / Cmd-Shift-D** split
