#!/bin/bash
set -e

USER_NAME="zenosama"

echo
echo "==> Iniciando Script Final…"
echo
neofetch
echo
echo "==> ¡Sistema Proxmox Workstation configurado y listo!"
echo

##############################################################################
# 99.b) Reinicio
###############################################################################
echo
echo "==> Configuración inicial completa. Reiniciando con el entorno grafico activado..."
echo
sudo systemctl enable autologin.service
sudo systemctl set-default multi-user.target
#sudo systemctl set-default graphical.target

echo
echo "==> Vaciando el fichero .bash_profile..."
USER_HOME=$(eval echo "~$USER_NAME")
: > "$USER_HOME/.bash_profile"

echo "...PULSA CUALQUIER TECLA PARA CONTINUAR..."
read -n 1 -s
sudo reboot