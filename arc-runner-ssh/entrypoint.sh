#!/bin/bash
# Create sshd privilege separation directory (may be wiped by volume mounts)
sudo mkdir -p /run/sshd
sudo chmod 755 /run/sshd

# Start SSH daemon in the background
sudo /usr/sbin/sshd

# Execute the original command
exec "$@"
