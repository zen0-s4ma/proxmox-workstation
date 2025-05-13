#!/bin/bash
set -e

USER_NAME="zenosama"
HOME="/home/$USER_NAME"

echo
echo "==> Usuario: ${USER_NAME}"
echo "==> Home_path: ${HOME}"

##############################################################################
# 1) Copiando fichero de autostart de customizacion de zsh para el primer reinicio.
###############################################################################
echo
echo "==> lanzando customizador de ZSH..."
/opt/pve-setup/zsh_customizer.sh

##############################################################################
# 2) Cambiando el autostart para que arranque con la actualizacion
###############################################################################
echo
echo "==> actualizando autostart..."
/opt/pve-setup/autostart_zsh_customizer.desktop
sudo rm -rf "${HOME}/.config/autostart/autostart_zsh_customizer.desktop"

###############################################################################
# 99.a) Actualizacion del .bash_profile para lanzar la siguiente fase
###############################################################################
echo
echo "==> Actualizacion del .bash_profile…"
USER_HOME=$(eval echo "~$USER_NAME")
cp -f /opt/pve-setup/bash_profiles_phase6 "$USER_HOME/.bash_profile"
sudo chown "$USER_NAME:$USER_NAME" /home/$USER_NAME/.bash_profile
sudo chmod 644 /home/$USER_NAME/.bash_profile
echo "==> .bash_profile Actualizado para lanzar la fase 6…"

##############################################################################
# 99.b) Reinicio
###############################################################################
echo
echo "==> Reiniciando el sistema en modo grafico para proceder a Fase 6..."

echo
echo "...FIN DE PHASE 5 - PULSA CUALQUIER TECLA PARA CONTINUAR..."
read -n 1 -s
sudo reboot