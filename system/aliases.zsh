# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if command -v gls >/dev/null 2>&1; then
  alias ls="gls --classify=auto --color=auto"
  alias l="gls -lAh --color=auto"
  alias ll="gls -l --color=auto"
  alias la='gls -A --color=auto'
fi

alias du="du -h"
