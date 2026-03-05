# Pipe my public key to my clipboard.
if [[ "$(uname -s)" == "Darwin" ]]; then
  alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
elif command -v xclip >/dev/null 2>&1; then
  alias pubkey="more ~/.ssh/id_rsa.pub | xclip -selection clipboard | echo '=> Public key copied to clipboard.'"
elif command -v xsel >/dev/null 2>&1; then
  alias pubkey="more ~/.ssh/id_rsa.pub | xsel --clipboard | echo '=> Public key copied to clipboard.'"
fi
