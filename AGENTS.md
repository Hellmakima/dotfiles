# Dotfiles

macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Install

```sh
chmod +x ./install.sh
./install.sh              # stows home/ → $HOME, etc/ → /etc (sudo)
```

`home/` is `stow -t "$HOME" home`, `etc/` is `sudo stow -t /etc etc`.

## Tools configured

| Tool | Notes |
|---|---|
| zsh | starship (minimal prompt), zoxide, zsh-autosuggestions, zsh-syntax-highlighting, fzf |
| nvim | LazyVim, launched via `v` |
| tmux | Prefix is backtick (`` ` ``), not C-b. Alt+hjkl pane nav, M-Left/Right window nav |
| Ghostty | JetBrains Mono 24, 0.7 opacity, custom cursor.glsl shader, undecorated, Super+Alt+hjkl split nav |
| AeroSpace | Tiling WM, zero gaps, Alt+hjkl focus/move, Alt+1-9/A-Z workspaces, `start-at-login = false` |
| yazi | File manager with relative-motions, bookmarks, clipboard, zoom, zip plugins |
| btop | Tokyo Night, cpu+proc only, vim keys, transparent bg |

## Critical aliases & functions

- **`rm` = `trash`** (macOS only). Permanent delete: `\rm`.
- **`ls` and `l` are identical** — both `eza -l --icons --group-directories-first`
- **`g`** → lazygit, **`b`** → btop, **`t`/`ta`** → tmux, **`q`** → lazysql, **`v`** → nvim
- **`d()`** — opens yazi, then cds to its cwd on exit
- **`f()`** — fzf file search with bat preview (ctrl-o opens in nvim)
- **`rr()`** — fzf + ripgrep interactive search
- **`mk()`** — mkdir -p + cd
- **`cmd`** — tldr --list piped to fzf
- **`ca()`** / **`cn()`** — conda activate/create by directory name (+ poetry install)
- **`na()`** — lazy-loads nvm (not auto-loaded)
- **`r`** — re-sources .zshrc

## zsh keybindings

- **Right arrow** → full suggestion accept
- **Cmd+Right** (`^E`) → accept one word from suggestion, or end-of-line
- **Up/Down** → history search by prefix

## Environment quirks

- Conda auto-init is commented out. Call `ca()` manually (also sources `~/Documents/files/.env.sh`).
- NVM only available after running `na()`.
- OpenJDK 17 in PATH from `/opt/homebrew/opt/openjdk@17`.
- Ghostty scrollback set to 200MB.
- `HOMEBREW_NO_ENV_HINTS=1`.
- Git global excludes: `~/.gitignore_global` via `git config --global core.excludesfile ~/.gitignore_global`.
