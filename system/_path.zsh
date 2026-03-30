export PATH="$HOME/.local/bin:$PATH:./bin:/usr/local/bin:/usr/local/sbin:$DOTFILES/bin"

# Ruby user-installed gems
if command -v ruby >/dev/null 2>&1; then
  GEM_USER_DIR="$(ruby -e 'puts Gem.user_dir' 2>/dev/null)/bin"
  [ -d "$GEM_USER_DIR" ] && export PATH="$PATH:$GEM_USER_DIR"
  unset GEM_USER_DIR
fi
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"
