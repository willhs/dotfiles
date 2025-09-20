# Configure prompt with starship; fall back to a simple prompt if unavailable.
export STARSHIP_CONFIG=${STARSHIP_CONFIG:-$DOTFILES/zsh/starship/starship.toml}

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  PROMPT=$'\n%F{cyan}%1/%f %F{green}›%f '
  RPROMPT=''
fi
