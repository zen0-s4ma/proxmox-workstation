Hacer copia de seguridad del fichero original de repositorios:
cp /etc/apt/sources.list /etc/apt/sources.list.bak

Configurar repositorios Debian “Bookworm”:
Edita /etc/apt/sources.list con lo siguiente:
deb http://deb.debian.org/debian bookworm main contrib non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free-firmware
deb http://deb.debian.org/debian bookworm-backports main contrib non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main contrib non-free-firmware

Añadir el repositorio “no-subscription” de Proxmox VE:
Edita /etc/apt/sources.list con lo siguiente:
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription

Importar la clave GPG de Proxmox:
wget -qO /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg


