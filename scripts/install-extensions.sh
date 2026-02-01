#!/bin/bash
# Install recommended VS Code extensions for Remote-SSH
# Run this after connecting to the container via Remote-SSH

echo "==========================================="
echo "Installing WinCC OA Extensions for VS Code"
echo "==========================================="

EXTENSIONS=(
    "richardjanisch.winccoa-project-admin"
    "richardjanisch.winccoa-vscode-logviewer"
    "richardjanisch.winccoa-ctrllang"
    "richardjanisch.winccoa-mcp-server"
    "richardjanisch.winccoa-script-actions"
    "richardjanisch.winccoa-vscode-tests"
)

for ext in "${EXTENSIONS[@]}"; do
    echo "Installing $ext..."
    code --install-extension "$ext" --force
done

echo ""
echo "✅ All extensions installed!"
echo "   Reload VS Code window to activate them."
