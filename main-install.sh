#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -euo pipefail

# --- Configuration ---
# IMPORTANT: Replace this with the actual URL of your SuitTunnel binary.
# Example: BINARY_URL="https://github.com/devprogrmer/suittunnel/releases/download/v1.0.0/suit-tunnel-linux-amd64"
BINARY_URL="https://example.com/path/to/your/suit-tunnel-binary" # <<<--- !!! این آدرس را با آدرس صحیح فایل باینری جایگزین کن !!!
BINARY_NAME="suit-tunnel" # The name of the executable binary

INSTALL_DIR="/opt/tunnel"
SERVICE_FILE="/etc/systemd/system/suittunnel.service"

# --- Installation Steps ---

echo "Starting SuitTunnel installation..."

# 1. Create installation directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating installation directory: $INSTALL_DIR"
    sudo mkdir -p "$INSTALL_DIR"
    # Ensure the directory is owned by the current user for simplicity.
    # For production, consider a dedicated user or appropriate permissions.
    sudo chown "$(id -u):$(id -g)" "$INSTALL_DIR"
fi

# 2. Download the binary
echo "Downloading ${BINARY_NAME} binary from ${BINARY_URL}..."
if ! curl -fsSL "${BINARY_URL}" -o "${INSTALL_DIR}/${BINARY_NAME}"; then
    echo "Error: Failed to download the ${BINARY_NAME} binary from ${BINARY_URL}."
    echo "Please check if the BINARY_URL is correct and the file exists."
    exit 1
fi

# 3. Set execute permissions for the binary
echo "Setting execute permissions for ${BINARY_NAME}..."
chmod +x "${INSTALL_DIR}/${BINARY_NAME}"

# 4. Create a systemd service file for auto-starting SuitTunnel
echo "Creating systemd service file: ${SERVICE_FILE}"
# Use sudo to write to /etc/systemd/system
sudo bash -c "cat > ${SERVICE_FILE}" << EOF
[Unit]
Description=SuitTunnel Service
After=network.target

[Service]
# Consider running as a non-root user for better security if your application allows it.
# User=$(id -u -n)
# Group=$(id -g -n)
# If running as root, adjust User/Group or remove them if not needed.
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
# Enable the service to start on boot
sudo systemctl enable suittunnel.service
# Start the service immediately
sudo systemctl start suittunnel.service

# Check the status of the service
SERVICE_STATUS=$(sudo systemctl is-active suittunnel.service)
if [ "$SERVICE_STATUS" = "active" ]; then
    echo "SuitTunnel service started successfully."
else
    echo "SuitTunnel service failed to start. Status: ${SERVICE_STATUS}"
    echo "You can check detailed logs with: sudo journalctl -u suittunnel.service"
fi

echo "SuitTunnel installation and setup completed."

exit 0
