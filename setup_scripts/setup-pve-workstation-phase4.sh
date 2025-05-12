#!/bin/bash
set -e

echo "==> Iniciando Script Fase 4…"

USER_NAME="zenosama"
HOME="/home/$USER_NAME"

cd "$HOME"

###############################################################################
# 1) Post-instalacion
###############################################################################
echo
echo "==> Comenzando ejecución de post-instalación como usuario $(id -un)..."
echo
echo "==> Customizando ZSH..."
/opt/pve-setup/zsh_custom.sh

echo
echo "==> copiando el archivo .zshrc..."
cp -f /opt/pve-setup/zshrc "$HOME"/.zshrc

###############################################################################
# 99.a) Actualizacion del .bash_profile para lanzar la siguiente fase
###############################################################################
echo
echo "==> Actualizacion del .bash_profile…"
chsh -s /bin/bash "$USER_NAME"
USER_HOME=$(eval echo "~$USER_NAME")
cp -f /opt/pve-setup/bash_profiles_phase5 "$USER_HOME/.bash_profile"
sudo chown "$USER_NAME:$USER_NAME" /home/$USER_NAME/.bash_profile
sudo chmod 644 /home/$USER_NAME/.bash_profile
echo "==> .bash_profile Actualizado para lanzar la fase 5…"

##############################################################################
# 99.b) Reinicio
###############################################################################
echo
echo "==> Configuración inicial completa. Reiniciando el sistema en modo tty para proceder a Fase 5..."
echo "...FIN DE PHASE 4 - PULSA CUALQUIER TECLA PARA CONTINUAR..."
read -n 1 -s
sudo reboot