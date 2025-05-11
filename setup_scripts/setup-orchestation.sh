#!/usr/bin/env bash
# usage: setup-orchestation.sh <usuario> <ruta-al-script>
set -euo pipefail
user="$1"
next="$2"
profile="/home/$user/.bash_profile"

# comprueba que no esté ya programado
if ! grep -qF "$next" "$profile"; then
  cat <<EOF >> "$profile"

# lanzamos $next al primer login
if [ -f "$next" ]; then
  echo "==> Ejecutando configuración $(basename "$next")..."
  bash "$next"
  # borramos esta sección de .bash_profile
  sed -i '\\|$next|d' "$profile"
fi
EOF
  chown "$user":"$user" "$profile"
  echo "==> Fase siguiente ($next) programada en $profile"
else
  echo "==> $next ya estaba programado en $profile"
fi