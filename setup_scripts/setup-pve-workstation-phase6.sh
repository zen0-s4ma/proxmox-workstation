#!/bin/bash
set -e

USER_NAME="zenosama"
HOME="/home/$USER_NAME"

echo
echo "==> Usuario: ${USER_NAME}"
echo "==> Home_path: ${HOME}"

##############################################################################
# 1) Eliminando fichero de customizacion de ZSH
###############################################################################
echo
echo "==> En construccion..."

##############################################################################
# 99.b) Reinicio
###############################################################################
echo
echo "...FIN DE PHASE 6 - PULSA CUALQUIER TECLA PARA CONTINUAR..."
read -n 1 -s
sudo reboot