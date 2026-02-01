# WinCC OA DevContainer Makefile
.PHONY: help build up down restart clean logs shell ssh check-zip

# Variables
CONTAINER_NAME := winccoa
WINCCOA_ZIP := installer/WinCCOA-3.21.0-debian.x86_64.zip

# Load .env file if it exists
-include .env
export

# Use defaults if not set in .env
SSH_PORT ?= 2222
WINCCOA_PASSWORD ?= winccoasecret

# Default target - show help
help:
	@echo "========================================="
	@echo "WinCC OA DevContainer - Make Commands"
	@echo "========================================="
	@echo ""
	@echo "Quick Start:"
	@echo "  make build         Build Docker image"
	@echo "  make up            Start containers in background"
	@echo "  make logs          Follow container logs"
	@echo ""
	@echo "Development:"
	@echo "  make down          Stop and remove containers"
	@echo "  make restart       Restart containers"
	@echo "  make shell         Open bash shell in container"
	@echo "  make ssh           Connect via SSH (password: winccoasecret)"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean         Stop containers and remove images"
	@echo "  make clean-all     Clean everything including volumes"
	@echo ""

# Check if WinCC OA ZIP exists
check-zip:
	@if [ ! -f $(WINCCOA_ZIP) ]; then \
		echo "❌ ERROR: $(WINCCOA_ZIP) not found!"; \
		echo "Please download it from https://www.winccoa.com/downloads/"; \
		exit 1; \
	fi
	@echo "✅ WinCC OA ZIP file found"

# Build Docker image
build: check-zip
	@echo "Building WinCC OA DevContainer..."
	docker compose build
	@echo "✅ Build complete!"
	@echo "   Start with: make up"

# Start containers
up:
	@echo "Starting WinCC OA DevContainer..."
	docker compose up -d
	@echo "✅ Container started!"
	@echo "   Connect via SSH: ssh winccoa@localhost -p $(SSH_PORT)"

# Stop containers
down:
	@echo "Stopping containers..."
	docker compose down
	@echo "✅ Containers stopped"

# Restart containers
restart: down up

# Follow logs
logs:
	docker compose logs -f

# Open shell in container
shell:
	@echo "Opening shell in $(CONTAINER_NAME) as user winccoa..."
	docker exec -it -u winccoa $(CONTAINER_NAME) bash || \
		(echo "❌ Container not running. Start with 'make up'" && exit 1)

# SSH into container (requires sshpass)
ssh:
	@command -v sshpass >/dev/null 2>&1 && \
		sshpass -p $(WINCCOA_PASSWORD) ssh -o StrictHostKeyChecking=no winccoa@localhost -p $(SSH_PORT) || \
		(echo "💡 Tip: Install sshpass for passwordless SSH:" && \
		 echo "   sudo apt install sshpass" && \
		 echo "" && \
		 echo "Or connect manually:" && \
		 echo "   ssh winccoa@localhost -p $(SSH_PORT)" && \
		 ssh winccoa@localhost -p $(SSH_PORT))

# Clean up containers and images
clean:
	@echo "Cleaning up containers and images..."
	docker compose down
	docker rmi winccoa:latest 2>/dev/null || true
	@echo "✅ Cleanup complete"

# Clean everything including volumes
clean-all:
	@echo "⚠️  WARNING: This will remove containers, images, AND volumes (SSH keys)!"
	@read -p "Continue? [y/N]: " confirm && [ "$$confirm" = "y" ] || exit 1
	docker compose down -v
	docker rmi winccoa:latest 2>/dev/null || true
	rm -rf ssh-keys/*
	@echo "✅ Full cleanup complete"
