#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -euo pipefail

# --- Configuration ---
# IMPORTANT: Replace these with your actual values if needed.
# If you are just installing, these might be pre-configured or handled by the script itself.
# For this example, we assume the binary is downloaded from a specific URL.

INSTALL_DIR="/opt/tunnel"
BINARY_URL="https://example.com/path/to/your/suit-tunnel-binary" # Replace with the actual URL of your binary
BINARY_NAME="suit-tunnel" # The name of the executable binary

# --- Installation Steps ---

echo "Starting SuitTunnel installation..."

# 1. Create installation directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating installation directory: $INSTALL_DIR"
    sudo mkdir -p "$INSTALL_DIR"
    # Ensure the directory is owned by the current user for simplicity,
    # but for production, you might want to manage ownership differently.
    sudo chown "$(id -u):$(id -g)" "$INSTALL_DIR"
fi

# 2. Download the binary
echo "Downloading ${BINARY_NAME} binary from ${BINARY_URL}..."
if ! curl -fsSL "${BINARY_URL}" -o "${INSTALL_DIR}/${BINARY_NAME}"; then
    echo "Error: Failed to download the ${BINARY_NAME} binary."
    exit 1
fi

# 3. Set execute permissions for the binary
echo "Setting execute permissions for ${BINARY_NAME}..."
chmod +x "${INSTALL_DIR}/${BINARY_NAME}"

# 4. (Optional) Create a systemd service file for auto-starting SuitTunnel
# This part depends heavily on how your SuitTunnel application is designed to run.
# Example: Create a service file that runs the binary.
SERVICE_FILE="/etc/systemd/system/suittunnel.service"
if ! systemctl list-unit-files | grep -q "suittunnel.service"; then
    echo "Creating systemd service file: ${SERVICE_FILE}"
    sudo bash -c "cat > ${SERVICE_FILE}" << EOF
[Unit]
Description=SuitTunnel Service
After=network.target

[Service]
User=$(id -u -n)
Group=$(id -g -n)
WorkingDirectory=${INSTALL_DIR}
ExecStart=${INSTALL_DIR}/${BINARY_NAME}
Restart=on-failure
RestartSec=5

[Install]
Type=simple
WantedBy=multi-user.target
EOF
    echo "Reloading systemd daemon..."
    sudo systemctl daemon-reload
    echo "Enabling and starting SuitTunnel service..."
    sudo systemctl enable suittunnel.service
    sudo systemctl start suittunnel.service
    echo "SuitTunnel service enabled and started."
else
    echo "SuitTunnel service already exists. Trying to restart..."
    sudo systemctl restart suittunnel.service
    echo "SuitTunnel service restarted."
fi

echo "SuitTunnel installation and setup completed successfully!"
echo "You can check the status with: sudo systemctl status suittunnel.service"

exit 0
