# AGENTS.md — Sufiyan's phone (`~/` on Termux/Android)

You are working on Sufiyan's phone. This is **Termux on Android (aarch64)**.
`$HOME` is `/data/data/com.termux/files/home`, packages live under `$PREFIX=/data/data/com.termux/files/usr`.
Package manager is `pkg`/`apt` (Termux repos, glibc repo enabled). There is **no brew, no sudo, no conda**.
The user likes minimal packages. Ask before any install you wish to make (pkg, uv etc). Anytime u make a change that is not a config file in stow (setting up gh-cli or gd) update `~/seed`. It's a manual for fresh termux install.
All the dot files live in `~/dots`. It has dotfiles for other machines as well, do not touch those, it is used with stow and git.
Obsidian vault located at `/storage/emulated/0/Documents/files`.
All simple python scripts located in `~/dots/moto/bin`

## This phone's setup

- user likes transparent theme or tokyo-night, catppuccin
- nvim is **LazyVim** at `~/.config/nvim` (mirrors the copy in `dotfiles/apple/home/.config/nvim/`).
- Android storage is reachable via `~/storage/{shared,downloads,dcim,pictures,music,movies}` symlinks or directly.
- `termux-api` package is installed (`termux-*` / `am` tools work); extra-keys/colors configured in `~/.termux/`.

## Tooling available
`uv` 0.11, rust + clang (aarch64-android target), nvim 0.12, tmux 3.7, yazi, eza, fd, fzf, ripgrep, lazygit, zoxide, vivid, tealdeer, jq, imagemagick, ffmpeg, stow, gh-cli, rclone (google drive in yazi), opencode. `opencode` config: `~/.config/opencode/opencode.jsonc` (minimal).

## General
- Git identity: Sufiyan Attar / sufiyanhattar@gmail.com; remotes are `git@github.com:hellmakima/*`.
- Commands must run on aarch64-android — avoid macOS/Linux-distro-specific invocations.
- **No `/tmp` on Android/Termux.** Use `$PREFIX/tmp` (i.e. `/data/data/com.termux/files/usr/tmp`) for temp files; opencode's temp sandbox is `/data/data/com.termux/files/usr/tmp/opencode`. `$HOME/.bashrc` sets `tmp="$PREFIX/tmp"`.

structure of `~/dots/moto/`

moto
├── .stow-local-ignore
├── a
├── bin
│   ├── blast
│   ├── note
│   └── notev
└── home
    ├── .bashrc
    ├── .config
    │   ├── lazygit
    │   │   └── config.yml
    │   ├── mpv
    │   ├── nvim
    │   │   ├── .gitignore
    │   │   ├── .neoconf.json
    │   │   ├── init.lua
    │   │   ├── lazy-lock.json
    │   │   ├── lazyvim.json
    │   │   ├── LICENSE
    │   │   ├── lua
    │   │   ├── README.md
    │   │   └── stylua.toml
    │   ├── opencode
    │   │   ├── .gitignore
    │   │   ├── node_modules
    │   │   ├── opencode.jsonc
    │   │   ├── package-lock.json
    │   │   ├── package.json
    │   │   └── tui.json
    │   ├── termai
    │   │   └── config.json
    │   └── yazi
    │       ├── init.lua
    │       ├── keymap.toml
    │       ├── package.toml
    │       └── plugins
    ├── .hushlogin
    ├── .termux
    │   ├── colors.properties
    │   ├── font.ttf
    │   ├── font.ttf.bak
    │   └── termux.properties
    ├── .tmux
    │   ├── .tmux.conf
    │   └── plugins
    │       ├── tmux-continuum
    │       ├── tmux-floax
    │       ├── tmux-resurrect
    │       ├── tmux-sensible
    │       ├── tpm
    │       └── vim-tmux-navigator
    ├── .tmux.conf
    ├── .w3m
    │   ├── config
    │   ├── cookie
    │   ├── history
    │   └── keymap
    ├── AGENTS.md
    └── seed

Behavior
Analyse my question to see if it is a casual question or you need to dive deep. You can answer in one sentence for a casual question.
Don't announce what you're about to say (eg, here's an overview....) Just say the thing.
Don't agree with me unless it's actually correct. Challenge my assumptions and offer better alternatives. Dont be delusional
Respond in minimal number of words possible unless told to explain.
We strictly follow Islam.
Speak formally a little like Gen Z.
Don't use non-ASCII characters in code.
Tell it like it is; don't sugar-coat responses.
Use short declarative sentences.
Use web search appropriately for things that might already be out there.
