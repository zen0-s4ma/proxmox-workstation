#!/bin/bash
set -e

USER_NAME="zenosama"
USER_HOME="/home/$USER_NAME"

sudo rm -rf $USER_HOME/.oh-my-zsh
sudo rm -rf /root/.oh-my-zsh
sudo rm -rf $USER_HOME/.zshrc

echo
echo "==> Instalando Oh My Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo
echo "==> Instalando PowerLevel10K"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

echo
echo "==> Copiando el archivo .zshrc..."
cp -f /opt/pve-setup/zshrc "$USER_HOME"/.zshrc

echo
echo "==> Recargando .zshrc..."
source "$USER_HOME/.zshrc"
