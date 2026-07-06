# Dotfiles

macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Install

```sh
chmod +x ./install.sh
./install.sh              # stows home/ → $HOME, etc/ → /etc (sudo)
```

`home/` is `stow -t "$HOME" home`, `etc/` is `sudo stow -t /etc etc`.

## Adding configs

**All configs live under `home/` in the repo** (e.g. `home/.config/tmux/tmux.conf`, `home/.aerospace.toml`), never directly at `~`. To add a new config:

1. Place the file at the correct path inside `home/`
2. `stow -t "$HOME" home` from the repo root
3. If the target exists already, back it up first (`mv ~/.path ~/.path.bak`) so stow can create the symlink

After editing configs in the repo, re-run `install.sh` (or `stow -t "$HOME" home`) to refresh symlinks.

## Tools configured

| Tool | Notes |
|---|---|
| zsh | starship (minimal prompt), zoxide, zsh-autosuggestions, zsh-syntax-highlighting, fzf |
| nvim | LazyVim, launched via `v` |
| tmux | Prefix is backtick (`` ` ``), not C-b. `` ` ``+h/j/k/l pane nav, `` ` ``+Enter vertical split, `` ` ``+s horizontal split, `` ` ``+Space cycle layout, `` ` ``+S-q kill session, M-Left/Right window nav |
| Ghostty | JetBrains Mono 24, 0.7 opacity, custom cursor.glsl shader, undecorated, Super+Alt+hjkl split nav |
| AeroSpace | Tiling WM, zero gaps, Alt+1-9/A-Z workspaces, `start-at-login = false` |
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
