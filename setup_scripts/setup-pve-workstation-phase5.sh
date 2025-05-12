#!/bin/bash
set -e

USER_NAME="zenosama"

echo
echo "==> Iniciando Script Fase 5 - FINAL…"
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
sudo systemctl stop autologin.service
sudo systemctl disable autologin.service
#sudo systemctl set-default multi-user.target
sudo systemctl set-default graphical.target
sudo systemctl daemon-reload

echo
echo "==> Vaciando el fichero .bash_profile..."
USER_HOME=$(eval echo "~$USER_NAME")
: > "$USER_HOME/.bash_profile"

echo "...FIN DE PHASE 5 - PULSA CUALQUIER TECLA PARA CONTINUAR. ULTIMO REBOOT..."
read -n 1 -s
sudo reboot
