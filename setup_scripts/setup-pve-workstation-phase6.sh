#!/bin/bash
set -e

USER_NAME="zenosama"
HOME="/home/$USER_NAME"

echo
echo "==> Usuario: ${USER_NAME}"
echo "==> Home_path: ${HOME}"

##############################################################################
# 1) Limpieza de .bash_profile
###############################################################################
echo
echo "==> Vaciando el fichero .bash_profile..."
: > "$HOME/.bash_profile"

##############################################################################
# 2) Eliminando fichero de customizacion de ZSH
###############################################################################
echo
echo "==> Eliminando fichero de customizacion de ZSH..."
sudo rm -rf "${HOME}/.config/autostart/autostart_zsh_customizer.desktop"

##############################################################################
# 99.b) Reinicio
###############################################################################
echo
echo "==> Reiniciando Final, Instalacion completada..."

echo
echo "...FIN DE PHASE 6 - PULSA CUALQUIER TECLA PARA CONTINUAR..."
read -n 1 -s
sudo reboot