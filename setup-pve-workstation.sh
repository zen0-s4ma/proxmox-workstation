#!/bin/bash
set -euo pipefail

# -----------------------------------------------------------------------------
# 0) Copiar ficheros de config_files con backup .bak
# -----------------------------------------------------------------------------
# Define un array de archivos a copiar y sus destinos
declare -A files=(
  ["sources.list"]="/etc/apt/sources.list"
  ["ceph.list"]="/etc/apt/sources.list.d/ceph.list"
  ["pve-enterprise.list"]="/etc/apt/sources.list.d/pve-enterprise.list"
  ["resolv.conf"]="/etc/resolv.conf"
  ["interfaces"]="/etc/network/interfaces"
)

echo
echo "==> Copiando ficheros de configuracion y realizando backups…"
for name in "${!files[@]}"; do
  src="config_files/$name"
  dst="${files[$name]}"

  if [[ -f "$dst" ]]; then
    cp -f "$dst" "${dst}.bak"
    echo "[Backup] $dst -> ${dst}.bak"
  fi
  cp -f "$src" "$dst"
  echo "[Copy] $src -> $dst"
done

# 1) Actualizar sistema base y kernel Proxmox VE
echo
echo "==> Actualizando sistema base y kernel…"
apt update
apt full-upgrade -y

# 2) Instala herramientas
echo
echo "==> Instalando paquetes de desarrollo y compilación…"
apt install -y \
  dkms \
  build-essential \
  curl \
  zsh

echo
echo "==> Actualizando headers…"
apt install -y pve-headers-$(uname -r)

echo
echo "==> Instalando navegador Firefox ESR…"
apt install -y firefox-esr

echo
echo "==> Instalando herramientas de Bluetooth…"
apt install -y \
  bluez \
  bluetooth \
  bluez-tools \
  rfkill

echo
echo "==> Instalando utilidades de red y firmware USB…"
apt install -y \
  net-tools \
  wireless-tools \
  ethtool \
  usbutils

echo  
echo "==> Instalando NVIDIA…"
apt install -y nvidia-driver

echo
echo "==> Instalando LightDM como gestor de inicio de sesión…"
apt install -y lightdm

echo
echo "==> Instalando entornos de escritorio…"
apt install -y \
  dbus-x11 \
  x11-xserver-utils \
  xinit \
  xfce4 \
  xfce4-goodies \
  thunar-archive-plugin gvfs-backends

echo  
echo "==> Instalando complementos VMWare…"
apt install -y \
  open-vm-tools \
  open-vm-tools-desktop \
  xserver-xorg-video-vmware

# 3) Segunda ronda de actualización y limpieza final
echo
echo "==> Actualización final y limpieza…"
apt update               # refrescar índices 
apt upgrade -y           # instalar actualizaciones sin cambiar dependencias 
apt full-upgrade -y      # instalar actualizaciones que requieran cambios en dependencias 
apt autoremove -y        # eliminar paquetes huérfanos 
apt autoclean -y         # limpiar caché de paquetes descargados 

echo
echo "==> ¡Sistema Proxmox Workstation configurado y listo!"
echo
