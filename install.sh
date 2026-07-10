        #!/usr/bin/env bash

        # Exit immediately if a command exits with a non-zero status.
        set -euo pipefail

        # --- Configuration ---
        # This script downloads and executes the main installer.
        # URL for the main installer script. Make sure this points to the raw content of main-install.sh
        MAIN_INSTALLER_URL="https://raw.githubusercontent.com/devprogrmer/suittunnel/main/main-install.sh"
        INSTALLER_SCRIPT_NAME="main-install.sh"
        TEMP_INSTALLER_PATH="/tmp/${INSTALLER_SCRIPT_NAME}"

        # --- Installation Steps ---
        echo "Downloading the main installer script from ${MAIN_INSTALLER_URL}..."

        # Download the main installer script
        if ! curl -fsSL "${MAIN_INSTALLER_URL}" -o "${TEMP_INSTALLER_PATH}"; then
            echo "Error: Failed to download the main installer script from ${MAIN_INSTALLER_URL}."
            exit 1
        fi

        echo "Main installer script downloaded successfully."
        echo "Executing the main installer..."

        # Make the downloaded script executable
        chmod +x "${TEMP_INSTALLER_PATH}"

        # Execute the main installer script
        # We execute it directly, and it should exit on its own.
        exec "${TEMP_INSTALLER_PATH}"

        # The script should exit here after exec. If it continues, something is wrong.
        echo "Error: Main installer script did not execute correctly or exit."
        exit 1
