#!/bin/bash
set -e

echo
echo "==> Instalando AutoBSPWM..."
echo
git clone https://github.com/r1vs3c/auto-bspwm.git ~/auto-bspwm
cd auto-bspwm
chmod +x setup.sh
./setup.sh