#!/bin/bash
set -e

USER_NAME="zenosama"

if ! id -u "$USER_NAME" &>/dev/null; then
  # Crear usuario con Bash como shell por defecto y en el grupo sudo
  useradd -m -s /bin/bash -G sudo "$USER_NAME"
  echo "$USER_NAME:$USER_PASS" | chpasswd

  # Permitir sudo sin contraseña
  echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" \
       > /etc/sudoers.d/99-$USER_NAME-nopasswd
  chmod 0440 /etc/sudoers.d/99-$USER_NAME-nopasswd

  # Crear ~/.bash_profile si no existe
  USER_HOME=$(eval echo "~$USER_NAME")
  BPROFILE="$USER_HOME/.bash_profile"
  if [ ! -e "$BPROFILE" ]; then
    cat << 'EOF' > "$BPROFILE"
# ~/.bash_profile: ejecutado al iniciar sesión en shell de login
if [[ $- == *i* ]]; then
  # Carga ~/.bashrc si existe
  [ -f ~/.bashrc ] && . ~/.bashrc
fi
EOF
    chown "$USER_NAME:$USER_NAME" "$BPROFILE"
    chmod 644 "$BPROFILE"
  fi
fi
