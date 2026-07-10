#!/usr/bin/env bash

# Configuration
# IMPORTANT: Replace 'devprogrmer' and 'suittunnel' with your GitHub username and repository name.
#            Also, ensure 'main-install.sh' is the correct name of your main installer script.
MAIN_INSTALLER_URL="https://raw.githubusercontent.com/devprogrmer/suittunnel/main/main-install.sh"

# --- Installation Script (Bootstrap) ---

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Downloading the main installer script from ${MAIN_INSTALLER_URL}..."

# Download the main installer script using curl
# -f: Fail silently (no output on HTTP errors)
# -s: Silent or quiet mode
# -S: Show error message if it fails
# -L: Follow redirects
MAIN_INSTALLER_CONTENT=$(curl -fsSL "${MAIN_INSTALLER_URL}")

# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to download the main installer script."
    echo "Please check the following:"
    echo "1. The URL is correct: ${MAIN_INSTALLER_URL}"
    echo "2. The file exists in your GitHub repository."
    echo "3. Your repository is public."
    exit 1
fi

echo "Main installer script downloaded successfully."
echo "Executing the main installer..."

# Execute the downloaded script
# Use bash -c to ensure it runs in a subshell
bash -c "${MAIN_INSTALLER_CONTENT}"

echo "Installation process finished."
exit 0
