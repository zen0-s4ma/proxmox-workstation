#!/bin/bash
set -e

USER_NAME="zenosama"
USER_HOME="/home/$USER_NAME"

sudo rm -rf $USER_HOME/.oh-my-zsh
sudo rm -rf $USER_HOME/.p10k.zsh
sudo rm -rf $USER_HOME/.zshrc
sudo rm -rf /root/.oh-my-zsh
sudo rm -rf /root/.p10k.zsh

echo
echo "==> Instalando Oh My Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo
echo "==> Instalando PowerLevel10K"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k

echo
echo "==> Copiando el archivo .zshrc y .p10k.zsh..."
cp -f /opt/pve-setup/zshrc "$USER_HOME"/.zshrc
cp -f /opt/pve-setup/p10k.zsh "$USER_HOME"/.p10k.zsh

echo
echo "==> Creando enlaces simbolicos al root de .zshrc y .p10k.zsh"
sudo ln -sfv "$USER_HOME"/.zshrc /root/.zshrc
sudo ln -sfv "$USER_HOME"/.p10k.zsh /root/.p10k.zsh

echo
echo "==> Recargando .zshrc de Usuario..."
source "$USER_HOME/.zshrc"

echo
echo "==> Recargando .zshrc de Root..."
source /root/.zshrc



