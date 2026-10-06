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
mpv_flags="--vid=1 --vo=sixel --vf=fps=10 --profile=fast --framedrop=decoder+vo --hwdec=mediacodec-copy --vo-sixel-buffered=yes"
alias mpvv="mpv $mpv_flags"
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
export PATH="$HOME/.cargo/bin:$HOME/dots/moto/bin:$PATH"
# ani-cli plays through the same mpv setup as the mpvv alias
export ANI_CLI_PLAYER="mpv"
export ANI_CLI_PLAYER_FLAGS="$mpv_flags"
tmp="$PREFIX/tmp/"

d() {
  yazi --cwd-file="$tmp/cwd-file"
  cd -- "$(cat "$tmp/cwd-file")"
}

gd() {
  local gs="gdserve"
  if ! command -v "$gs" >/dev/null; then
    echo "gdserve: not on PATH (\$HOME/dots/moto/bin is in .bashrc PATH)"
    return 1
  fi
  "$gs" status || "$gs" start
}

hi() {
  echo "Hello 🤗"
}

mk() {
  mkdir $1
  cd $1
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
printf '\e[5 q'
sshd
