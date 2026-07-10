#!/usr/bin/env bash
set -euo pipefail

MAIN_INSTALLER_URL="https://raw.githubusercontent.com/devprogrmer/suittunnel/main/main-install.sh"

INSTALL_DIR="/opt/tunnel"
INSTALLER_FILE="${INSTALL_DIR}/install.sh"

if ! command -v curl &> /dev/null; then
    echo "Error: curl is not installed. Please install curl first."
    exit 1
fi

if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating installation directory: $INSTALL_DIR"
    sudo mkdir -p "$INSTALL_DIR"
    sudo chown "$(id -u):$(id -g)" "$INSTALL_DIR"
fi

echo "Downloading the main installer script from $MAIN_INSTALLER_URL..."

if ! curl -fsSL "$MAIN_INSTALLER_URL" -o "$INSTALLER_FILE"; then
    echo "Error: Failed to download the main installer script."
    exit 1
fi

echo "Setting execute permissions for the installer script..."
chmod +x "$INSTALLER_FILE"

echo "Running the main installer script..."
if ! "$INSTALLER_FILE"; then
    echo "Error: The main installer script failed to execute."
    exit 1
fi

echo "Installation process initiated successfully."
echo "Please follow any further instructions displayed by the installer."

exit 0
