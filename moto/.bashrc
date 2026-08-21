alias v="nvim"

export PATH="$HOME/.cargo/bin:$PATH"

export LS_COLORS="$(vivid generate molokai)"

alias b="top -o PID,%CPU,%MEM,CMDLINE"
alias l="eza -l --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first"
alias lt="eza --tree --icons --git-ignore"
alias op="opencode"
alias g="lazygit"
alias ip="ifconfig 2> /dev/null | grep inet | awk '{print \$2}'"
alias t="tmux attach >> /dev/null || tmux"
alias c="clear"
alias cd..="cd .."
alias cd-="cd -"
alias x="cd ~ && clear"
alias xx="exit"
alias r="source ~/.bashrc"

tmp="$PREFIX/tmp"

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
