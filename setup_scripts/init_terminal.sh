#!/bin/bash
set -e

USER_NAME="zenosama"

mkdir -p ~/.config/autostart

echo
echo "==> Creando fichero de lanzador de terminal…"

USER_HOME=$(eval echo "$USER_NAME")
echo "==> Directorio home: $USER_HOME…"

cp -f /opt/pve-setup/autostart_terminal.desktop $USER_HOME/.config/autostart/auto_terminal.desktop

echo
echo "==> La terminal se ejecutará automáticamente al iniciar el entorno gráfico"
