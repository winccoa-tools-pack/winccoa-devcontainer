#!/bin/bash
# Build script for WinCC OA DevContainer
set -e

echo "========================================="
echo "Building WinCC OA DevContainer"
echo "========================================="

# Check if WinCC OA ZIP exists
if [ ! -f installer/WinCCOA-3.21.0-debian.x86_64.zip ]; then
    echo "❌ ERROR: installer/WinCCOA-3.21.0-debian.x86_64.zip not found!"
    echo "Please download it from https://www.winccoa.com/downloads/"
    echo "and place it in the installer/ directory."
    exit 1
fi

# Build image
docker compose build

echo ""
echo "✅ Build successful!"
echo ""
echo "Next steps:"
echo "  Start container:  docker compose up -d"
echo "  View logs:        docker compose logs -f"
echo "  Or use Makefile:  make up"
