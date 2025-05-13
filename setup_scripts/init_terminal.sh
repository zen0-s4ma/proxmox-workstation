#!/bin/bash
set -e

USER_NAME="zenosama"
USER_HOME=$(eval echo "~${USER_NAME}")
echo "==> Directorio home: ${USER_HOME}"

echo
echo "==> Creando directorio de autostart…"
mkdir -p "${USER_HOME}/.config/autostart"

echo
echo "==> Creando fichero de lanzador de terminal…"
cp -f /opt/pve-setup/autostart_zsh_customizer.desktop "${USER_HOME}/.config/autostart/autostart_zsh_customizer.desktop"
cp -f /opt/pve-setup/autostart_terminal.desktop "${USER_HOME}/.config/autostart/autostart_terminal.desktop"

# Asegúrate de que el usuario tenga permisos sobre el fichero
chown "${USER_NAME}:${USER_NAME}" "${USER_HOME}/.config/autostart/autostart_zsh_customizer.desktop"
chown "${USER_NAME}:${USER_NAME}" "${USER_HOME}/.config/autostart/autostart_zsh_customizer.desktop"

echo
echo "==> La terminal se ejecutara automáticamente al iniciar el entorno grafico"
