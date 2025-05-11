#!/bin/bash
set -e

echo "==> $(id -un): Iniciando Script…"

USER_NAME="zenosama"
USER_PASS="zenosama"

#########################################################################
# 1) Copiar ficheros de configuración
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
# 2) Reiniciar red
#########################################################################
echo
echo "==> [root] Reiniciando la interfaz de red…"
systemctl restart networking

###############################################################################
# 3) Actualizar sistema base y kernel Proxmox VE
###############################################################################
echo
echo "==> Instalando Sudo y ZSH…"
apt update
apt install -y zsh

###############################################################################
# 4) Instalacion de SUDO, creacion de usuario y permisos
###############################################################################
if [[ $EUID -eq 0 && -z "${RUN_AS_ZENO:-}" ]]; then
  echo "==> [root] Instalando sudo…"
  if ! command -v sudo &>/dev/null; then
    apt update -qq
    apt install -y sudo
  fi
  useradd -m -s /usr/bin/zsh -G sudo "$(id -un)"
  echo "==> [root] Creando usuario '$USER_NAME'…"
  if ! id -u "$USER_NAME" &>/dev/null; then
    useradd -m -s /usr/bin/zsh -G sudo "$USER_NAME"
    echo "$USER_NAME:$USER_PASS" | chpasswd
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" \
         > /etc/sudoers.d/99-$USER_NAME-nopasswd
    chmod 0440 /etc/sudoers.d/99-$USER_NAME-nopasswd
  fi
fi
###############################################################################
# 5) Agregar Repositorios de kali
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

###############################################################################
# 1) Actualizar sistema base y kernel Proxmox VE
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
# 6) Comprobaciones
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
# 7) Copiando scripts y servicios
###############################################################################
echo
echo "==> Copiando scripts de instalacion..."
cp -f ./setup_scripts/setup-pve-workstation-phase2.sh /opt/pve-setup/setup-pve-workstation-phase2.sh
cp -f ./setup_scripts/setup-pve-workstation-phase3.sh /opt/pve-setup/setup-pve-workstation-phase3.sh
cp -f ./setup_scripts/setup-pve-workstation-phase4.sh /opt/pve-setup/setup-pve-workstation-phase4.sh
cp -f ./setup_scripts/setup-pve-workstation-phase5.sh /opt/pve-setup/setup-pve-workstation-phase5.sh

echo
echo "==> Copiando servicios de instalacion..."
cp -f ./temp_services/phase2-service /opt/pve-setup/phase2-service
cp -f ./temp_services/phase3-service /opt/pve-setup/phase3-service
cp -f ./temp_services/phase4-service /opt/pve-setup/phase4-service
cp -f ./temp_services/phase5-service /opt/pve-setup/phase5-service

###############################################################################
# 99.a) Creando servicio para el proximo reinicio
###############################################################################
echo
echo "==> Copiando servicio a systemd..."
cp -f /opt/pve-setup/phase2-service /etc/systemd/system/phase2.service
systemctl daemon-reload
systemctl enable phase2.service

###############################################################################
# 99.b) Reinicio
###############################################################################
echo "==> Configuración inicial completa. Reiniciando el sistema para proceder a Fase 2..."
reboot
