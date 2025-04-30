#!/usr/bin/env bash

# Nombre del binario que quieres inspeccionar
APP_NAME="$1"

if [ -z "$APP_NAME" ]; then
  echo "Uso: $0 <nombre_del_binario>"
  exit 1
fi

# Obtener versión
VERSION=$("$APP_NAME" --version 2>/dev/null | head -n 1 | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?')
#VERSION=$("$APP_NAME" --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?')

# Si no funciona --version, prueba version
if [ -z "$VERSION" ]; then
  VERSION=$("$APP_NAME" version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?')
fi

if [ -z "$VERSION" ]; then
  echo "No pude detectar la versión automáticamente."
  VERSION="unknown"
fi

# Obtener ruta
STORE_PATH=$(readlink -f "$(which $APP_NAME)")
STORE_DIR=$(dirname "$STORE_PATH" | sed 's|/bin$||')

# Fecha actual en formato ISO8601
LAST_MODIFIED=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Detectar sistema
ARCH=$(uname -m)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

case "$ARCH-$OS" in
  x86_64-linux) SYSTEM="x86_64-linux" ;;
  x86_64-darwin) SYSTEM="x86_64-darwin" ;;
  aarch64-linux) SYSTEM="aarch64-linux" ;;
  aarch64-darwin) SYSTEM="aarch64-darwin" ;;
  *)
    echo "Sistema no reconocido: $ARCH-$OS"
    SYSTEM="unknown-system"
    ;;
esac

# Output JSON
cat <<EOF
{
  "${APP_NAME}@latest": {
    "last_modified": "${LAST_MODIFIED}",
    "resolved": "manual:local#${APP_NAME}",
    "source": "local-scan",
    "version": "${VERSION}",
    "systems": {
      "${SYSTEM}": {
        "outputs": [
          {
            "name": "out",
            "path": "${STORE_DIR}",
            "default": true
          }
        ],
        "store_path": "${STORE_DIR}"
      }
    }
  }
}
EOF
