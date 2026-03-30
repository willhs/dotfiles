#!/bin/bash
#
# Ubuntu/WSL package installation
# Installs apt packages and modern terminal tools

# Update package list
echo "› sudo apt update"
sudo apt update

# Install essential packages
echo "› Installing essential packages..."
sudo apt install -y \
  curl \
  wget \
  git \
  zsh \
  build-essential \
  software-properties-common \
  apt-transport-https \
  ca-certificates \
  gnupg \
  lsb-release

# Install basic development packages
echo "› Installing development packages..."
sudo apt install -y \
  ack \
  jq \
  imagemagick \
  nodejs \
  npm \
  neovim

# Install modern terminal tools
echo "› Installing modern terminal tools..."

# bat (better cat)
sudo apt install -y bat
# Ubuntu installs as 'batcat', create symlink
if [ ! -f ~/.local/bin/bat ] && command -v batcat >/dev/null 2>&1; then
  mkdir -p ~/.local/bin
  ln -s /usr/bin/batcat ~/.local/bin/bat
fi

# fzf (fuzzy finder)
sudo apt install -y fzf

# ripgrep (better grep)
sudo apt install -y ripgrep

# eza (better ls)
if ! command -v eza &> /dev/null; then
  echo "› Installing eza..."
  curl -sS https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/debian.griffo.io.gpg
  echo "deb https://debian.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/debian.griffo.io.list
  sudo apt update
  sudo apt install -y eza
fi

# zoxide (better cd)
if ! command -v zoxide &> /dev/null; then
  echo "› Installing zoxide..."
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

# grc (generic colouriser)
sudo apt install -y grc

# starship (prompt)
if ! command -v starship &> /dev/null; then
  echo "› Installing starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Nerd Font (for starship icons)
if ! fc-list | grep -qi "nerd"; then
  echo "› Installing FiraCode Nerd Font..."
  mkdir -p ~/.local/share/fonts
  cd ~/.local/share/fonts
  curl -sLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip
  unzip -o FiraCode.zip
  rm FiraCode.zip
  fc-cache -fv
  cd - > /dev/null
  echo "› Nerd Font installed! Configure your terminal to use 'FiraCode Nerd Font'"
else
  echo "› Nerd Font already installed"
fi

# Set zsh as default shell if it's not already
if [ "$SHELL" != "/usr/bin/zsh" ]; then
  echo "› Setting zsh as default shell..."
  sudo chsh -s $(which zsh) $USER
fi

echo "› Ubuntu package installation complete!"
echo "› You may need to restart your shell or run 'source ~/.zshrc' to use new tools"
echo "› Don't forget to set your terminal font to 'FiraCode Nerd Font' for icons to display"
