export EDITOR='vim'

# Clipboard command (used by fzf config, etc.)
if [[ "$(uname -s)" != "Darwin" ]]; then
  if command -v xclip >/dev/null 2>&1; then
    export CLIP_COPY="xclip -selection clipboard"
  elif command -v xsel >/dev/null 2>&1; then
    export CLIP_COPY="xsel --clipboard"
  fi
fi
