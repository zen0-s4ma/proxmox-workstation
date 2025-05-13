#!/bin/bash
set -e

USER_NAME="zenosama"
HOME="/home/$USER_NAME"

echo
echo "==> Usuario: ${USER_NAME}"
echo "==> Home_path: ${HOME}"

##############################################################################
# 1) Seleccion de terminal
###############################################################################
echo
echo "==> Iniciando Script Fase 4 - FINAL…"
echo
echo "==> Eligiendo terminal…"
echo
sudo update-alternatives --config x-terminal-emulator
echo
echo "==> ¡Sistema Proxmox Workstation configurado y listo!"

##############################################################################
# 2) Limpieza de .bash_profile
###############################################################################
echo
echo "==> Vaciando el fichero .bash_profile..."
: > "$HOME/.bash_profile"

##############################################################################
# 3) Lanzador de terminal
###############################################################################
echo
echo "==> Creando fichero de lanzador de terminal…"
mkdir -p "${HOME}/.config/autostart"
echo
cp -f /opt/pve-setup/autostart_terminal.desktop "${HOME}/.config/autostart/auto_terminal.desktop"
# Asegúrate de que el usuario tenga permisos sobre el fichero
chown "${USER_NAME}:${USER_NAME}" "${HOME}/.config/autostart/auto_terminal.desktop"
echo "La terminal se ejecutará automáticamente al iniciar el entorno gráfico."

##############################################################################
# 4) Activar entorno grafico
###############################################################################
echo
echo "==> Activando entorno grafico..."
sudo systemctl set-default graphical.target 

##############################################################################
# 5) Borrado del servicio de autologin
###############################################################################
#echo
#echo "==> Borrando el servicio de autologin..."
#sudo rm /etc/systemd/system/getty@tty1.service.d/override.conf
#sudo systemctl daemon-reload

##############################################################################
# 6) Cambiando a ZSH como shell por defecto y cargando el .zshrc
###############################################################################
echo
echo "==> Cambiando a ZSH - chsh -s /bin/zsh ${USER_NAME}..."
echo
echo "==> copiando el archivo .zshrc..."
cp -f /opt/pve-setup/zshrc "$HOME"/.zshrc
echo
#echo "==> Lanzando ZSH..."
#zsh -ic "source ${HOME}/.zshrc"
echo
echo "==> Eligiendo ZSH como predeterminada..."
sudo chsh -s /bin/zsh ${USER_NAME}
echo
echo "==> Lanzando ZSH..."
zsh

##############################################################################
# 99.b) Reinicio
###############################################################################
echo
echo "==> Configuración inicial completa. Reiniciando con el entorno grafico activado..."
echo "...FIN DE FASE FINAL - PULSA CUALQUIER TECLA PARA CONTINUAR. ULTIMO REBOOT Y ARRANCA CON ENTORNO GRAFICO..."
read -n 1 -s
sudo reboot