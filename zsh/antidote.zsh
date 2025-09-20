# Load Zsh plugins via Antidote.
ANTIDOTE_HOME=${ANTIDOTE_HOME:-$HOME/.antidote}
ANTIDOTE_SCRIPT="$ANTIDOTE_HOME/antidote.zsh"
ANTIDOTE_PLUGIN_LIST=${ANTIDOTE_PLUGIN_LIST:-$DOTFILES/zsh/zsh_plugins.txt}
ANTIDOTE_CACHE=${ANTIDOTE_CACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/antidote/zsh_plugins.zsh}

if [[ -f $ANTIDOTE_SCRIPT ]]; then
  source "$ANTIDOTE_SCRIPT"

  if [[ -f $ANTIDOTE_PLUGIN_LIST ]]; then
    mkdir -p "${ANTIDOTE_CACHE:h}"
    if [[ ! -f $ANTIDOTE_CACHE || $ANTIDOTE_PLUGIN_LIST -nt $ANTIDOTE_CACHE ]]; then
      antidote bundle <"$ANTIDOTE_PLUGIN_LIST" >| "$ANTIDOTE_CACHE"
    fi
    source "$ANTIDOTE_CACHE"
  fi
elif [[ -o interactive ]]; then
  print -P '%F{yellow}[dotfiles] Antidote not found; run script/install%f' >&2
fi
