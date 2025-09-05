#!/bin/bash
#
# Ubuntu/WSL package installation
# Installs apt packages and modern terminal tools

# Fix line endings for all shell files (common WSL issue)
echo "› Fixing line endings for shell files..."
find "$DOTFILES" -name "*.sh" -o -name "*.zsh" | xargs sed -i 's/\r$//' 2>/dev/null || true

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
  postgresql-client \
  ruby \
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
if ! command -v fzf &> /dev/null; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
fi

# eza (better ls) - install from GitHub releases
if ! command -v eza &> /dev/null; then
  echo "› Installing eza..."
  EZA_VERSION=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
  wget -q "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" -O /tmp/eza.tar.gz
  sudo tar -xzf /tmp/eza.tar.gz -C /usr/local/bin/ eza
  rm /tmp/eza.tar.gz
fi

# zoxide (better cd)
if ! command -v zoxide &> /dev/null; then
  echo "› Installing zoxide..."
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

# rbenv for Ruby version management
if ! command -v rbenv &> /dev/null; then
  echo "› Installing rbenv..."
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
fi

# grc (generic colouriser)
sudo apt install -y grc

# Set zsh as default shell if it's not already
if [ "$SHELL" != "/usr/bin/zsh" ]; then
  echo "› Setting zsh as default shell..."
  chsh -s $(which zsh)
fi

echo "› Ubuntu package installation complete!"
echo "› You may need to restart your shell or run 'source ~/.zshrc' to use new tools"