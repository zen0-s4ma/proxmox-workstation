#!/bin/bash
set -euo pipefail

# 1) Actualizar sistema base y kernel Proxmox VE
echo "==> Actualizando sistema base y kernel…"
apt update
apt full-upgrade -y

# 2) Instalar Git para clonar repositorios
echo "==> Instalando Git…"
apt install -y git

# 3) Clonar y ejecutar tu script de instalación de paquetes
REPO_URL="https://github.com/zen0-s4ma/proxmox-workstation.git"
SCRIPT_NAME="setup-pve-workstation.sh"                    

echo "==> Clonando repositorio ${REPO_URL}…"
git clone "${REPO_URL}" /opt/pve-setup
cd /opt/pve-setup

echo "==> Dando permisos y ejecutando ${SCRIPT_NAME}…"
chmod +x "${SCRIPT_NAME}"
./"${SCRIPT_NAME}"

# 4) Segunda ronda de actualización y limpieza final
echo "==> Actualización final y limpieza…"
apt update               # refrescar índices 
apt upgrade -y           # instalar actualizaciones sin cambiar dependencias 
apt full-upgrade -y      # instalar actualizaciones que requieran cambios en dependencias 
apt autoremove -y        # eliminar paquetes huérfanos 
apt autoclean -y         # limpiar caché de paquetes descargados 

echo "==> ¡Sistema Proxmox Workstation configurado y limpio!"
