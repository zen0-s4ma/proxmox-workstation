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
# 2) Copiando fichero de autostart de customizacion de zsh para el primer reinicio.
###############################################################################
echo
echo "==> lanzando customizador de ZSH..."
/opt/pve-setup/zsh_customizer.sh

##############################################################################
# 3) Cambiando el autostart para que arranque con la actualizacion
###############################################################################
echo
echo "==> actualizando autostart..."
/opt/pve-setup/autostart_zsh_customizer.desktop

sudo rm -rf "${HOME}/.config/autostart/autostart_zsh_customizer.desktop"
cp -f /opt/pve-setup/autostart_terminal.desktop "${HOME}/.config/autostart/autostart_terminal.desktop"
chown "${USER_NAME}:${USER_NAME}" "${HOME}/.config/autostart/autostart_zsh_customizer.desktop"

##############################################################################
# 99.b) Reinicio
###############################################################################
echo
echo "==> Configuración inicial completa. Reiniciando con el entorno grafico activado..."

echo
echo "...FIN DE FASE FINAL - PULSA CUALQUIER TECLA PARA CONTINUAR. ULTIMO REBOOT..."
read -n 1 -s
sudo reboot