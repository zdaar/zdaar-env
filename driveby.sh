#!/bin/bash

# Main driveby script that setups up a lab server

echo "Starting the driveby initialization..."

# Update the system and install common dependencies
sudo apt-get update && sudo apt-get install -y curl wget

# Call other scripts
./install_zoxide.sh
./install_sgpt.sh
./init_bashrc.sh

echo "Driveby initialization complete. System is ready to use."
