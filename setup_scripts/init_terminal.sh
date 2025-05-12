#!/bin/bash

mkdir -p ~/.config/autostart

echo
echo "==> Creando fichero de lanzador de terminal…"

USER_HOME=$(eval echo "~$USER_NAME")

cp -f ./setup_scripts/autostart_terminal.desktop $USER_HOME/.config/autostart/auto-terminal.desktop

echo
echo "✅ La terminal se ejecutará automáticamente al iniciar el entorno gráfico"
