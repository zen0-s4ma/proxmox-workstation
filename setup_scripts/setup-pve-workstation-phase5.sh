#!/bin/bash
set -e

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
sudo systemctl set-default graphical.target
echo
echo "...PULSA CUALQUIER TECLA PARA CONTINUAR..."
read -n 1 -s
sudo reboot

