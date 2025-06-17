#!/bin/bash

# Update and install required packages
apt update && apt install -y whiptail curl

# Create directory
mkdir -p /usr/local/private-tunnel

# Download main script
curl -sSL https://raw.githubusercontent.com/Mahdi3160/multi-server-tunnel/main/private-tunnel.sh -o /usr/local/private-tunnel/private-tunnel.sh

# Make it executable
chmod +x /usr/local/private-tunnel/private-tunnel.sh

# Create symbolic link for easier access
ln -sf /usr/local/private-tunnel/private-tunnel.sh /usr/local/bin/private-tunnel

echo "Installation complete! Run 'private-tunnel' to start."
