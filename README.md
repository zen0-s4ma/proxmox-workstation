# Zenoversux - ProxmoxWorkstation

*Convierte una instalación limpia de **Proxmox VE 8.4** en una estación de trabajo Linux completa y multipropósito, con entorno gráfico, herramientas de desarrollo, pentesting, gaming, homelab y productividad listas para usar.*

## Tabla de Contenidos

* [Instalación paso a paso](#instalación-paso-a-paso)
* [Descripción general del proyecto](#descripción-general-del-proyecto)
* [Estructura del proyecto](#estructura-del-proyecto)
* [Requisitos del sistema](#requisitos-del-sistema)
* [Funcionalidades principales tras la instalación](#funcionalidades-principales-tras-la-instalación)
* [Personalización y modularidad](#personalización-y-modularidad)
* [Seguridad y buenas prácticas post-instalación](#seguridad-y-buenas-prácticas-post-instalación)
* [Mantenimiento y actualización](#mantenimiento-y-actualización)
* [Créditos y contribuciones](#créditos-y-contribuciones)

## Instalación paso a paso

**Nota:** Se recomienda partir de una instalación **nueva** de Proxmox VE 8.4, ya que el script realizará cambios importantes en la configuración del sistema (red, repositorios, entorno de escritorio, etc.). Asegúrate de tener conexión a Internet durante el proceso.

1. **Preparar el sistema base:** Inicia sesión en tu Proxmox VE 8.4 recién instalado (usualmente con el usuario `root` y la contraseña definida durante la instalación). Comprueba la conectividad a Internet:

   ```bash
   ping -c 3 google.com
   ```

   Actualiza la lista de paquetes e instala Git si aún no está disponible:

   ```bash
   apt update && apt install -y git
   ```

2. **Clonar el repositorio del proyecto:**

   ```bash
   git clone https://github.com/Zenoversux/ProxmoxWorkstation.git
   cd ProxmoxWorkstation
   ```

3. **Ejecutar el instalador:**

   ```bash
   chmod +x install.sh
   ./install.sh
   ```

   > ⚠️ **Importante:** El script configura por defecto la IP estática `192.168.1.199/24` en `vmbr0`. Si tu red es distinta, edita `config_files/interfaces` antes de ejecutar `install.sh`.

4. **Proceso de instalación automatizado (fases 1 a 5):**

   * **Fase 1:** Configura repositorios, red, usuario `zenosama`, actualiza sistema base y reinicia en modo texto.
   * **Reinicio 1:** Autologin en `tty1` como `zenosama`, ejecuta **Fase 2**.
   * **Fase 2:** Instala herramientas de desarrollo, CLI (Zsh, Kitty, fzf, etc.), multimedia, Tor, Docker, Flatpak y más. Reinicia.
   * **Reinicio 2:** Autologin en `tty1`, ejecuta **Fase 3**.
   * **Fase 3:** Instala X11, LightDM, XFCE4 y Cinnamon, reinicia.
   * **Reinicio 3:** Autologin en `tty1`, ejecuta **Fase 4**.
   * **Fase 4:** Configura terminal predeterminada, fuentes, autostart de terminal de bienvenida, reinicia en modo gráfico.
   * **Reinicio 4:** Arranca modo gráfico, ejecuta **Fase 5**.
   * **Fase 5:** Cambia a Zsh + Oh My Zsh + Powerlevel10k, habilita `graphical.target`, limpia `.bash_profile`, último reinicio.

5. **Primer arranque gráfico:** Inicia sesión en LightDM como `zenosama` (contraseña `zenosama`), elige XFCE o Cinnamon. Verás una terminal de bienvenida con actualizaciones y Neofetch.

   * Cambia la contraseña con `passwd`.
   * Comprueba `docker --version`, `flatpak list` y explora el menú de aplicaciones.

¡Listo! Tu Proxmox VE se ha convertido en una estación de trabajo completa.

## Descripción general del proyecto

**Zenoversux - ProxmoxWorkstation** combina la **potencia de Proxmox VE** con la **comodidad de un escritorio Linux**:

* **Desarrollo:** VMs + contenedores + lenguajes (C/C++, Go, Rust, Python) + IDE (VSCode).
* **Pentesting:** Repositorio Kali on-demand + Tor + proxychains + Mullvad/Tor Browser.
* **Homelab:** Docker, LXC, VMs, Portainer (opcional), Jellyfin, Samba (opcional), monitorización.
* **Gaming:** Drivers NVIDIA, Wine, multiarch i386 (opcional), Steam, Lutris, GameMode, MangoHud.
* **Productividad:** Navegadores, Thunderbird, LibreOffice (opcional), GIMP/Inkscape (opcional), Joplin, Syncthing.
* **IA Local:** **Ollama** con modelo `gemma3:1b` preinstalado.

> ⚠️ **Aviso:** No es una configuración oficial soportada por Proxmox. Realiza backups antes de usarlo en producción.

## Estructura del proyecto

* **`install.sh`**: Instalador principal (fases, repos, red, usuario, reinicios).
* **`config_files/`**: Configuraciones de APT, red, bash\_profiles y fuentes.
* **`setup_scripts/`**: Scripts de fases 2–6 y utilidades (`init_terminal.sh`, `system_update.sh`, `zsh_customizer.sh`).
* **`custom_services/`**: Override de autologin en TTY1.
* **`install_auto_bspwm.sh`**: OPCIONAL para instalar BSPWM.

Cada fase prepara `.bash_profile`, ejecuta acciones específicas y reinicia.

## Requisitos del sistema

* Proxmox VE 8.4 (Debian 12) en arquitectura amd64.
* CPU multinúcleo con VT-x/AMD‑V.
* ≥ 8 GB RAM (16 GB recomendado).
* ≥ 64 GB SSD.
* Conexión a Internet estable.
* Acceso físico o consola remota durante la instalación.
* Ethernet recomendado (o adaptar `/etc/network/interfaces` para WiFi).
* Nodo standalone (no en cluster) idealmente.

## Funcionalidades principales tras la instalación

* **Escritorio completo:** XFCE4 y Cinnamon via LightDM + Papirus Icons.
* **Terminal avanzada:** Kitty, Zsh + Oh My Zsh + Powerlevel10k, fzf, lsd, bat.
* **CLI & sistema:** NetworkManager, Bluetooth (Bluejay, toolBLEx), BackInTime, OpenSSH, OpenVPN, WireGuard.
* **Navegadores & multimedia:** Brave, Firefox, Chrome, Mullvad/LibeWolf/Tor, VLC, Kodi, JDownloader.
* **Contenedores & virtualización:** Proxmox GUI, Docker CE + Whaler GUI.
* **Desarrollo:** Compiladores (GCC, Clang, Go, Rust), Python, Git, VSCode.
* **Pentesting:** Tor + proxychains, Kali packages on demand.
* **Gaming:** Drivers NVIDIA, Wine, multiarch i386, Steam/Lutris (instalación opcional).
* **IA local:** Ollama con modelo `gemma3:1b`.

## Personalización y modularidad

* Cambia usuario y contraseña editando `install.sh` o añadiendo usuarios manualmente.
* Elige entorno: quita o añade XFCE/Cinnamon/otros.
* Instala software adicional via `apt`, `flatpak` o Docker.
* Ejecuta `/opt/pve-setup/install_auto_bspwm.sh` para BSPWM.
* Modifica scripts de fase en `setup_scripts/` para extender o crear nuevas fases.
* Ajusta autologin gráfico en `/etc/lightdm/lightdm.conf`.

## Seguridad y buenas prácticas post-instalación

* Cambia contraseñas (`passwd`).
* Deshabilita autologin TTY: elimina `/etc/systemd/system/getty@tty1.service.d/override.conf`.
* Bloquea root SSH: en `/etc/ssh/sshd_config` pon `PermitRootLogin no`.
* Configura firewall (ufw o Proxmox firewall).
* Desinstala servicios innecesarios (Samba, VPN si no los usas).
* Programación de backups: BackInTime, snapshots ZFS/Proxmox.

## Mantenimiento y actualización

* **APT**: `sudo apt update && sudo apt full-upgrade`.
* **Flatpak**: `flatpak update`.
* **Docker**: `docker pull` + recrear contenedores.
* **Ollama**: revisa versiones y modelos.
* **Logs**: `journalctl`, `dmesg`, `htop`.
* **Snapshots/Backups**: Proxmox Backup Server, ZFS snapshots, BackInTime.
* **Upgrades de Proxmox/Debian**: planifícalos con cuidado; prueba en entorno no crítico.

## Créditos y contribuciones

* **Proxmox VE**, **Debian**, **Kali Linux**.
* Herramientas de desarrolladores: Oh My Zsh, Powerlevel10k, Flathub, Kitty, Bluejay, Whaler, Ollama, r1vs3c (auto-bspwm).
* **Autor:** Zenoversux.
* **Repositorio:** [https://github.com/Zenoversux/ProxmoxWorkstation](https://github.com/Zenoversux/ProxmoxWorkstation)

### Cómo contribuir

1. Reporta bugs abriendo Issues con detalles.
2. Haz PRs para mejorar scripts, añadir módulos o documentar.
3. Usa el mismo estilo de scripting (bash, `set -e`).
4. Comprueba en instalación limpia antes de enviar PR.

> ¡Gracias por usar **Zenoversux - ProxmoxWorkstation**! 🚀
