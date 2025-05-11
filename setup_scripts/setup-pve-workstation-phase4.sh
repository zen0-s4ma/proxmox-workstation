#!/bin/bash
set -e

echo "==> Iniciando Script Fase 2…"

USER_NAME="zenosama"

export HOME="/home/zenosama"
cd "$HOME"

###############################################################################
# 1) Instalacion de Auto-bspwm
###############################################################################
echo
echo "==> Comenzando ejecución de post-instalación como usuario $(id -un)..."
echo "==> Clonando repositorio auto-bspwm y ejecutando instalación..."
git clone https://github.com/RaulSanchezzt/auto-bspwm.git ~/auto-bspwm
cd ~/auto-bspwm
sudo chmod +x setup.sh
./setup.sh || { echo "(Error) Falló la instalación de auto-bspwm"; exit 1; }
sudo cd "$HOME"

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

###############################################################################
# 99.a) Llamando al orquestador para la ejecucion del script en el proximo reinicio
###############################################################################
echo
echo "==> llamamos al orquestador para configurar el proximo reinicio..."
/usr/local/bin/setup-orchestation.sh "$USER_NAME" "/opt/pve-setup/setup-pve-workstation-phase5.sh"

##############################################################################
# 99.b) Reinicio
###############################################################################
echo
echo "==> Configuración inicial completa. Reiniciando el sistema para proceder a Fase 2..."
echo "...PULSA CUALQUIER TECLA PARA CONTINUAR..."
read -n 1 -s
sudo reboot