alias reload!='. ~/.zshrc'
alias p="cd $PROJECTS"
alias h="cd ~"
alias d="cd ~/dotfiles"
alias g="git"

# nvim
alias v=nvim
alias vim=nvim
alias n=nvim
alias c=claude

# eza (better `ls`)
# ------------------------------------------------------------------------------
# Skipped in agent shells ($CLAUDECODE); icons=auto keeps piped `ls` output clean elsewhere.
if type eza &>/dev/null && [[ -z $CLAUDECODE ]]; then
  alias l="eza --icons=auto"
  alias ls="eza --icons=auto"
  alias ll="eza -lg --icons=auto"
  alias la="eza -lag --icons=auto"
  alias lt="eza -lTg --icons=auto"
  alias lt2="eza -lTg --level=2 --icons=auto"
  alias lt3="eza -lTg --level=3 --icons=auto"
  alias lt4="eza -lTg --level=4 --icons=auto"
  alias lta="eza -lTag --icons=auto"
  alias lta2="eza -lTag --level=2 --icons=auto"
  alias lta3="eza -lTag --level=3 --icons=auto"
  alias lta4="eza -lTag --level=4 --icons=auto"
fi
