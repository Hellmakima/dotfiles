alias v="nvim"
alias w="w3m"

export PATH="$HOME/.cargo/bin:$PATH"

export LS_COLORS="$(vivid generate molokai)"

alias b="top -o PID,%CPU,%MEM,CMDLINE"
alias l="eza -l --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first"
alias lt="eza --tree --icons --git-ignore"
alias op="opencode"
alias od="objdump"
alias g="lazygit"
alias ip="ifconfig 2> /dev/null | grep inet | awk '{print \$2}'"
alias t="tmux attach &> /dev/null || tmux"
alias c="clear"
alias cd..="cd .."
alias cd-="cd -"
alias ff="fastfetch --logo /storage/emulated/0/Documents/wall/mak.jpg"
alias uu="pkg update && pkg upgrade"
alias x="cd ~ && clear"
alias xx="exit"
alias r="source ~/.bashrc"
alias rc="v ~/.bashrc"

tmp="$PREFIX/tmp"

[ -x "$HOME/dots/moto/bin/gdserve" ] && "$HOME/dots/moto/bin/gdserve" status >/dev/null || "$HOME/dots/moto/bin/gdserve" start >/dev/null 2>&1

qr() {
  local img="${1:-$(ls -t ~/storage/pictures/Screenshots/* 2>/dev/null | head -1)}"
  [ -z "$img" ] && {
    echo "no screenshot found"
    return 1
  }
  [ -f "$img" ] || {
    echo "$img: not found"
    return 1
  }
  local out
  out=$(zbarimg -q "$img" 2>/dev/null | sed 's/^QR-Code://')
  [ -z "$out" ] && {
    echo "no qr found"
    return 1
  }
  echo "$out"
  echo "$out" | termux-clipboard-set
}

duck() {
  w3m "https://lite.duckduckgo.com/lite/?q=$(printf '%s' "$*" | sed 's/ /+/g')"
}

hi() {
  echo "Hello 🤗"
}

mk() {
  mkdir $1
  cd $1
}

d() {
  yazi --cwd-file="$tmp/cwd-file"
  cd -- "$(cat "$tmp/cwd-file")"
}

eval "$(zoxide init --cmd cd bash)"

# fzf-powered command palette on Ctrl+^
bind -x '"\C-@": __command_palette__' 2>/dev/null

__command_palette__() {
  local cmd
  cmd=$(
    compgen -ac | sort -u |
      rg -v '^(_|[. ])' |
      fzf --height 60% --border --layout=reverse --prompt='Run> '
  ) || return
  READLINE_LINE=$cmd
  READLINE_POINT=${#READLINE_LINE}
}

# fzf-powered Ctrl+R history lookup
bind -x '"\C-r": __fzf_history__' 2>/dev/null

__fzf_history__() {
  local selected
  selected=$(
    fc -ln 1 2>/dev/null |
      tac |
      awk '{ sub(/^[[:space:]]+/, ""); if (NF && !seen[$0]++) print }' |
      fzf --height 40% --border --layout=reverse --scheme=history \
        --prompt='History> ' --query="$READLINE_LINE" --tiebreak=index
  ) || return
  READLINE_LINE=$selected
  READLINE_POINT=${#READLINE_LINE}
}

sshd
