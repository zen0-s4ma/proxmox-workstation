#!/bin/bash

mkdir -p ~/.config/autostart

echo
echo "==> Creando fichero de lanzador de terminal…"

cat > ~/.config/autostart/auto-neofetch.desktop << EOF
[Desktop Entry]
Type=Application
Name=Auto Neofetch
Exec=xfce4-terminal --command="neofetch; exec bash"
Terminal=false
EOF

echo
echo "✅ Neofetch se ejecutará automáticamente al iniciar el entorno gráfico usando xfce4-terminal."
