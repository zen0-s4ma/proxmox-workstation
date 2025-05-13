#!/bin/bash
set -e

echo
echo "==> Ejecutando: update…"
sudo apt update
echo "==> Ejecutando: upgrade…"
sudo apt upgrade -y
echo "==> Ejecutando: full-upgrade…"
sudo apt full-upgrade -y
echo "==> Ejecutando: autoremove…"
sudo apt autoremove -y
echo "==> Ejecutando: autoclean…"
sudo apt autoclean -y
echo
echo "==> Revisando dependencias…"
sudo dpkg --configure -a
sudo apt install -f -y
echo
neofetch
echo