#!/bin/bash
set -e

echo "==> $(id -un): Iniciando Script…"

USER_NAME="zenosama"
USER_PASS="zenosama"

#########################################################################
# 1) Copiar ficheros de configuración
#########################################################################
mkdir -p /opt/pve-setup
echo
echo "==> Creando bakups de los ficheros de configuracion..."
cp -f /etc/apt/sources.list.d/ceph.list /etc/apt/sources.list.d/ceph.list.bak
cp -f /etc/network/interfaces /etc/network/interfaces.bak
cp -f /etc/resolv.conf /etc/resolv.conf.bak
cp -f /etc/apt/sources.list /etc/apt/sources.list.bak

echo
echo "==> Copiando ficheros de configuracion..."
cp -f ./config_files/ceph.list /etc/apt/sources.list.d/ceph.list
cp -f ./config_files/interfaces /etc/network/interfaces
cp -f ./config_files/resolv.conf /etc/resolv.conf
cp -f ./config_files/sources.list /etc/apt/sources.list

echo
echo "==> Copiando scripts de instalacion..."
cp -f ./setup_scripts/setup-pve-workstation-phase2.sh /opt/pve-setup/setup-pve-workstation-phase2.sh
cp -f ./setup_scripts/setup-pve-workstation-phase3.sh /opt/pve-setup/setup-pve-workstation-phase3.sh
cp -f ./setup_scripts/setup-pve-workstation-phase4.sh /opt/pve-setup/setup-pve-workstation-phase4.sh
cp -f ./setup_scripts/setup-pve-workstation-phase5.sh /opt/pve-setup/setup-pve-workstation-phase5.sh

echo
echo "==> Dando permisos de ejecucion a los scripts..."
chmod +x /opt/pve-setup/setup-pve-workstation-phase2.sh
chmod +x /opt/pve-setup/setup-pve-workstation-phase3.sh
chmod +x /opt/pve-setup/setup-pve-workstation-phase4.sh
chmod +x /opt/pve-setup/setup-pve-workstation-phase5.sh

echo
echo "==> Copiando servicios de instalacion..."
cp -f ./temp_services/phase2.service /opt/pve-setup/phase2.service
cp -f ./temp_services/phase3.service /opt/pve-setup/phase3.service
cp -f ./temp_services/phase4.service /opt/pve-setup/phase4.service
cp -f ./temp_services/phase5.service /opt/pve-setup/phase5.service

###############################################################################
# 2) Agregar Repositorios de kali
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

#########################################################################
# 3) Reiniciar red
#########################################################################
echo
echo "==> [root] Reiniciando la interfaz de red…"
systemctl restart networking

###############################################################################
# 4) Actualizar sistema base y kernel Proxmox VE
###############################################################################
echo
echo "==> Instalando Sudo y ZSH…"
apt update
apt install -y zsh

###############################################################################
# 5) Instalacion de SUDO, creacion de usuario y permisos
###############################################################################
if [[ $EUID -eq 0 && -z "${RUN_AS_ZENO:-}" ]]; then
  echo
  echo "==> [root] Instalando sudo…"
  if ! command -v sudo &>/dev/null; then
    apt update -qq
    apt install -y sudo
    useradd -m -s /usr/bin/zsh -G sudo "$(id -un)"
  fi
  
  echo
  echo "==> [root] Creando usuario '$USER_NAME'…"
  if ! id -u "$USER_NAME" &>/dev/null; then
    useradd -m -s /usr/bin/zsh -G sudo "$USER_NAME"
    echo "$USER_NAME:$USER_PASS" | chpasswd
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" \
         > /etc/sudoers.d/99-$USER_NAME-nopasswd
    chmod 0440 /etc/sudoers.d/99-$USER_NAME-nopasswd
  fi
fi

echo
echo "==> Copiando servicios de instalacion al usuario $USER_NAME..."
mkdir -p /home/$USER_NAME/.config/systemd/user
chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.config/systemd
cp -f ./temp_services/phase2.service /home/$USER_NAME/.config/systemd/user/phase2.service
cp -f ./temp_services/phase3.service /home/$USER_NAME/.config/systemd/user/phase3.service
cp -f ./temp_services/phase4.service /home/$USER_NAME/.config/systemd/user/phase4.service
cp -f ./temp_services/phase5.service /home/$USER_NAME/.config/systemd/user/phase5.service

###############################################################################
# 6) Actualizar sistema base y kernel Proxmox VE
###############################################################################
echo
echo "==> [${USER_NAME}] Actualizando: update…"
apt update
echo
echo "==> [${USER_NAME}] Actualizando: upgrade"
apt upgrade -y
echo
echo "==> [${USER_NAME}] Actualizando: full-upgrade"
apt full-upgrade -y
echo
echo "==> [${USER_NAME}] Actualizando: pve-headers"
apt install -y pve-headers

###############################################################################
# 7) Comprobaciones
###############################################################################
echo "==> Comprobacion de variables…"
echo "==> Usuario actual: $(id -un)"
echo "==> Usuario creado: $USER_NAME"
echo "==> Home actual: $HOME"
echo "==> Path: $(pwd)"
cd "$HOME"
echo "==> Path Actualizado: $(pwd)"
echo "==> Shell Actual: $SHELL"

###############################################################################
# 99.a) Creando servicio para el proximo reinicio
###############################################################################
echo
echo "==> Copiando servicio a systemd..."
cp -f /opt/pve-setup/phase2.service /etc/systemd/system/phase2.service

echo "==> Configurando inicio de servicios para el usuario $USER_NAME..."

# Habilitar linger para que los servicios del usuario puedan ejecutarse sin sesión activa
loginctl enable-linger $USER_NAME

# Definir XDG_RUNTIME_DIR y recargar systemd para el usuario
USER_ID=$(id -u $USER_NAME)
export XDG_RUNTIME_DIR="/run/user/$USER_ID"

sudo -u $USER_NAME XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR systemctl --user daemon-reload
sudo -u $USER_NAME XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR systemctl --user enable phase2.service

###############################################################################
# 99.b) Reinicio
###############################################################################
echo "==> Configuración inicial completa. Reiniciando el sistema para proceder a Fase 2..."
read -n 1 -s
sudo reboot