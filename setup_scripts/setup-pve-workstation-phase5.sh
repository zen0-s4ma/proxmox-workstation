#!/bin/bash
set -e

USER_NAME="zenosama"


##############################################################################
# 1) Resumen del sistema con neofetch
###############################################################################
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
echo "==> Vaciando el fichero .bash_profile..."
USER_HOME=$(eval echo "~$USER_NAME")
: > "$USER_HOME/.bash_profile"

/opt/pve-setup/init_terminal.sh

sudo rm /etc/systemd/system/getty@tty1.service.d/override.conf
sudo systemctl daemon-reload

sudo systemctl set-default graphical.target #sudo systemctl set-default multi-user.target para ponerlo en arranque de consola tty

echo "...FIN DE PHASE 5 - PULSA CUALQUIER TECLA PARA CONTINUAR. ULTIMO REBOOT..."
read -n 1 -s
sudo reboot