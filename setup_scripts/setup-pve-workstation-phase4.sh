#!/bin/bash
set -e

echo "==> Iniciando Script Fase 2…"

USER_NAME="zenosama"

export HOME="/home/zenosama"
cd "$HOME"

###############################################################################
# 0) Instalacion de Auto-bspwm
###############################################################################
echo
echo "==> Comenzando ejecución de post-instalación como usuario $(id -un)..."
echo "==> Clonando repositorio auto-bspwm y ejecutando instalación..."
git clone https://github.com/RaulSanchezzt/auto-bspwm.git ~/auto-bspwm
cd ~/auto-bspwm
chmod +x setup.sh
./setup.sh || { echo "(Error) Falló la instalación de auto-bspwm"; exit 1; }
cd "$HOME"

echo
echo "==> Clonando repositorio de dotfiles y aplicando configuración..."
# Si se dispone de un repositorio de dotfiles para configurar el entorno (por ejemplo, configuración de bspwm, polybar, etc.)
if [ -n "$DOTFILES_REPO" ]; then
    git clone "$DOTFILES_REPO" ~/dotfiles
else
    git clone https://github.com/RaulSanchezzt/dotfiles.git ~/dotfiles
fi
cd ~/dotfiles && chmod +x link.sh && ./link.sh || echo "(Aviso) No se ejecutó link.sh de dotfiles"
cd "$HOME"