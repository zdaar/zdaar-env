#!/bin/bash

# Script to install SGPT from the latest GitHub release

echo "Fetching the latest release of SGPT..."

release_info=$(curl -s https://api.github.com/repos/tbckr/sgpt/releases/latest)

case "$(uname -m)" in
    x86_64)  deb_arch="amd64" ;;
    arm64)   deb_arch="arm64" ;;
    armhf)   deb_arch="armhf" ;;
    *)       echo "Unsupported architecture"; exit 1 ;;
esac

download_url=$(echo "$release_info" | grep -oP '"browser_download_url": "\K(.*_'$deb_arch'.deb)"' | head -1)

if [ -z "$download_url" ]; then
    echo "Failed to find a downloadable .deb package for SGPT."
    exit 1
fi

echo "Downloading SGPT from $download_url..."
curl -L "$download_url" -o "sgpt_latest_$deb_arch.deb"

echo "Installing SGPT..."
sudo dpkg -i "sgpt_latest_$deb_arch.deb"
sudo apt-get install -f

echo "SGPT installation completed."
