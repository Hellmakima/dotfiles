# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# --- Termux env ported from ~/.bashrc ---
export PATH="$HOME/.cargo/bin:$HOME/dots/moto/bin:$PATH"
export ANDROID_HOME="$HOME/Android/sdk"
export ANDROID_NDK_ROOT="$ANDROID_HOME/ndk/21.4.7075529"
export JAVA_HOME="$PREFIX/lib/jvm/java-21-openjdk"
export ANI_CLI_PLAYER="mpv"
mpv_flags="--vid=1 --vo=sixel --vf=fps=10 --profile=fast --framedrop=decoder+vo --hwdec=mediacodec-copy --vo-sixel-buffered=yes"
export ANI_CLI_PLAYER_FLAGS="$mpv_flags"
tmp="$PREFIX/tmp/"
# vivid palette must be set before oh-my-zsh loads, or OMZ fills LS_COLORS with its own.
export LS_COLORS="$(vivid generate molokai)"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# Prompt comes from starship (see bottom of this file); OMZ theme disabled.
ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change the frequency the auto-updater is run (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line to set how old an update must be before it's applied, manually or via the auto-updater (in days).
# zstyle ':omz:update' cooldown 10

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
VI_MODE_SET_CURSOR=true   # block cursor in normal mode, bar in insert
MODE_INDICATOR="%F{yellow}-- NORMAL --%f"

plugins=(
  vi-mode
  git
  extract
  colored-man-pages
  history-substring-search
  zsh-autosuggestions
  transient-prompt
  zsh-syntax-highlighting   # must stay last
)

# compinit disabled on purpose: no Tab completion. Saves ~45ms per shell and
# removes the 1.2s dump-rebuild spike. Delete these two lines to get Tab back.
compinit() { return 0 }
compdef() { return 0 }

# History size (OMZ only raises its defaults, so set before oh-my-zsh loads)
HISTSIZE=50000
SAVEHIST=50000

# vivid palette already exported above.

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR="nvim"
export VISUAL="nvim"

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes.
alias b="top -o PID,%CPU,%MEM,CMDLINE"
alias c="clear"
alias cd-="cd -"
alias cd..="cd .."
alias cd.="cd .."
alias ff="fastfetch"
alias g="lazygit"
alias l="eza -l --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first"
alias lt="eza --tree --icons --git-ignore"
alias mpvv="mpv $mpv_flags"
alias od="objdump"
alias op="opencode"
alias pi="pkg info"
alias ps="pkg search"
alias r="source ~/.zshrc"
alias rc="v ~/.zshrc"
alias t="tmux attach &> /dev/null || tmux"
alias tl="tldr"
alias uu="pkg update && pkg upgrade"
alias v="nvim"
alias w="w3m"
alias x="cd ~ && clear"
alias xx="exit"
alias yt="yt-dlp --format 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]'"

d() {
  yazi --cwd-file="$tmp/cwd-file"
  cd -- "$(cat "$tmp/cwd-file")"
}

unalias gd 2>/dev/null   # OMZ git plugin owns `gd` = git diff
gd() {
  local gs="gdserve"
  if ! command -v "$gs" >/dev/null; then
    echo "gdserve: not on PATH (\$HOME/dots/moto/bin)"
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

# Shell options
setopt autocd
zstyle ':completion:*' menu select

# zsh-native integrations (the bash versions in ~/.bashrc do not parse here)
eval "$(zoxide init --cmd cd zsh)"
source <(fzf --zsh)

# Ctrl-P command palette, zsh port of ~/.config/bash/palette.sh
__command_palette() {
  emulate -L zsh
  local cur=${BUFFER[1,CURSOR]}
  cur=${cur##*[^[:alnum:]_./-]}
  local cmd
  cmd=$(
    {
      compgen -ac 2>/dev/null
      fc -ln -500 2>/dev/null | sed 's/^[[:space:]]*//'
    } |
      sort -u |
      rg -v '^(_|[.]|termai$)' |
      fzf --height 60% --border --layout=reverse \
        --prompt='Run> ' --query="$cur"
  ) || return 0
  BUFFER="${BUFFER[1,$((CURSOR - ${#cur}))]}${cmd}${BUFFER[$((CURSOR + 1)),-1]}"
  CURSOR=$((CURSOR - ${#cur} + ${#cmd}))
}
zle -N __command_palette
bindkey '^@' __command_palette   # Ctrl-Space (^P left as history-up)

printf '\e[5 q'

# --- prompt ---
# Native 2-line prompt, no starship. Line 1: dir + git status symbols, line 2: ">".
# Symbols mirror the starship config: ? untracked, * modified, + staged, d deleted,
# r renamed, x conflicted, $ stashed, + ahead, - behind.
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{yellow}?%f"
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{yellow}*%f"
ZSH_THEME_GIT_PROMPT_ADDED="%F{green}+%f"
ZSH_THEME_GIT_PROMPT_DELETED="%F{red}d%f"
ZSH_THEME_GIT_PROMPT_RENAMED="%F{magenta}r%f"
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{red}x%f"
ZSH_THEME_GIT_PROMPT_STASHED="%F{magenta}\$%f"
ZSH_THEME_GIT_PROMPT_AHEAD="%F{green}+%f"
ZSH_THEME_GIT_PROMPT_BEHIND="%F{red}-%f"
PROMPT=$'%B%F{cyan}%~%f%b $(git_prompt_status)\n%B%F{cyan}>%f%b '

# Transient prompt (olets/zsh-transient-prompt): finished lines collapse to ">".
TRANSIENT_PROMPT_PROMPT=$PROMPT
TRANSIENT_PROMPT_RPROMPT='$(vi_mode_prompt_info)'
TRANSIENT_PROMPT_TRANSIENT_PROMPT=$'%F{cyan}>%f '
TRANSIENT_PROMPT_TRANSIENT_RPROMPT=''
typeset -g TRANSIENT_PROMPT_PROMPT TRANSIENT_PROMPT_RPROMPT
typeset -g TRANSIENT_PROMPT_TRANSIENT_PROMPT TRANSIENT_PROMPT_TRANSIENT_RPROMPT

# starship (disabled, see the PROMPT line above)
# eval "$(starship init zsh)"
sshd
