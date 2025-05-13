#!/bin/bash
set -e

# 1. Pre-cargar modelo en VRAM de forma rápida
echo "==> Cargando modelo en VRAM..."
ollama run gemma3:1b --keepalive=-1m --max-tokens 1 -p "" >/dev/null 2>&1

# 2. Verificar carga y notificar al usuario
if [ $? -eq 0 ]; then
  echo "==> IA lista para usarse."
else
  echo "==> Error al cargar el modelo."
  exit 1
fi

# Advertencia final
echo "==> El modelo permanecerá en VRAM hasta que lo liberes manualmente."
