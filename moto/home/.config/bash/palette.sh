# fzf command palette. Sourced from ~/.bashrc (interactive only).

__command_palette__() {
  # current word = text left of the cursor, after the last separator
  local cur=${READLINE_LINE:0:READLINE_POINT}
  cur=${cur##*[^[:alnum:]_./-]}
  local cmd
  cmd=$(
    {
      compgen -ac
      history -n 500 | awk '{$1=""; sub(/^[[:space:]]+/,""); if (NF) print}'
    } |
      sort -u |
      rg -v '^(_|[.]|termai$)' |
      fzf --height 60% --border --layout=reverse \
        --prompt='Run> ' --query="$cur"
  ) || return
  # splice over just the current word, keep the rest of the line intact
  READLINE_LINE="${READLINE_LINE:0:$((READLINE_POINT - ${#cur}))}${cmd}${READLINE_LINE:READLINE_POINT}"
  READLINE_POINT=$((READLINE_POINT - ${#cur} + ${#cmd}))
}

case $- in
  *i*) bind -x '"\C-@,\C-p": __command_palette__' 2>/dev/null ;;
esac
