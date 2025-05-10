#!/bin/bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Primero: hacer backup y escribir ficheros cruciales con el contenido exacto
# -----------------------------------------------------------------------------

backup_and_write() {
  local file="$1"
  local content_block="$2"

  # Crear directorio si no existe
  mkdir -p "$(dirname "$file")"

  # Backup: machacar si existe
  if [[ -e "$file" ]]; then
    cp -f "$file" "${file}.bak"
    echo "[Backup] $file -> ${file}.bak"
  fi

  # Escribir contenido
  cat > "$file" << 'EOF'
${content_block}
EOF
  echo "[Write] $file"
}

# Contenido para /etc/apt/sources.list
read -r -d '' SOURCES_LIST << 'EOL'
# repositorios
deb http://deb.debian.org/debian bookworm main contrib non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free-firmware
deb http://deb.debian.org/debian bookworm-backports main contrib non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main contrib non-free-firmware
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription
EOL

# Contenido para /etc/apt/sources.list.d/ceph.list
read -r -d '' CEPH_LIST << 'EOL'
# deb https://enterprise.proxmox.com/debian/ceph-quincy bookworm enterprise
EOL

# Contenido para /etc/apt/sources.list.d/pve-enterprise.list
read -r -d '' PVE_ENTERPRISE_LIST << 'EOL'
# deb https://enterprise.proxmox.com/debian/pve bookworm pve-enterprise
EOL

# Contenido para /etc/resolv.conf
read -r -d '' RESOLV_CONF << 'EOL'
nameserver 8.8.8.8
nameserver 1.1.1.1
EOL

# Contenido para /etc/network/interfaces
read -r -d '' NETWORK_INTERFACES << 'EOL'
auto lo
iface lo inet loopback

allow-hotplug ens33
allow-hotplug enp4s0
iface ens33 inet manual
iface enp4s0 inet manual

auto vmbr0
iface vmbr0 inet static
    address 192.168.1.199/24
    gateway 192.168.1.1
    bridge-ports ens33 enp4s0
    bridge-stp off
    bridge-fd 0
    dns-nameservers 8.8.8.8 1.1.1.1

source /etc/network/interfaces.d/*
EOL

# Ejecutar backups y escrituras
backup_and_write "/etc/apt/sources.list" "${SOURCES_LIST}"
backup_and_write "/etc/apt/sources.list.d/ceph.list" "${CEPH_LIST}"
backup_and_write "/etc/apt/sources.list.d/pve-enterprise.list" "${PVE_ENTERPRISE_LIST}"
backup_and_write "/etc/resolv.conf" "${RESOLV_CONF}"
backup_and_write "/etc/network/interfaces" "${NETWORK_INTERFACES}"

# -----------------------------------------------------------------------------
# Script original continúa a continuación…
# -----------------------------------------------------------------------------

# 1) Actualizar sistema base y kernel Proxmox VE
echo "==> Actualizando sistema base y kernel…"
apt update\apt full-upgrade -y

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
  usbutils \
  firmware-realtek

echo "Instalando driver Realtek AWUS036ACS (RTL88xxAU)…"
apt install -y realtek-rtl88xxau-dkms

echo "Instalando NVIDIA…"
apt install -y nvidia-smi

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

# 3) Actualización y limpieza final
echo "==> Actualización final y limpieza…"
apt update               # refrescar índices 
apt upgrade -y           # instalar actualizaciones sin cambiar dependencias 
apt full-upgrade -y      # instalar actualizaciones que requieran cambios en dependencias 
apt autoremove -y        # eliminar paquetes huérfanos 
apt autoclean -y         # limpiar caché de paquetes descargados 

echo "==> ¡Sistema Proxmox Workstation configurado y listo!"
