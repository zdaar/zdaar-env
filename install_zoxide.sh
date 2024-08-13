#!/bin/bash

# Script to install and initialize zoxide

echo "Checking for zoxide installation..."

if ! command -v zoxide >/dev/null 2>&1; then
    echo "Installing zoxide..."
    sudo apt-get update && sudo apt-get install -y zoxide
else
    echo "zoxide is already installed."
fi

echo "Initializing zoxide in .bashrc..."

if ! grep -q "zoxide init bash" ~/.bashrc; then
    echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
    echo "zoxide initialized in .bashrc."
fi

source ~/.bashrc
