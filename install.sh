#!/bin/bash
set -e

echo "==> $(id -un): Iniciando Script…"

USER_NAME="zenosama"
USER_PASS="zenosama"

#########################################################################
# 1) Copiar ficheros de configuración
#########################################################################
mkdir -p /opt/pve-setup
echo
echo "==> Creando bakups de los ficheros de configuracion..."
cp -f /etc/apt/sources.list.d/ceph.list /etc/apt/sources.list.d/ceph.list.bak
cp -f /etc/network/interfaces /etc/network/interfaces.bak
cp -f /etc/resolv.conf /etc/resolv.conf.bak
cp -f /etc/apt/sources.list /etc/apt/sources.list.bak

echo
echo "==> Copiando ficheros de configuracion..."
cp -f ./config_files/ceph.list /etc/apt/sources.list.d/ceph.list
cp -f ./config_files/interfaces /etc/network/interfaces
cp -f ./config_files/resolv.conf /etc/resolv.conf
cp -f ./config_files/sources.list /etc/apt/sources.list

echo
echo "==> Copiando ficheros de bash profile..."
cp -f ./config_files/bash_profiles_phase2 /opt/pve-setup/bash_profiles_phase2
cp -f ./config_files/bash_profiles_phase3 /opt/pve-setup/bash_profiles_phase3
cp -f ./config_files/bash_profiles_phase4 /opt/pve-setup/bash_profiles_phase4
cp -f ./config_files/zshrc /opt/pve-setup/zshrc

echo
echo "==> Copiando scripts de instalacion..."
cp -f ./setup_scripts/setup-pve-workstation-phase2.sh /opt/pve-setup/setup-pve-workstation-phase2.sh
cp -f ./setup_scripts/setup-pve-workstation-phase3.sh /opt/pve-setup/setup-pve-workstation-phase3.sh
cp -f ./setup_scripts/setup-pve-workstation-phase4.sh /opt/pve-setup/setup-pve-workstation-phase4.sh
cp -f ./setup_scripts/setup-pve-workstation-phase5.sh /opt/pve-setup/setup-pve-workstation-phase5.sh
cp -f ./setup_scripts/setup-pve-workstation-phase6.sh /opt/pve-setup/setup-pve-workstation-phase6.sh
cp -f ./setup_scripts/load_ollama_ia_model.sh /opt/pve-setup/load_ollama_ia_model.sh
cp -f ./setup_scripts/system_update.sh /usr/local/bin/system_update.sh
cp -f ./setup_scripts/install_auto_bspwm.sh /opt/pve-setup/install_auto_bspwm.sh
cp -f ./setup_scripts/zsh_customizer.sh /opt/pve-setup/zsh_customizer.sh

echo
echo "==> Dando permisos de ejecucion a los scripts..."
chmod +x /opt/pve-setup/setup-pve-workstation-phase2.sh
chmod +x /opt/pve-setup/setup-pve-workstation-phase3.sh
chmod +x /opt/pve-setup/setup-pve-workstation-phase4.sh
chmod +x /opt/pve-setup/setup-pve-workstation-phase5.sh
chmod +x /opt/pve-setup/setup-pve-workstation-phase6.sh
chmod +x /opt/pve-setup/load_ollama_ia_model.sh
chmod +x /usr/local/bin/system_update.sh
chmod +x /opt/pve-setup/install_auto_bspwm.sh
chmod +x /opt/pve-setup/zsh_customizer.sh

echo
echo "==> creando el servicio para el autologin durante la instalacion..."
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
cp -f ./custom_services/autologin.service /etc/systemd/system/getty@tty1.service.d/override.conf
sudo systemctl daemon-reload
sudo systemctl disable getty@tty1.service
sudo systemctl enable getty@tty1.service

echo
echo "==> creando lanzador de terminal al iniciar sesion grafica..."
cp -f ./setup_scripts/init_terminal.sh /opt/pve-setup/init_terminal.sh
chmod +x /opt/pve-setup/init_terminal.sh
cp -f ./setup_scripts/autostart_zsh_customizer.desktop /opt/pve-setup/autostart_zsh_customizer.desktop
chmod +x /opt/pve-setup/autostart_zsh_customizer.desktop
cp -f ./setup_scripts/autostart_terminal.desktop /opt/pve-setup/autostart_terminal.desktop
chmod +x /opt/pve-setup/autostart_terminal.desktop

###############################################################################
# 2) Agregar Repositorios de kali
###############################################################################
echo
echo "==> Importando repositorio Kali…"
echo
sudo apt install -y wget gnupg

# clave + repo (pin 50 para no mezclar dependencias)
wget -qO- https://archive.kali.org/archive-key.asc | \
     sudo tee /usr/share/keyrings/kali-archive-keyring.asc
echo "deb [signed-by=/usr/share/keyrings/kali-archive-keyring.asc] \
     http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" | \
     sudo tee /etc/apt/sources.list.d/kali.list
echo -e "Package: *\nPin: release o=Kali\nPin-Priority: 50" | \
     sudo tee /etc/apt/preferences.d/limit-kali

#########################################################################
# 3) Reiniciar red
#########################################################################
echo
echo "==> [root] Reiniciando la interfaz de red…"
systemctl restart networking

###############################################################################
# 4) Instalacion de SUDO, creacion de usuario y permisos
###############################################################################
if [[ $EUID -eq 0 && -z "${RUN_AS_ZENO:-}" ]]; then
  echo
  echo "==> [root] Instalando sudo…"
  if ! command -v sudo &>/dev/null; then
    apt update -qq
    apt install -y sudo
  fi
  echo
  echo "==> [root] Creando usuario '$USER_NAME'…"
  chmod +x ./setup_scripts/create_user.sh
  ./setup_scripts/create_user.sh
fi

###############################################################################
# 5) Actualizar sistema base y kernel Proxmox VE
###############################################################################
echo
echo "==> [${USER_NAME}] Actualizando: update…"
apt update
echo
echo "==> [${USER_NAME}] Actualizando: upgrade"
apt upgrade -y
echo
echo "==> [${USER_NAME}] Actualizando: full-upgrade"
apt full-upgrade -y
echo
echo "==> [${USER_NAME}] Actualizando: pve-headers"
apt install -y pve-headers

###############################################################################
# 6) Comprobaciones
###############################################################################
echo "==> Comprobacion de variables…"
echo "==> Usuario actual: $(id -un)"
echo "==> Usuario creado: $USER_NAME"
echo "==> Home actual: $HOME"
echo "==> Path: $(pwd)"
cd "$HOME"
echo "==> Path Actualizado: $(pwd)"
echo "==> Shell Actual: $SHELL"

###############################################################################
# 99.a) Actualizacion del .bash_profile para lanzar la siguiente fase
###############################################################################
echo
echo "==> Actualizacion del .bash_profile…"
USER_HOME=$(eval echo "~$USER_NAME")
cp -f /opt/pve-setup/bash_profiles_phase2 "$USER_HOME/.bash_profile"
sudo chown "$USER_NAME:$USER_NAME" /home/$USER_NAME/.bash_profile
sudo chmod 644 /home/$USER_NAME/.bash_profile
echo "==> .bash_profile Actualizado para lanzar la fase 2…"

##############################################################################
# 99.b) Reinicio
###############################################################################
echo
echo "==> Configuración inicial completa. Reiniciando el sistema en modo tty para proceder a Fase 2..."
sudo systemctl set-default multi-user.target

echo
echo "...FIN DE INSTALL.SH - PULSA CUALQUIER TECLA PARA CONTINUAR..."
read -n 1 -s
sudo reboot