#!/bin/bash
set -euo pipefail

# 1) Actualizar sistema base y kernel Proxmox VE
#    Según Proxmox VE FAQ: apt update && apt full-upgrade :contentReference[oaicite:4]{index=4}
echo "==> Actualizando sistema base y kernel…"
apt update
apt full-upgrade -y

# 2) Instalar Git para clonar repositorios
echo "==> Instalando Git…"
apt install -y git

# 3) Clonar y ejecutar tu script de instalación de paquetes
REPO_URL="https://github.com/usuario/tu-repo.git"    # ← Cambia aquí
SCRIPT_NAME="setup-pve-workstation.sh"                    

echo "==> Clonando repositorio ${REPO_URL}…"
git clone "${REPO_URL}" /opt/pve-setup
cd /opt/pve-setup

echo "==> Dando permisos y ejecutando ${SCRIPT_NAME}…"
chmod +x "${SCRIPT_NAME}"
./"${SCRIPT_NAME}"

# 4) Segunda ronda de actualización y limpieza final
echo "==> Actualización final y limpieza…"
apt update               # refrescar índices :contentReference[oaicite:5]{index=5}
apt upgrade -y           # instalar actualizaciones sin cambiar dependencias :contentReference[oaicite:6]{index=6}
apt full-upgrade -y      # instalar actualizaciones que requieran cambios en dependencias :contentReference[oaicite:7]{index=7}
apt autoremove -y        # eliminar paquetes huérfanos :contentReference[oaicite:8]{index=8}
apt autoclean -y         # limpiar caché de paquetes descargados :contentReference[oaicite:9]{index=9}

echo "==> ¡Sistema Proxmox Workstation configurado y limpio! 🎉"
