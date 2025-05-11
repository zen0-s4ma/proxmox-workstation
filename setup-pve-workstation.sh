#!/bin/bash
set -euo pipefail
shopt -s expand_aliases   # para que los alias funcionen en scripts

echo "==> [root] Iniciando Script…"

USER_NAME="zenosito"
USER_PASS="zenoverso"

###############################################################################
# 1ª EJECUCIÓN (root)  →  crea usuario, hace pasos –1 / 0 / 0.1 y relanza
###############################################################################
if [[ $EUID -eq 0 && -z "${RUN_AS_ZENO:-}" ]]; then
  echo "==> [root] Instalando sudo…"
  if ! command -v sudo &>/dev/null; then
    apt update -qq
    apt install -y sudo
  fi

  echo "==> [root] Creando usuario '$USER_NAME'…"
  if ! id -u "$USER_NAME" &>/dev/null; then
    useradd -m -s /bin/bash -G sudo "$USER_NAME"
    echo "$USER_NAME:$USER_PASS" | chpasswd
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" \
         > /etc/sudoers.d/99-$USER_NAME-nopasswd
    chmod 0440 /etc/sudoers.d/99-$USER_NAME-nopasswd
  fi
  
  #########################################################################
  # (0) Copiar ficheros de configuración
  #########################################################################
  declare -A files=(
    ["sources.list"]="/etc/apt/sources.list"
    ["ceph.list"]="/etc/apt/sources.list.d/ceph.list"
    ["pve-enterprise.list"]="/etc/apt/sources.list.d/pve-enterprise.list"
    ["resolv.conf"]="/etc/resolv.conf"
    ["interfaces"]="/etc/network/interfaces"
  )

  echo
  echo "==> [root] Copiando ficheros de configuracion y haciendo backups…"
  for name in "${!files[@]}"; do
    src="config_files/$name"
    dst="${files[$name]}"
    [[ -f "$dst" ]] && { cp -f "$dst" "${dst}.bak"; echo "[Backup] $dst -> ${dst}.bak"; }
    cp -f "$src" "$dst"
    echo "[Copy] $src -> $dst"
  done

  #########################################################################
  # (0.1) Reiniciar red
  #########################################################################
  echo
  echo "==> [root] Reiniciando la interfaz de red…"
  systemctl restart networking

  #########################################################################
  # Re-ejecutar el script como zenosito  →  lo que queda será “paso 1 en adelante”
  #########################################################################
  echo
  echo "==> [root] Relanzando el script como '$USER_NAME'…"
  export RUN_AS_ZENO=1         # marcador para la segunda vuelta
  exec sudo -u "$USER_NAME" -H RUN_AS_ZENO=1 bash "$0" "$@"
fi
###############################################################################
# 2ª EJECUCIÓN  (usuario: zenosito)  →  Comprobaciones previas
###############################################################################

# Comprobación rápida
echo "==> Comprobacion rapida de usuario…"
echo "==> Usuario actual: $(id -un)"
echo "==> Home actual: $HOME"
echo "==> Path: $(pwd)"
cd "$HOME"
echo "==> Path Actualizado: $(pwd)"

if [[ $(id -un) != "$USER_NAME" ]]; then
  echo "Error: este bloque debe ejecutarse como $USER_NAME" >&2
  exit 1
fi

# Aliases que añaden ‘sudo’ donde hace falta
alias apt='sudo apt'
alias systemctl='sudo systemctl'
alias cp='sudo cp'
alias mv='sudo mv'
alias rm='sudo rm'
alias chown='sudo chown'
alias chmod='sudo chmod'

###############################################################################
# 1) Actualizar sistema base y kernel Proxmox VE
###############################################################################
echo
echo "==> [${USER_NAME}] Actualizando sistema base y kernel…"
apt update
apt full-upgrade -y

###############################################################################
# 2) Instalar paquetes de desarrollo y compilación
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
# 3) Actualizar headers de Proxmox
###############################################################################
echo
echo "==> Actualizando headers…"
apt install -y "pve-headers-$(uname -r)"

###############################################################################
# 4) Instalar navegador y editores
###############################################################################
echo
echo "==> Instalando navegador y editores…"
apt install -y firefox-esr nano vim neovim gedit

echo
echo "==> Instalando navegador de terceros: Brave…"
curl -fsS https://dl.brave.com/install.sh | sh

###############################################################################
# 5) Bluetooth
###############################################################################
echo
echo "==> Instalando herramientas de Bluetooth…"
apt install -y bluez bluetooth bluez-tools rfkill

###############################################################################
# 6) Utilidades de red y USB
###############################################################################
echo
echo "==> Instalando utilidades de red y firmware USB…"
apt install -y net-tools wireless-tools ethtool usbutils dnsutils \
               iputils-ping whois traceroute rsync

###############################################################################
# 7) Herramientas de archivado
###############################################################################
echo
echo "==> Instalando herramientas de archivado y compactación…"
apt install -y unzip p7zip-full rar unrar zip tar gzip bzip2 xz-utils

###############################################################################
# 8) Utilidades de sistema
###############################################################################
echo
echo "==> Instalando utilidades de sistema adicionales…"
apt install -y htop neofetch tree jq xclip lsof

###############################################################################
# 9) NVIDIA
###############################################################################
echo
echo "==> Instalando NVIDIA…"
apt install -y nvidia-driver

###############################################################################
# 10) Escritorios, temas e iconos) y gestor LightDM
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
# 11) TRepositorios y paquetes kali
###############################################################################
echo
echo "==> Importando repositorio Kali…"
sudo apt install -y wget gnupg

# clave + repo (pin 50 para no mezclar dependencias)
wget -qO- https://archive.kali.org/archive-key.asc | \
     sudo tee /usr/share/keyrings/kali-archive-keyring.asc
echo "deb [signed-by=/usr/share/keyrings/kali-archive-keyring.asc] \
     http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" | \
     sudo tee /etc/apt/sources.list.d/kali.list
echo -e "Package: *\nPin: release o=Kali\nPin-Priority: 50" | \
     sudo tee /etc/apt/preferences.d/limit-kali

echo "==> Actualizando listas de paquetes con los repositorio de Kali…"
sudo apt update
             
###############################################################################
# 12) Complementos VMWare
###############################################################################
echo
echo "==> Instalando complementos VMWare…"
apt install -y open-vm-tools open-vm-tools-desktop xserver-xorg-video-vmware gnome-software

###############################################################################
# 13) Tor, TorBrowser y Proxychains
###############################################################################
echo
echo "==> Instalando Tor y Tor Browser Launcher…"
apt install -y tor torbrowser-launcher proxychains

###############################################################################
# 14) Limpieza final
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

echo
neofetch
echo
echo "==> ¡Sistema Proxmox Workstation configurado y listo!"
echo

