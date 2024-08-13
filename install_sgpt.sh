#!/bin/bash

# Script to install SGPT from a specific GitHub release

echo "Installing SGPT..."

# Set the version and architecture
VERSION="2.14.1"
ARCH="amd64"  # Change this to "arm64" or "armhf" if needed

# Construct the download URL
DOWNLOAD_URL="https://github.com/tbckr/sgpt/releases/download/v${VERSION}/sgpt_${VERSION}_${ARCH}.deb"

echo "Downloading SGPT from $DOWNLOAD_URL..."
curl -L "$DOWNLOAD_URL" -o "sgpt_${VERSION}_${ARCH}.deb"

if [ $? -ne 0 ]; then
    echo "Failed to download SGPT package."
    exit 1
fi

echo "Installing SGPT..."
sudo dpkg -i "sgpt_${VERSION}_${ARCH}.deb"

if [ $? -ne 0 ]; then
    echo "Installing dependencies..."
    sudo apt-get install -f -y
    
    echo "Retrying SGPT installation..."
    sudo dpkg -i "sgpt_${VERSION}_${ARCH}.deb"
fi

if [ $? -eq 0 ]; then
    echo "SGPT installation completed successfully."
    rm "sgpt_${VERSION}_${ARCH}.deb"
else
    echo "SGPT installation failed."
    exit 1
fi
