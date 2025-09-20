# Configure prompt with starship; fall back to a simple prompt if unavailable.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  PROMPT=$'\n%F{cyan}%1/%f %F{green}›%f '
  RPROMPT=''
fi
