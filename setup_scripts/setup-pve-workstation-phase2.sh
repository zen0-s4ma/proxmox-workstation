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
# 1) Instalar paquetes de desarrollo, compilacion y sistema
###############################################################################
echo
echo "==> Instalando paquetes de desarrollo, compilacion y sistema…"
sudo apt install -y \
  dkms build-essential curl git wget python3 python3-pip \
  gcc g++ clang lldb lld golang rustc cargo dpkg gnupg2 \
  apt-transport-https ca-certificates lsof wine rofi htop neofetch \
  tree jq nano vim neovim gedit

###############################################################################
# 1.1) Instalar paquetes de terminales y shells
###############################################################################
echo
echo "==> paquetes de terminales y shellsn…"
sudo apt install -y kitty zsh zsh-syntax-highlighting zsh-autosuggestions  \
  fzf lsd bat coreutils feh procps tty-clock xclip 

###############################################################################
# 2) Instalar paquetes de sonido
###############################################################################
echo
echo "==> Instalando pulseaudio-module-bluetooth…"
sudo apt install --install-recommends -y alsa-utils pulseaudio pulseaudio-module-bluetooth

###############################################################################
# 3) Instalar brave directo al sistema
###############################################################################
#echo
#echo "==> Instalando navegador de terceros: Brave…"
#sudo curl -fsS https://dl.brave.com/install.sh | sh

###############################################################################
# 4) Bluetooth
###############################################################################
echo
echo "==> Instalando herramientas de Bluetooth…"
sudo apt install -y bluez bluetooth bluez-tools rfkill
sudo systemctl restart bluetooth

###############################################################################
# 5) Utilidades de red y USB
###############################################################################
echo
echo "==> Instalando utilidades de red y firmware USB…"
sudo apt install -y net-tools wireless-tools ethtool usbutils dnsutils \
               iputils-ping whois traceroute rsync proxychains

###############################################################################
# 6) Herramientas de archivado
###############################################################################
echo
echo "==> Instalando herramientas de archivado y compactación…"
sudo apt install -y unzip p7zip-full rar unrar zip tar gzip bzip2 xz-utils
             
###############################################################################
# 8) Complementos VMWare
###############################################################################
echo
echo "==> Instalando complementos VMWare…"
sudo apt install -y open-vm-tools open-vm-tools-desktop xserver-xorg-video-vmware

###############################################################################
# 9) Tor
###############################################################################
echo
echo "==> Instalando Tor Launcher…"
sudo apt install -y tor 

###############################################################################
# 9) SSH Y VPN
###############################################################################
echo
echo "==> Instalando ssh y vpn…"
sudo apt install -y openssh-client openssh-server \
  openvpn network-manager-openvpn-gnome \
  wireguard wireguard-tools gnome-keyring

###############################################################################
# 10) Instalar Ollama (IA local)
###############################################################################
#echo
#echo "==> Instalacion de IA  (Ollama)..."
#if ! command -v ollama >/dev/null 2>&1; then
#  echo "==> Instalando Ollama..."
#  curl -fsSL https://ollama.com/install.sh | sh
#fi
#if ! ollama list | grep -q "gemma3:1b"; then
#  echo "==> Descargando modelo gemma3:1b..."
#  ollama pull gemma3:1b
#fi
#export OLLAMA_KEEP_ALIVE="-1"
#echo "==> Variable OLLAMA_KEEP_ALIVE fijada a $OLLAMA_KEEP_ALIVE"

###############################################################################
# 12) Instalar Flatpak y aplicaciones
###############################################################################
echo
echo "==> Instalando Flatpak..."
sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

APPS=(
    org.dupot.easyflatpak
    org.videolan.VLC
    org.mozilla.Thunderbird
    org.torproject.torbrowser-launcher
    org.cubocore.CorePDF
    io.github.shiftey.Desktop
    net.mullvad.MullvadBrowser
    org.jdownloader.JDownloader
    com.visualstudio.code
    xyz.ketok.Speedtest
    tv.kodi.Kodi
    org.keepassxc.KeePassXC
    org.mozilla.firefox
    com.google.Chrome
    io.gitlab.librewolf-community
    com.github.sdv43.whaler
    io.github.ebonjaeger.bluejay
    io.emeric.toolblex
)

for app in "${APPS[@]}"; do
    flatpak install --or-update --system -y flathub "$app"
done

###############################################################################
# 13) Instalar Docker CE y componer entorno de contenedores
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
sudo apt update
echo "==> Finalizando: upgrade…"
sudo apt upgrade -y
echo "==> Finalizando: full-upgrade…"
sudo apt full-upgrade -y
echo "==> Finalizando: autoremove…"
sudo apt autoremove -y
echo "==> Finalizando: autoclean…"
sudo apt autoclean -y
echo
echo "==> Revisando dependencias…"
sudo dpkg --configure -a
sudo apt install -f -y

###############################################################################
# 99.a) Actualizacion del .bash_profile para lanzar la siguiente fase
###############################################################################
echo
echo "==> Actualizacion del .bash_profile…"
USER_HOME=$(eval echo "~$USER_NAME")
cp -f /opt/pve-setup/bash_profiles_phase3 "$USER_HOME/.bash_profile"
sudo chown "$USER_NAME:$USER_NAME" /home/$USER_NAME/.bash_profile
sudo chmod 644 /home/$USER_NAME/.bash_profile
echo "==> .bash_profile Actualizado para lanzar la fase 3…"

##############################################################################
# 99.b) Reinicio
###############################################################################
echo
echo "==> Configuración inicial completa. Reiniciando el sistema en modo tty para proceder a Fase 3..."

echo
echo "...FIN DE PHASE 2 - PULSA CUALQUIER TECLA PARA CONTINUAR..."
#read -n 1 -s
sudo reboot