#!/bin/bash
set -euo pipefail

# 1) Actualizar sistema base y kernel Proxmox VE
echo "==> Actualizando sistema base y kernel…"
apt update
apt full-upgrade -y

# 2) Instala herramientas
echo "Instalando paquetes de desarrollo y compilación…"
apt install -y \
  dkms \
  build-essential \
  curl \
  zsh

echo "Actualizando headers…"
apt install -y pve-headers-$(uname -r)

echo "Instalando navegador Firefox ESR…"
apt install -y firefox-esr

echo "Instalando herramientas de Bluetooth…"
apt install -y \
  bluez \
  bluetooth \
  bluez-tools \
  rfkill

echo "Instalando utilidades de red y firmware USB…"
apt install -y \
  net-tools \
  wireless-tools \
  ethtool \
  usbutils 

echo "Instalando NVIDIA…"
apt install -y nvidia-driver

echo "Instalando LightDM como gestor de inicio de sesión…"
apt install -y lightdm 

echo "Instalando entornos de escritorio…"
apt install -y \
  dbus-x11 \
  x11-xserver-utils \
  xinit \
  xfce4 \
  xfce4-goodies \
  thunar-archive-plugin gvfs-backends
  
echo "Instalando complementos VMWare…"
apt install -y \
  open-vm-tools \
  open-vm-tools-desktop \
  xserver-xorg-video-vmware

# 3) Segunda ronda de actualización y limpieza final
echo "==> Actualización final y limpieza…"
apt update               # refrescar índices 
apt upgrade -y           # instalar actualizaciones sin cambiar dependencias 
apt full-upgrade -y      # instalar actualizaciones que requieran cambios en dependencias 
apt autoremove -y        # eliminar paquetes huérfanos 
apt autoclean -y         # limpiar caché de paquetes descargados 

echo "==> ¡Sistema Proxmox Workstation configurado y listo!"
