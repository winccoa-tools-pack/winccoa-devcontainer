#!/bin/bash
# Clean up script for WinCC OA DevContainer
set -e

echo "========================================="
echo "Cleaning WinCC OA DevContainer"
echo "========================================="

# Stop and remove containers
echo "Stopping containers..."
docker compose down

# Optional: Remove volumes (SSH keys, projects)
read -p "Remove persistent volumes (ssh-keys)? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Removing volumes..."
    docker compose down -v
    rm -rf ssh-keys/*
    echo "✅ Volumes removed"
else
    echo "⏭️  Volumes kept"
fi

# Optional: Remove images
read -p "Remove Docker images? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Removing images..."
    docker rmi winccoa:latest 2>/dev/null || true
    echo "✅ Images removed"
else
    echo "⏭️  Images kept"
fi

echo ""
echo "✅ Cleanup complete!"
