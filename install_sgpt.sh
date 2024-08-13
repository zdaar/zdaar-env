#!/bin/bash

echo "Fetching the latest release of SGPT..."

VERSION="2.14.1"
ARCH="amd64"  # Change this to "arm64" or "armhf" if needed
DOWNLOAD_URL="https://github.com/tbckr/sgpt/releases/download/v${VERSION}/sgpt_${VERSION}_${ARCH}.deb"
DEB_FILE="sgpt_${VERSION}_${ARCH}.deb"

echo "Downloading SGPT from $DOWNLOAD_URL..."
if ! curl -L -o "$DEB_FILE" "$DOWNLOAD_URL"; then
    echo "Failed to download SGPT package. Please check your internet connection and try again."
    exit 1
fi

# Check if the downloaded file is valid
if ! dpkg-deb -I "$DEB_FILE" > /dev/null 2>&1; then
    echo "The downloaded package appears to be corrupt or incomplete. Removing the file and exiting."
    rm -f "$DEB_FILE"
    exit 1
fi

echo "Installing SGPT..."
if sudo dpkg -i "$DEB_FILE"; then
    echo "SGPT installation completed successfully."
    rm -f "$DEB_FILE"
else
    echo "SGPT installation failed. Attempting to install dependencies..."
    sudo apt-get install -f -y
    if sudo dpkg -i "$DEB_FILE"; then
        echo "SGPT installation completed successfully after installing dependencies."
        rm -f "$DEB_FILE"
    else
        echo "SGPT installation failed. Please check the error messages above."
        exit 1
    fi
fi
