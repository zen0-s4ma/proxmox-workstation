#!/bin/bash
set -e

USER_NAME="zenosama"
HOME="/home/$USER_NAME"

echo
echo "==> Usuario: ${USER_NAME}"
echo "==> Home_path: ${HOME}"

##############################################################################
# 1) Cambiando a ZSH como shell por defecto y cargando el .zshrc
###############################################################################
echo
echo "==> Cambiando a ZSH - chsh -s /bin/zsh ${USER_NAME}..."
sudo chsh -s /bin/zsh ${USER_NAME}

##############################################################################
# 2) Copiando fichero de autostart de customizacion de zsh para el primer reinicio.
###############################################################################
echo
echo "==> lanzando customizador de ZSH..."
/opt/pve-setup/zsh_customizer.sh

##############################################################################
# 3) Activar entorno grafico
###############################################################################
echo
echo "==> Activando entorno grafico..."
sudo systemctl set-default graphical.target 

##############################################################################
# 99.a) Limpieza de .bash_profile
###############################################################################
echo
echo "==> Vaciando el fichero .bash_profile..."
: > "$HOME/.bash_profile"

##############################################################################
# 99.b) Reinicio
###############################################################################
echo
echo "==> Reiniciando el sistema en modo grafico..."

echo
echo "...FIN DE PHASE 5 - PULSA CUALQUIER TECLA PARA CONTINUAR..."
#read -n 1 -s
sudo reboot