#!/bin/bash
set -e

echo "==> Iniciando Script Fase 3…"

USER_NAME="zenosama"

###############################################################################
# 1) NVIDIA
###############################################################################
echo
echo "==> Instalando NVIDIA…"
echo
sudo apt install -y nvidia-driver

###############################################################################
# 2) Escritorios, temas e iconos) y gestor LightDM
###############################################################################
echo
echo "==> Instalando LightDM…"
sudo apt install -y lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings 

echo
echo "==> Instalando servidor grafico…"
sudo apt install -y x11-xserver-utils xinit dbus-x11

echo
echo "==> Instalando Desktop-base…"
sudo apt install -y desktop-base 

echo
echo "==> Instalando Xfce4…"
sudo apt install -y xfce4 xfce4-goodies

#echo
#echo "==> Instalando Cinnamon…"
#sudo apt install -y --install-recommends cinnamon-desktop-environment

#echo
#echo "==> Agregando arte y customizacion"
#sudo apt install -y --install-recommends gnome-backgrounds mate-backgrounds plasma-wallpapers-addons ukui-wallpapers lomiri-wallpapers \
#  plymouth-themes numix-gtk-theme numix-icon-theme numix-icon-theme-circle orchis-gtk-theme \
#  materia-gtk-theme arc-theme breeze-gtk-theme papirus-icon-theme paper-icon-theme adwaita-icon-theme fonts-cantarell

echo
echo "==> Instalando complementos restantes"
sudo apt install -y --install-recommends network-manager gvfs-backends gvfs-fuse freetuxtv backintime-qt

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
echo "==> Reiniciando el sistema en modo tty para proceder a Fase 4..."

echo
echo "...FIN DE PHASE 3 - PULSA CUALQUIER TECLA PARA CONTINUAR..."
#read -n 1 -s
sudo reboot