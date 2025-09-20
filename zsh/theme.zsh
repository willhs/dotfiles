# reloads the zsh theme (because it gets overwritten somewhere)
: "${OHMYZSH:=$HOME/.oh-my-zsh}"
: "${ZSH_THEME:=robbyrussell}"

if [ -f "$OHMYZSH/themes/$ZSH_THEME.zsh-theme" ]; then
  source "$OHMYZSH/themes/$ZSH_THEME.zsh-theme"
fi
