#!/bin/bash

echo "Installing Private Tunnel..."

apt update && apt install -y iproute2 whiptail

mkdir -p /usr/local/private-tunnel
curl -sSL https://raw.githubusercontent.com/username/private-tunnel/main/private-tunnel.sh -o /usr/local/private-tunnel/private-tunnel.sh
chmod +x /usr/local/private-tunnel/private-tunnel.sh

ln -sf /usr/local/private-tunnel/private-tunnel.sh /usr/bin/private-tunnel

echo "Installation complete! Run 'private-tunnel' to start."
