#!/bin/bash
set -e

echo "==> Ejecutando: update…"
sudo apt update

echo
echo "==> Ejecutando: upgrade…"
sudo apt upgrade -y

echo
echo "==> Ejecutando: full-upgrade…"
sudo apt full-upgrade -y

echo
echo "==> Ejecutando: autoremove…"
sudo apt autoremove -y

echo
echo "==> Ejecutando: autoclean…"
sudo apt autoclean -y

echo
echo "==> Revisando dependencias…"
sudo dpkg --configure -a
sudo apt install -f -y

echo
neofetch
echo