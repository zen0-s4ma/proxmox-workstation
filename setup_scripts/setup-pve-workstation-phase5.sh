#!/bin/bash
set -e

USER_NAME="zenosama"
HOME="/home/$USER_NAME"


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
echo "==> Directorio home: ${USER_HOME}"

echo
echo "==> Vaciando el fichero .bash_profile..."
: > "$HOME/.bash_profile"

echo
mkdir -p "${USER_HOME}/.config/autostart"
echo
echo "==> Creando fichero de lanzador de terminal…"
cp -f /opt/pve-setup/autostart_terminal.desktop "${USER_HOME}/.config/autostart/auto_terminal.desktop"
# Asegúrate de que el usuario tenga permisos sobre el fichero
chown "${USER_NAME}:${USER_NAME}" "${USER_HOME}/.config/autostart/auto_terminal.desktop"
echo
echo "La terminal se ejecutará automáticamente al iniciar el entorno gráfico."
echo

echo
echo "==> Activando entorno grafico..."
#sudo systemctl set-default multi-user.target
sudo systemctl set-default graphical.target 


echo
echo "==> Borrando el servicio de autologin..."
#Borrado del servicio de autologin
sudo rm /etc/systemd/system/getty@tty1.service.d/override.conf
sudo systemctl daemon-reload

echo
echo "==> Cambiando a ZSH..."
chsh -s /bin/zsh "$USER_NAME"

echo
zsh
source ~/.zshrc

echo "...FIN DE FASE FINAL - PULSA CUALQUIER TECLA PARA CONTINUAR. ULTIMO REBOOT Y ARRANCA CON ENTORNO GRAFICO..."
read -n 1 -s
sudo reboot