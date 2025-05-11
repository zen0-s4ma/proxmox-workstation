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
echo "==> Instalando Cinnamon…"
sudo apt install -y cinnamon cinnamon-desktop-environment cinnamon-control-center cinnamon-screensaver nemo nemo-fileroller \
               gnome-screenshot gnome-keyring network-manager-gnome
echo
echo "==> Instalando Budgie…"
sudo apt install -y budgie-desktop budgie-core
echo
echo "==> Instalando Mate…"
sudo apt install -y mate-desktop-environment mate-desktop-environment-extras
echo
sudo apt install -y arc-theme papirus-icon-theme numix-gtk-theme numix-icon-theme-circle materia-gtk-theme orchis-gtk-theme \
               breeze-icon-theme gnome-icon-theme oxygen-icon-theme

###############################################################################
# 3) Habilitar el entorno grafico para el proximo arranque.
###############################################################################
echo
echo "==> [Fase 2] Habilitando inicio gráfico en el arranque (graphical.target)..."
sudo systemctl set-default graphical.target

###############################################################################
# 99.a) Creando servicio para el proximo reinicio
###############################################################################
echo
echo "==> Copiando servicio a systemd..."
sudo cp -f /opt/pve-setup/phase4.service /etc/systemd/system/phase4.service
sudo systemctl daemon-reload
sudo systemctl enable phase4.service

###############################################################################
# 99.b) Reinicio
###############################################################################
echo "==> Configuración inicial completa. Reiniciando el sistema para proceder a Fase 4..."
read -n 1 -s
sudo reboot