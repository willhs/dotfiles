# GRC colorizes nifty unix tools all over the place
if (( $+commands[grc] )); then
  if (( $+commands[brew] )); then
    source "$(brew --prefix)/etc/grc.bashrc"
  elif [[ -f /etc/grc.zsh ]]; then
    source /etc/grc.zsh
  fi
fi
