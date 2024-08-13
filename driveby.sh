#!/bin/bash

# Main driveby script that setups up a lab server

echo "Starting the driveby initialization..."

# Update the system and install common dependencies
sudo apt-get update && sudo apt-get install -y curl wget

# Define base URL for fetching scripts
BASE_URL="https://raw.githubusercontent.com/zdaar/zdaar-env/main"

# Fetch and execute other scripts remotely
curl -s ${BASE_URL}/install_zoxide.sh | bash
curl -s ${BASE_URL}/install_sgpt.sh | bash
curl -s ${BASE_URL}/install_tools.sh | bash
curl -s ${BASE_URL}/init_bashrc.sh | bash

echo "Driveby initialization complete. System is ready to use."

source ~/.bashrc