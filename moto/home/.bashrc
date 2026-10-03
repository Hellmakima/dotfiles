alias b="top -o PID,%CPU,%MEM,CMDLINE"
alias c="clear"
alias cd-="cd -"
alias cd..="cd .."
alias cd.="cd .."
alias ff="fastfetch --logo /storage/emulated/0/Documents/wall/mak.jpg"
alias g="lazygit"
alias l="eza -l --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first"
alias lt="eza --tree --icons --git-ignore"
alias od="objdump"
alias op="opencode"
alias r="source ~/.bashrc"
alias rc="v ~/.bashrc"
alias t="tmux attach &> /dev/null || tmux"
alias tl="tldr"
alias uu="pkg update && pkg upgrade"
alias v="nvim"
alias w="w3m"
alias x="cd ~ && clear"
alias xx="exit"
export LS_COLORS="$(vivid generate molokai)"
export PATH="$HOME/.cargo/bin:$PATH"
tmp="$PREFIX/tmp/"

d() {
  yazi --cwd-file="$tmp/cwd-file"
  cd -- "$(cat "$tmp/cwd-file")"
}

gd() {
  local gs="$HOME/dots/moto/bin/gdserve"
  if [ ! -x "$gs" ]; then
    echo "gdserve: not found at $gs"
    return 1
  fi
  "$gs" status || "$gs" start
}

hi() {
  echo "Hello 🤗"
}

ip() {
  ifconfig 2>/dev/null | awk '
    /^[a-zA-Z0-9_]+:/ { iface = $1; sub(":", "", iface); next }
    iface != "" && iface != "lo" && $1 == "inet" {
      split($2, a, ":")
      addr = (a[2] != "") ? a[2] : a[1]
      if (iface ~ /^(tun|tap|tailscale|wg|uvpn|ppp|ipsec)/) label = "vpn"
      else if (addr ~ /^(10\.|192\.168\.|172\.(1[6-9]|2[0-9]|3[01])\.)/) label = "lan"
      else label = "isp"
      if (!(label in seen)) seen[label] = addr
      iface = ""
    }
    END {
      order[1] = "vpn"; order[2] = "isp"; order[3] = "lan"
      for (i = 1; i <= 3; i++) if (order[i] in seen) print order[i] ": " seen[order[i]]
    }
  '
}

mk() {
  mkdir $1
  cd $1
}

m3u8() {
  [ -z "$1" ] && {
    echo "usage: m3u8 <url> [out.mp4]"
    return 1
  }
  ffmpeg \
    -reconnect 1 \
    -reconnect_streamed 1 \
    -reconnect_on_network_error 1 \
    -reconnect_on_http_error 4xx,5xx \
    -reconnect_max_retries 20 \
    -seg_max_retry 10 \
    -i "$1" \
    -c copy \
    "${2:-out.mp4}"
}

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

# fzf-powered command palette on Ctrl+^
bind -x '"\C-@": __command_palette__' 2>/dev/null

__command_palette__() {
  local cmd
  cmd=$(
    compgen -ac | sort -u |
      rg -v '^(_|[. ]|termai$)' |
      fzf --height 60% --border --layout=reverse --prompt='Run> '
  ) || return
  READLINE_LINE=$cmd
  READLINE_POINT=${#READLINE_LINE}
}

source <(fzf --bash)
shopt -s nocasematch
bind 'set completion-ignore-case on'
PROMPT_COMMAND='history -a'
HISTCONTROL=
eval "$(zoxide init --cmd cd bash)"
sshd
