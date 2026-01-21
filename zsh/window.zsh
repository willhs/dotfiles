# Emit escape sequence to tell terminal the current directory.
# Enables "duplicate pane in same directory" in Windows Terminal, iTerm2, WezTerm, etc.
function keep_current_path() {
  if [[ -n "$WSL_DISTRO_NAME" && "$TERM_PROGRAM" != "WezTerm" ]]; then
    # Windows Terminal on WSL: use OSC 9;9 with Windows path format (ConEmu-style)
    printf '\e]9;9;%s\e\\' "$(wslpath -w "$PWD")"
  else
    # macOS/Linux/WezTerm: use OSC 7 standard format
    printf '\e]7;file://%s%s\e\\' "${HOST}" "${PWD}"
  fi
}
precmd_functions+=(keep_current_path)

# From http://dotfiles.org/~_why/.zshrc
# Sets the window title nicely no matter where you are
function title() {
  # escape '%' chars in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
  screen)
    print -Pn "\ek$a:$3\e\\" # screen title (in ^A")
    ;;
  xterm*|rxvt)
    print -Pn "\e]2;$2\a" # plain xterm title ($3 for pwd)
    ;;
  esac
}

