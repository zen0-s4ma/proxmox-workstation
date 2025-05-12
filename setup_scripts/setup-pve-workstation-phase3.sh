#!/bin/bash
set -e

echo "==> Iniciando Script Fase 3…"

USER_NAME="zenosama"

###############################################################################
# 1) NVIDIA
###############################################################################
echo
echo "==> Instalando NVIDIA…"
sudo apt install -y nvidia-driver

###############################################################################
# 2) Escritorios, temas e iconos) y gestor LightDM
###############################################################################
echo
echo "==> Instalando LightDM…"
sudo apt install -y lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings arctica-greeter 
echo
echo "==> Instalando servidor grafico…"
sudo apt install -y dbus-x11 x11-xserver-utils xinit xorg
echo
echo "==> Instalando Xfce4…"
sudo apt install -y desktop-base xfce4 xfce4-goodies
echo
echo "==> Instalando Cinnamon…"
sudo apt install -y cinnamon cinnamon-desktop-environment cinnamon-control-center cinnamon-screensaver nemo nemo-fileroller \
               gnome-screenshot gnome-keyring network-manager-gnome
echo
echo "==> Instalando Budgie…"
sudo apt install -y budgie-desktop budgie-core
echo
echo "==> Instalando Mate…"
sudo apt install -y mate-desktop-environment mate-desktop-environment-extras


###############################################################################
# 99.a) Actualizacion del .bash_profile para lanzar la siguiente fase
###############################################################################
echo
echo "==> Actualizacion del .bash_profile…"
USER_HOME=$(eval echo "~$USER_NAME")
cp -f /opt/pve-setup/bash_profiles_phase4 "$USER_HOME/.bash_profile"
sudo chown "$USER_NAME:$USER_NAME" /home/$USER_NAME/.bash_profile
sudo chmod 644 /home/$USER_NAME/.bash_profile
echo "==> .bash_profile Actualizado para lanzar la fase 4…"

##############################################################################
# 99.b) Reinicio
###############################################################################
echo
echo "==> Configuración inicial completa. Reiniciando el sistema para proceder a Fase 4..."
sudo systemctl enable autologin.service
sudo systemctl set-default multi-user.target

#echo "...FIN DE PHASE 3 - PULSA CUALQUIER TECLA PARA CONTINUAR..."
#read -n 1 -s
sudo reboot