#!/bin/bash
set -e

# 1. Pre-cargar modelo en VRAM de forma rápida
echo "==> Cargando modelo en VRAM..."
ollama run gemma3:1b --keepalive=-1m 
