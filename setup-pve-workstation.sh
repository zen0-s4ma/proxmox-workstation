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

# -----------------------------------------------------------------------------
# 0.1) Reiniciar interfaz de red 
# -----------------------------------------------------------------------------
systemctl restart networking

# -----------------------------------------------------------------------------
# 1) Actualizar sistema base y kernel Proxmox VE
# -----------------------------------------------------------------------------
echo
echo "==> Actualizando sistema base y kernel…"
apt update
apt full-upgrade -y

# -----------------------------------------------------------------------------
# 2) Instalar paquetes de desarrollo y compilación
# -----------------------------------------------------------------------------
echo
echo "==> Instalando paquetes de desarrollo y compilación…"
apt install -y \
  dkms \
  build-essential \
  curl \
  zsh \
  git \
  wget \
  python3 \
  python3-pip \
  gcc \
  g++ \
  clang \
  lldb \
  lld \
  golang \
  rustc \
  cargo \
  dpkg \
  gnupg2 \
  apt-transport-https \
  ca-certificates

# -----------------------------------------------------------------------------
# 3) Actualizar headers de Proxmox
# -----------------------------------------------------------------------------
echo
echo "==> Actualizando headers…"
apt install -y pve-headers-$(uname -r)

# -----------------------------------------------------------------------------
# 4) Instalar navegador y editores
# -----------------------------------------------------------------------------
echo
echo "==> Instalando navegador y editores…"
apt install -y \
  firefox-esr \
  nano \
  vim \
  neovim \
  gedit

echo
echo "==> Instalando navegador de terceros: Brave…"
curl -fsS https://dl.brave.com/install.sh | sh

# -----------------------------------------------------------------------------
# 5) Instalando herramientas de Bluetooth
# -----------------------------------------------------------------------------
echo
echo "==> Instalando herramientas de Bluetooth…"
apt install -y \
  bluez \
  bluetooth \
  bluez-tools \
  rfkill

# -----------------------------------------------------------------------------
# 6) Instalando utilidades de red y firmware USB
# -----------------------------------------------------------------------------
echo
echo "==> Instalando utilidades de red y firmware USB…"
apt install -y \
  net-tools \
  wireless-tools \
  ethtool \
  usbutils \
  dnsutils \
  iputils-ping \
  whois \
  traceroute \
  rsync

# -----------------------------------------------------------------------------
# 7) Instalando herramientas de archivado y compactación
# -----------------------------------------------------------------------------
echo
echo "==> Instalando herramientas de archivado y compactación…"
apt install -y \
  unzip \
  p7zip-full \
  rar \
  unrar \
  zip \
  tar \
  gzip \
  bzip2 \
  xz-utils

# -----------------------------------------------------------------------------
# 8) Instalando utilidades de sistema adicionales
# -----------------------------------------------------------------------------
echo
echo "==> Instalando utilidades de sistema adicionales…"
apt install -y \
  htop \
  neofetch \
  tree \
  jq \
  xclip \
  lsof

# -----------------------------------------------------------------------------
# 9) Instalando NVIDIA
# -----------------------------------------------------------------------------
echo
echo "==> Instalando NVIDIA…"
apt install -y nvidia-driver

# -----------------------------------------------------------------------------
# 10) Instalando LightDM como gestor de inicio de sesión
# -----------------------------------------------------------------------------
echo
echo "==> Instalando LightDM como gestor de inicio de sesión…"
apt install -y lightdm

# -----------------------------------------------------------------------------
# 11) Instalando entornos de escritorio XFCE4 y Cinnamon
# -----------------------------------------------------------------------------
echo
echo "==> Instalando entornos de escritorio…"
apt install -y \
  dbus-x11 \
  x11-xserver-utils \
  xinit \
  xfce4 \
  xfce4-goodies \
  thunar-archive-plugin \
  gvfs-backends \
  libxapp-gtk3-module \
  cinnamon

# -----------------------------------------------------------------------------
# 12) Instalando complementos VMWare
# -----------------------------------------------------------------------------
echo
echo "==> Instalando complementos VMWare…"
apt install -y \
  open-vm-tools \
  open-vm-tools-desktop \
  xserver-xorg-video-vmware \
  gnome-software 

# -----------------------------------------------------------------------------
# 13) Instalando Flatpak, Tor y herramientas de anonimato
# -----------------------------------------------------------------------------
echo
echo "==> Instalando Tor y Tor Browser Launcher…"
apt install -y \
  tor \
  torbrowser-launcher  

# -----------------------------------------------------------------------------
# 14) Segunda ronda de actualización y limpieza final
# -----------------------------------------------------------------------------
echo
echo "==> Finalizando: update…"
apt update               # refrescar índices 

echo
echo "==> Finalizando: upgrade…"
apt upgrade -y           # instalar actualizaciones sin cambiar dependencias 

echo
echo "==> Finalizando: full-upgrade…"
apt full-upgrade -y      # instalar actualizaciones que requieran cambios en dependencias 

echo
echo "==> Finalizando: autoremove…"
apt autoremove -y        # eliminar paquetes huérfanos 

echo
echo "==> Finalizando: autoclean…"
apt autoclean -y         # limpiar caché de paquetes descargados 

echo
echo "==> Finalizando: revisando dependencias y paquetes…"
dpkg --configure -a
apt install -f -y

echo
echo "==> ¡Sistema Proxmox Workstation configurado y listo!"
echo
