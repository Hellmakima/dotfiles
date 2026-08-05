alias v="nvim"

export PATH="$HOME/.cargo/bin:$PATH"

export LS_COLORS="$(vivid generate molokai)"

alias d="yazi"
alias l="eza -l"
alias ll="eza -al"
alias op="opencode"
alias g="lazygit"
alias t="tmux attach >> /dev/null || tmux"
alias c="clear"
alias x="cd ~ && clear"
alias xx="exit"
alias r="source ~/.bashrc"

hi() {
  echo "Hello 🤗"
}

eval "$(zoxide init --cmd cd bash)"
