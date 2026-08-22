# AGENTS.md — Sufiyan's phone (`~/` on Termux/Android)

You are working on Sufiyan's phone. This is **Termux on Android (aarch64)**, NOT macOS.
`$HOME` is `/data/data/com.termux/files/home`, packages live under `$PREFIX=/data/data/com.termux/files/usr`.
Package manager is `pkg`/`apt` (Termux repos, glibc repo enabled). There is **no brew, no sudo, no conda** here.
Anything the dotfiles describe for "apple" (zsh, starship, Homebrew, OpenJDK, Ghostty, AeroSpace) targets the macOS machine — do not assume those exist here.

## Projects

### `~/dotfiles` — git repo `hellmakima/dotfiles`
Two machines, one repo. **Configs live inside subdirs, never at the repo root.**
- `apple/` — macOS: `apple/install.sh` does `stow -t "$HOME" home` then `sudo stow -t /etc etc`. Run from `~/dotfiles`.
- `moto/` — **this phone**: configs to `stow -t $HOME` directly (currently only `moto/.tmux.conf`). New/untracked; the apple→moto restructure is in-progress (renames staged).
- The existing `~/dotfiles/AGENTS.md` describes the old `home/`+`etc/` layout and is stale — trust `apple/`+`moto/` over it.
- `home/`, `etc/`, `install.sh` at repo root no longer exist (moved under `apple/`).

### `~/tasks` — git repo `hellmakima/tasks`, Python task toolkit
- `uv`-managed. Venv at `~/.venv` is **Python 3.14.6** (system python) despite `.python-version` saying 3.10 — that file is stale, don't rely on it.
- Tests: `uv run pytest test.py` (verbose: `uv run pytest -svv test.py`).
- FastAPI app: `app.py` (APScheduler background job, `POST /sync`). TUI/CLI: `cli/cli.py` (typer + questionary). Models: `models.py`, recurrence logic: `utils.py`.
- SQLite DB `database.db` is gitignored; `import_tasks.py` imports from `Tasks.json`.
- Upstream plan: `plan.md`, `todo.md` (ntfy phone notifs, optional Rust/ratatui rewrite).

### `~/files` → `/storage/emulated/0/Documents/files` — git repo `hellmakima/files`
Obsidian notes vault + git repo on **Android shared storage** (files owned by `root`, hence `git config --global safe.directory /storage/emulated/0/Documents/files` is set).
Contains `ENVs.md`, `.env.sh` (sourced by the macOS `ca()` function), other scratch markdown.
Android/FUSE storage is slow — avoid heavy git operations on it.

### Scratch — NOT projects, ignore
`~/a` (stray copy of tasks/utils.py), `~/typescript` (stray `script` session log), `~/tmp/hdfc.md` (empty scratch file).

## This phone's setup

- Shell: bash. Aliases in `~/.bashrc`: `v`=nvim, `d`=yazi, `l`=eza, `op`=opencode, `g`=lazygit, `t`=tmux (attach-or-new), `c`=clear, `x`=cd ~ + clear, `xx`=exit, `r`=re-source.
- **tmux prefix is backtick (`` ` ``), not C-b** (same on apple). `moto/.tmux.conf` is the canonical phone config; tpm + catppuccin plugins live in `~/.tmux/plugins/` (not in git).
- nvim is **LazyVim** at `~/.config/nvim` (mirrors the copy in `dotfiles/apple/home/.config/nvim/`).
- Android storage is reachable via `~/storage/{shared,downloads,dcim,pictures,music,movies}` symlinks.
- `termux-api` package is installed (`termux-*` / `am` tools work); extra-keys/colors configured in `~/.termux/`.

## Tooling available
`uv` 0.11, node 24/npm, rust + clang (aarch64-android target), nvim 0.12, tmux 3.7, yazi, eza, fd, fzf, ripgrep, lazygit, zoxide, vivid, tealdeer, jq, imagemagick, ffmpeg, stow, opencode 1.18.3 (installed via pkg, local). `opencode` config: `~/.config/opencode/opencode.jsonc` (minimal) + npm plugin `@opencode-ai/plugin`.

## General
- Git identity: Sufiyan Attar / sufiyanhattar@gmail.com; remotes are `git@github.com:hellmakima/*`.
- Commands must run on aarch64-android — avoid macOS/Linux-distro-specific invocations.
