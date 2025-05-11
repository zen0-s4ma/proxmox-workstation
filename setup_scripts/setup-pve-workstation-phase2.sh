#!/bin/bash
set -e

echo "==> Iniciando Script Fase 2…"

USER_NAME="zenosama"

###############################################################################
# 0) Comprobacion de usuario, que no sea el root
###############################################################################
echo
echo "==> Comprobando si el usuario es $USER_NAME…"
if [[ $(id -un) != "$USER_NAME" ]]; then
  echo "Error: este bloque debe ejecutarse como $USER_NAME" >&2
  exit 1
fi

###############################################################################
# 1) Instalar paquetes de desarrollo y compilación
###############################################################################
echo
echo "==> Instalando paquetes de desarrollo y compilación…"
apt install -y \
  dkms build-essential curl zsh git wget python3 python3-pip \
  gcc g++ clang lldb lld golang rustc cargo dpkg gnupg2 \
  apt-transport-https ca-certificates kitty xfce4-terminal
  
if [[ -x /usr/bin/zsh ]]; then
  echo "==> Estableciendo zsh como shell por defecto para ${USER_NAME}…"
  sudo usermod -s /usr/bin/zsh "$USER_NAME"
fi

configured_shell=$(getent passwd "$USER_NAME" | cut -d: -f7)
running_shell=$(ps -p $$ -o comm=)
echo "==> Shell de inicio configurada para ${USER_NAME}: ${configured_shell}"
echo "==> Shell con la que se está ejecutando el script: ${running_shell}"

###############################################################################
# 2) Instalar navegador y editores
###############################################################################
echo
echo "==> Instalando navegador y editores…"
apt install -y firefox-esr nano vim neovim gedit

echo
echo "==> Instalando navegador de terceros: Brave…"
curl -fsS https://dl.brave.com/install.sh | sh

###############################################################################
# 3) Bluetooth
###############################################################################
echo
echo "==> Instalando herramientas de Bluetooth…"
apt install -y bluez bluetooth bluez-tools rfkill

###############################################################################
# 4) Utilidades de red y USB
###############################################################################
echo
echo "==> Instalando utilidades de red y firmware USB…"
apt install -y net-tools wireless-tools ethtool usbutils dnsutils \
               iputils-ping whois traceroute rsync

###############################################################################
# 5) Herramientas de archivado
###############################################################################
echo
echo "==> Instalando herramientas de archivado y compactación…"
apt install -y unzip p7zip-full rar unrar zip tar gzip bzip2 xz-utils

###############################################################################
# 6) Utilidades de sistema
###############################################################################
echo
echo "==> Instalando utilidades de sistema adicionales…"
apt install -y htop neofetch tree jq xclip lsof
             
###############################################################################
# 7) Complementos VMWare
###############################################################################
echo
echo "==> Instalando complementos VMWare…"
apt install -y open-vm-tools open-vm-tools-desktop xserver-xorg-video-vmware gnome-software

###############################################################################
# 8) Tor, TorBrowser y Proxychains
###############################################################################
echo
echo "==> Instalando Tor y Tor Browser Launcher…"
apt install -y tor torbrowser-launcher proxychains

###############################################################################
# 9) Instalar Ollama (IA local)
###############################################################################
echo
echo "==> Instalando Ollama (IA local)..."
curl -fsSL https://ollama.com/install.sh | sudo bash

###############################################################################
# 10) Instalar Docker CE y componer entorno de contenedores
###############################################################################
echo
echo "==> Instalando Docker Engine y herramientas..."
# Añadir clave y repo de Docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/debian \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Instalar Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Añadir usuario al grupo docker
sudo usermod -aG docker $USER_NAME

###############################################################################
# 99) Limpieza final
###############################################################################
echo
echo "==> Finalizando: update…"
apt update
echo "==> Finalizando: upgrade…"
apt upgrade -y
echo "==> Finalizando: full-upgrade…"
apt full-upgrade -y
echo "==> Finalizando: autoremove…"
apt autoremove -y
echo "==> Finalizando: autoclean…"
apt autoclean -y
echo
echo "==> Revisando dependencias…"
sudo dpkg --configure -a
apt install -f -y

###############################################################################
# 99.a) Creando servicio para el proximo reinicio
###############################################################################
echo
echo "==> Copiando servicio a systemd..."
cp -f /opt/pve-setup/phase3.service /etc/systemd/system/phase3.service
systemctl daemon-reload
systemctl enable phase3.service

###############################################################################
# 99.b) Reinicio
###############################################################################
echo "==> Configuración inicial completa. Reiniciando el sistema para proceder a Fase 3..."
reboot


