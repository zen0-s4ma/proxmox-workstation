#!/usr/bin/env bash
set -euo pipefail

USER_NAME="zenosama"

echo "==> 0. print del home: ${HOME}"
# Variables
ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom/themes/"
INSTALL_SCRIPT_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
P10K_GIT_REPO="https://github.com/romkatv/powerlevel10k.git"
ZSHRC="${HOME}/.zshrc"

echo
echo "==> 1. Instalar Zsh si no está presente"
if ! command -v zsh &>/dev/null; then
  sudo apt update
  sudo apt install -y zsh
else
  echo "==> Zsh ya está instalado ($(zsh --version))"
fi

echo
echo "==> 2. Instalar Oh My Zsh si no esta presente"
if [ ! -d "$HOME/auto-bspwm" ]; then
    echo
    curl -fsSL "$INSTALL_SCRIPT_URL" -o /tmp/install-ohmyzsh.sh
    sh /tmp/install-ohmyzsh.sh --unattended
    rm /tmp/install-ohmyzsh.sh
else
    echo "==> El repositorio auto-bspwm ya existe. No se realiza la instalación."
fi

echo
echo "==> 3. Clonar e instalar powerlevel10k si no esta presente"
echo
mkdir -p "$ZSH_CUSTOM/powerlevel10k"
cd "$ZSH_CUSTOM/powerlevel10k"
git clone "$P10K_GIT_REPO" 

echo
sudo chsh -s /bin/bash "$USER_NAME"

echo
echo "==> ZSH customizada"
echo
