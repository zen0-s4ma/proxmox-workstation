#!/bin/bash
set -e

echo "==> Iniciando Script Fase 4…"

USER_NAME="zenosama"

export HOME="/home/zenosama"
cd "$HOME"

###############################################################################
# 99.a) Actualizacion del .bash_profile para lanzar la siguiente fase
###############################################################################
echo
echo "==> Actualizacion del .bash_profile…"
USER_HOME=$(eval echo "~$USER_NAME")
cp -f /opt/pve-setup/bash_profiles_phase5 "$USER_HOME/.bash_profile"
sudo chown "$USER_NAME:$USER_NAME" /home/$USER_NAME/.bash_profile
sudo chmod 644 /home/$USER_NAME/.bash_profile
echo "==> .bash_profile Actualizado para lanzar la fase 5…"

###############################################################################
# 1) Instalacion de Auto-bspwm
###############################################################################
echo
echo "==> Comenzando ejecución de post-instalación como usuario $(id -un)..."
if [ ! -d "$HOME/auto-bspwm" ]; then
    echo "==> Clonando repositorio auto-bspwm y ejecutando instalación..."
    git clone https://github.com/zen0-s4ma/auto-bspwm.git "$HOME/auto-bspwm"
    cd "$HOME/auto-bspwm"
    sudo chmod +x setup.sh
    sudo -u "$USER_NAME" bash -c "cd \"$HOME/auto-bspwm\" && ./setup.sh | tee /tmp/setup_log.txt" \
        || { echo "(Error) Falló la instalación de auto-bspwm"; exit 1; }
else
    echo "==> El repositorio auto-bspwm ya existe. No se realiza la instalación."
fi

##############################################################################
# 99.b) Reinicio
###############################################################################
echo
echo "==> Configuración inicial completa. Reiniciando el sistema para proceder a Fase 5..."
echo "...FIN DE PHASE 4 - PULSA CUALQUIER TECLA PARA CONTINUAR..."
read -n 1 -s
sudo reboot