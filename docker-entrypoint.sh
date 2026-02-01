#!/bin/bash
set -e

# Make SSH host keys persistent
if [ ! -f /ssh-keys/ssh_host_rsa_key ]; then
    echo "Generating SSH host keys (one-time)..."
    ssh-keygen -A
    cp /etc/ssh/ssh_host_* /ssh-keys/
else
    echo "Using existing SSH host keys..."
    cp /ssh-keys/ssh_host_* /etc/ssh/
fi

# Start SSH daemon
echo "Starting SSH daemon..."
/usr/sbin/sshd

echo "========================================="
echo "WinCC OA Container Ready"
echo "Switching to user: winccoa"
echo "========================================="

# Switch to winccoa user and execute command
cd /home/winccoa/WinCCOA_Proj
exec gosu winccoa "$@"
