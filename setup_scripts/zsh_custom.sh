#!/usr/bin/env bash
set -euo pipefail


echo "==> 0. print del home: ${HOME}"
# Variables
ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
INSTALL_SCRIPT_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
P10K_GIT_REPO="https://github.com/romkatv/powerlevel10k.git"
ZSHRC="${HOME}/.zshrc"

echo "==> 1. Instalar Zsh si no está presente"
if ! command -v zsh &>/dev/null; then
  sudo apt update
  sudo apt install -y zsh
else
  echo "    Zsh ya está instalado ($(zsh --version))"
fi

echo
echo "==> 2. Instalar Oh My Zsh (sin cambiar shell por defecto)"
# Descarga y ejecuta el instalador, pero evita el chsh automático
curl -fsSL "$INSTALL_SCRIPT_URL" -o /tmp/install-ohmyzsh.sh

# Ejecuta el instalador
sh /tmp/install-ohmyzsh.sh --unattended
rm /tmp/install-ohmyzsh.sh

echo
echo "==> 3. Clonar e instalar Powerlevel10k"
git clone --depth=1 "$P10K_GIT_REPO" "${ZSH_CUSTOM}/themes/powerlevel10k"

echo
chsh -s /bin/bash "$USER_NAME"

echo
echo "==> ZSH customizada, en el primer arranque se elijen las opciones de Powerlevel10k"
echo
