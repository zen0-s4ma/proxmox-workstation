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
  usbutils \
  firmware-realtek

echo "Instalando driver Realtek AWUS036ACS (RTL88xxAU)…"
apt install -y realtek-rtl88xxau-dkms

echo "Instalando controladores NVIDIA y CUDA…"
apt install -y \
  nvidia-driver \
  nvidia-cuda-toolkit \
  linux-headers-$(uname -r)

echo "Instalando LightDM como gestor de inicio de sesión…"
apt install -y lightdm 

echo "Instalando entornos de escritorio (GNOME, KDE, Cinnamon, XFCE)…"
apt install -y \
  task-gnome-desktop \
  task-kde-desktop \
  task-cinnamon-desktop \
  task-xfce-desktop

# 3) Segunda ronda de actualización y limpieza final
echo "==> Actualización final y limpieza…"
apt update               # refrescar índices 
apt upgrade -y           # instalar actualizaciones sin cambiar dependencias 
apt full-upgrade -y      # instalar actualizaciones que requieran cambios en dependencias 
apt autoremove -y        # eliminar paquetes huérfanos 
apt autoclean -y         # limpiar caché de paquetes descargados 

echo "==> ¡Sistema Proxmox Workstation configurado y limpio!"
