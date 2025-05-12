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
sudo apt install -y lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings arctica-greeter arctica-greeter-theme-debian
echo
echo "==> Instalando servidor grafico…"
sudo apt install -y dbus-x11 x11-xserver-utils xinit
echo
echo "==> Instalando Xfce4…"
sudo apt install -y xfce4 xfce4-goodies xfce4-whiskermenu-plugin xfce4-screenshooter xfce4-taskmanager xfce4-power-manager \
               thunar-archive-plugin thunar-volman gvfs-backends xfce4-genmon-plugin xfce4-weather-plugin \
               xfce4-pulseaudio-plugin xfce4-netload-plugin xfce4-cpugraph-plugin xfce4-battery-plugin ristretto \
               tumbler gvfs-fuse
echo
sudo apt install -y arc-theme papirus-icon-theme numix-gtk-theme numix-icon-theme-circle materia-gtk-theme orchis-gtk-theme \
               breeze-icon-theme gnome-icon-theme oxygen-icon-theme

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

#### PARADA TEMPORAL PARA DEBUG ###
echo "==> PREPARANDO PARADA TEMPORAL PARA PROXIMO REINCIO…"
USER_HOME=$(eval echo "~$USER_NAME")
: > "$USER_HOME/.bash_profile"

##############################################################################
# 99.b) Reinicio
###############################################################################
echo
echo "==> Configuración inicial completa. Reiniciando el sistema para proceder a Fase 4..."
echo "...PULSA CUALQUIER TECLA PARA CONTINUAR..."
read -n 1 -s
sudo reboot