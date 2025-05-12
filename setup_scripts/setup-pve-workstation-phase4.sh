#!/bin/bash
set -e

echo "==> Iniciando Script Fase 2…"

USER_NAME="zenosama"

export HOME="/home/zenosama"
cd "$HOME"

###############################################################################
# 1) Instalacion de Auto-bspwm
###############################################################################
echo
echo "==> Comenzando ejecución de post-instalación como usuario $(id -un)..."
echo "==> Clonando repositorio auto-bspwm y ejecutando instalación..."
git clone https://github.com/RaulSanchezzt/auto-bspwm.git ~/auto-bspwm
cd ~/auto-bspwm
sudo chmod +x setup.sh
./setup.sh || { echo "(Error) Falló la instalación de auto-bspwm"; exit 1; }
sudo cd "$HOME"

echo
echo "==> Clonando repositorio de dotfiles y aplicando configuración..."
# Si se dispone de un repositorio de dotfiles para configurar el entorno (por ejemplo, configuración de bspwm, polybar, etc.)
if [ -n "$DOTFILES_REPO" ]; then
    git clone "$DOTFILES_REPO" ~/dotfiles
else
    git clone https://github.com/RaulSanchezzt/dotfiles.git ~/dotfiles
fi
cd ~/dotfiles && chmod +x link.sh && ./link.sh || echo "(Aviso) No se ejecutó link.sh de dotfiles"
cd "$HOME"

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
echo "==> Configuración inicial completa. Reiniciando el sistema para proceder a Fase 5..."
sudo systemctl enable autologin.service
sudo systemctl set-default multi-user.target
echo "...PULSA CUALQUIER TECLA PARA CONTINUAR..."
read -n 1 -s
sudo reboot