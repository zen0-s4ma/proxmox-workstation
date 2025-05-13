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

##############################################################################
# 2) Activar entorno grafico
###############################################################################
echo
echo "==> Activando entorno grafico..."
sudo systemctl set-default graphical.target 

##############################################################################
# 3) Cambiando a ZSH como shell por defecto y cargando el .zshrc
###############################################################################
echo
echo "==> Cambiando a ZSH - chsh -s /bin/zsh ${USER_NAME}..."
sudo chsh -s /bin/zsh ${USER_NAME}

##############################################################################
# 4) Copiando fichero de autostart de customizacion de zsh para el primer reinicio.
###############################################################################
echo
echo "==> Creando y configurando la terminal que se inicia al arrancar..."
/opt/pve-setup/init_terminal.sh

###############################################################################
# 99.a) Actualizacion del .bash_profile para lanzar la siguiente fase
###############################################################################
echo
echo "==> Actualizacion del .bash_profile…"
USER_HOME=$(eval echo "~$USER_NAME")
cp -f /opt/pve-setup/bash_profiles_phase5 "$USER_HOME/.bash_profile"
sudo chown "$USER_NAME:$USER_NAME" /home/$USER_NAME/.bash_profile
sudo chmod 644 /home/$USER_NAME/.bash_profile
echo "==> .bash_profile Actualizado para lanzar la fase 5…"

##############################################################################
# 99.b) Reinicio
###############################################################################
echo
echo "==> Configuración inicial por consola completa. Reiniciando el sistema en modo grafico para proceder a Fase 5..."

echo
echo "...FIN DE PHASE 4 - PULSA CUALQUIER TECLA PARA CONTINUAR..."
read -n 1 -s
sudo reboot