
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY
HISTFILE=~/.zsh_history
SAVEHIST=10000
HISTSIZE=10000

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/opt/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/opt/openjdk@17/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
# PROMPT='%F{red}%BAPPLE%b%f %F{blue}%~%f: '

# Yazi editor
export EDITOR="nvim"

alias b='btop'
alias c='clear'
alias cda='conda deactivate'
alias cp='cp -i'
alias d='yazi'
alias gc='cd ~/.config'
alias gd='cd ~/Downloads'
alias gh='cd ~'
alias l="eza -l --icons --group-directories-first"
alias lg="lazygit"
alias ll="eza -la --icons --group-directories-first"
alias lq='lazysql'
alias lt="eza --tree --icons --git-ignore"
alias r='source ~/.zshrc'
alias rm="trash" # to delete permanently, use \rm <file> # trash is MAC specific.
alias sb='"/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"'
alias ssh='TERM=xterm-256color ssh'
alias t="tmux"
alias v='nvim'

# Completion
ZSH_DISABLE_COMPFIX=true

autoload -U compinit
zstyle ':completion:*' menu select # Enables interactive selection menu
zstyle ':completion:*' special-dirs true # includes ./ and ../
zmodload zsh/complist
compinit

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line

# Include hidden files in autocomplete:
_comp_options+=(globdots)

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
# bindkey -v '^?' backward-delete-char

hi() {
  echo "Hello 🤗"
}

# mk -> mkdir and cd
mk() {
  if [ -z "$1" ]; then
    echo "Usage: mk <dir>"
    return 1
  fi
  mkdir -p "$1" && cd "$1"
}

# --- CONDA

# Create conda env + install poetry deps
cn() {
  # Get current directory name
  local name="${PWD##*/}"

  # Ensure conda is available in this shell
  if ! command -v conda &>/dev/null; then
    echo "conda not found. Make sure conda is initialized in zsh."
    return 1
  fi

  echo "Creating conda env: $name"

  # default
  local pyver="3.10.12"

  # if project mentions 3.12 anywhere → use it
  if grep -q "3.12.11" pyproject.toml 2>/dev/null; then
    pyver="3.12.11"
  fi

  echo "Using Python $pyver"

  conda create -n "$name" python="$pyver" -y || return 1
  conda activate "$name" || return 1

  pip install poetry || return 1

  # poetry lock || return 1
  poetry install || return 1

  echo "Environment '$name' ready."
}

# Activate conda env named after current directory
ca() {
  [[ -f ~/Documents/files/.env.sh ]] && source ~/Documents/files/.env.sh
  __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
          . "/opt/miniconda3/etc/profile.d/conda.sh"
      else
          export PATH="/opt/miniconda3/bin:$PATH"
      fi
  fi
  unset __conda_setup
  local name="${PWD##*/}"

  if ! command -v conda &>/dev/null; then
    echo "conda not found. Make sure conda is initialized in zsh."
    return 1
  fi

  # conda activate "$name"
  # Check if env exists BEFORE activating
  if conda env list | awk '{print $1}' | grep -qx "$name"; then
    conda activate "$name"
  else
    echo "No environment found"
    conda deactivate
    return 1
  fi
}

# --- ZSH HISTORY

source $(brew --prefix)/opt/fzf/shell/key-bindings.zsh

# https://github.com/junegunn/fzf/issues/1309
# Remove repeated entries from fzf history search
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  selected=( $(fc -rl 1 |
    sort -k2 -k1rn | uniq -f 1 | sort -r -n |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}

zle -N fzf-history-widget
bindkey '^R' fzf-history-widget

: '
^r # to use it normally, 
history # to see all history
fc -p # delete all history
history -d <line_number> # delete specific line
'

# ---

# Colors
export LS_COLORS="$(vivid generate tokyonight-night)"

# allow comments in terminal
setopt interactivecomments

# HOMEBREW setup
eval "$(/usr/local/bin/brew shellenv)"
# Starship decorations (time git status, etc)
eval "$(starship init zsh)"
# Zoxide
eval "$(zoxide init --cmd cd zsh)"
# Command + l/r -> home/end
bindkey '^[[1;9D' beginning-of-line
bindkey '^[[1;9C' end-of-line
# bindkey '^[[1;3D' backward-word
# bindkey '^[[1;3C' forward-word

clear
