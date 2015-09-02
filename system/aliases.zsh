# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
fi

# ssh into vuw server
# for auto-password entry:
# 1) ssh-keygen -t rsa -b 2048 
#   a) specify file to save key to
#   b) use blank passphrase
# 2) ssh-copy-id id@server
alias vuw="ssh hardwiwill@barretts.ecs.vuw.ac.nz"
