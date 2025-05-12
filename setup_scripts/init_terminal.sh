#!/bin/bash

mkdir -p ~/.config/autostart

echo
echo "==> Creando fichero de lanzador de terminal…"

USER_HOME=$(eval echo "~$USER_NAME")

cp -f /opt/pve-setup/autostart_terminal.desktop $USER_HOME/.config/autostart/auto-terminal.desktop

echo
echo "✅ La terminal se ejecutará automáticamente al iniciar el entorno gráfico"
