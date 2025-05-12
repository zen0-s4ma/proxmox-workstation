#!/bin/bash
set -e

USER_NAME="zenosama"
HOME="/home/$HOME"


##############################################################################
# 1) Resumen del sistema con neofetch
###############################################################################
echo
echo "==> Iniciando Script Fase 5 - FINAL…"
echo
echo "==> Eligiendo terminal…"
echo
sudo update-alternatives --config x-terminal-emulator
echo
echo "==> ¡Sistema Proxmox Workstation configurado y listo!"

##############################################################################
# 99.b) Reinicio
###############################################################################
echo
echo "==> Configuración inicial completa. Reiniciando con el entorno grafico activado..."
echo
echo "==> Vaciando el fichero .bash_profile..."
: > "$HOME/.bash_profile"

echo
/opt/pve-setup/init_terminal.sh
echo

#sudo systemctl set-default multi-user.target
sudo systemctl set-default graphical.target 
echo

#Borrado del servicio de autologin
sudo rm /etc/systemd/system/getty@tty1.service.d/override.conf
sudo systemctl daemon-reload

echo "...FIN DE FASE FINAL - PULSA CUALQUIER TECLA PARA CONTINUAR. ULTIMO REBOOT Y ARRANCA CON ENTORNO GRAFICO..."
read -n 1 -s
sudo reboot