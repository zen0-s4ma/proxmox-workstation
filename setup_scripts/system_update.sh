#!/bin/bash
set -e

echo
echo "==> Ejecutando: update…"
sudo apt update

echo
/usr/local/bin/system_update.sh
echo "==> Ejecutando: upgrade…"
sudo apt upgrade -y

echo
/usr/local/bin/system_update.sh
echo "==> Ejecutando: full-upgrade…"
sudo apt full-upgrade -y

echo
/usr/local/bin/system_update.sh
echo "==> Ejecutando: autoremove…"
sudo apt autoremove -y

echo
/usr/local/bin/system_update.sh
echo "==> Ejecutando: autoclean…"
sudo apt autoclean -y

echo
echo "==> Revisando dependencias…"
sudo dpkg --configure -a
sudo apt install -f -y

echo
neofetch
echo