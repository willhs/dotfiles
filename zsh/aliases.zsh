alias reload!='. ~/.zshrc'
alias p="cd $PROJECTS"
alias h="cd ~"
alias d="cd ~/dotfiles"
alias g="git"

# nvim
alias v=nvim
alias vim=nvim
alias n=nvim

# eza (better `ls`)
# ------------------------------------------------------------------------------
if type eza &>/dev/null; then
  alias l="eza --icons=always"
  alias ls="eza --icons=always"
  alias ll="eza -lg --icons=always"
  alias la="eza -lag --icons=always"
  alias lt="eza -lTg --icons=always"
  alias lt2="eza -lTg --level=2 --icons=always"
  alias lt3="eza -lTg --level=3 --icons=always"
  alias lt4="eza -lTg --level=4 --icons=always"
  alias lta="eza -lTag --icons=always"
  alias lta2="eza -lTag --level=2 --icons=always"
  alias lta3="eza -lTag --level=3 --icons=always"
  alias lta4="eza -lTag --level=4 --icons=always"
else
  echo ERROR: eza could not be found. Skip setting up eza aliases.
fi


# -----------------
# OLD MEMORIES
# -----------------
# ssh into vuw server
# for auto-password entry
# 1) ssh-keygen -t rsa -b 2048
#   a) specify file to save key to
#   b) use blank passphrase
# 2) ssh-copy-id id@server
alias ssh-vuw="ssh hardwiwill@barretts.ecs.vuw.ac.nz"
alias ssh-banana="ssh root@202.150.114.180"
alias ssh-rasp="ssh pi@202.150.114.180"
alias ssh-notes="ssh -i $LIGHTSAIL ec2-user@54.153.143.35"
alias ssh-notes-ci="ssh -i $HOME/.local/lib/aws/ec2.pem ec2user@ec2-13-211-188-99.ap-southeast-2.compute.amazonaws.com"
