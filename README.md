# WinCC OA DevContainer

<div align="center">

![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Docker](https://img.shields.io/badge/docker-required-2496ED.svg)

**Docker-based development environment for WinCC OA with VS Code Remote support**

[Features](#-features) • [Quick Start](#-quick-start) • [Prerequisites](#-prerequisites) • [Troubleshooting](#-troubleshooting)

</div>

---

## 🎯 Features

- ✅ **Complete WinCC OA Environment** - Event Manager, Data Manager, PostgreSQL NextGen Archive
- ✅ **VS Code Remote SSH** - Full IDE integration with automatic extension installation
- ✅ **PostgreSQL Fix** - Runs as non-root user (`winccoa`) for proper PostgreSQL operation
- ✅ **Persistent SSH Keys** - No certificate warnings after rebuilds
- ✅ **Locale Support** - Pre-configured `en_US.UTF-8` for WinCC OA projects
- ✅ **Hot Reload Ready** - Mount your projects as volumes for live development
- ✅ **Cross-Platform** - Works on Linux and Windows (WSL2)

---

## 🚀 Why This Project?

**Problem:** Setting up WinCC OA development environments is time-consuming and error-prone:
- Manual installation on every developer machine
- "Works on my machine" issues
- Complex PostgreSQL configuration (cannot run as root)
- Missing locale settings causing runtime errors
- No standardized development workflow

**Solution:** This DevContainer provides:
- 🐳 **Consistent Environment** - Everyone works with the exact same setup
- ⚡ **5-Minute Setup** - From clone to coding in one `docker compose up`
- 🔧 **VS Code Integration** - Full IDE support with WinCC OA extensions pre-installed
- 🔄 **Version Control Ready** - Share container config, not installation files
- 🛠️ **Production-Like** - Same runtime as deployment servers

---

## 📋 Prerequisites

### Required Software
- Docker Desktop (Windows/Mac) or Docker Engine (Linux)
- Docker Compose v2+
- VS Code with Remote-SSH extension

### WinCC OA Installation File
⚠️ **IMPORTANT:** You need to download the WinCC OA installation ZIP **manually** from the Siemens WinCC OA Portal.

1. Go to https://www.winccoa.com/downloads/
2. Download: **WinCC OA 3.21 for Debian Linux (x86_64)**
   - File name: `WinCCOA-3.21.0-debian.x86_64.zip` (or similar)
3. Place the ZIP file in the **`installer/`** directory
4. **DO NOT commit this file** - it's already in `.gitignore`

---

## 🚀 Quick Start

### 1. Clone and Prepare

```bash
git clone https://github.com/winccoa-tools-pack/winccoa-devcontainer.git
cd winccoa-devcontainer

# Place your WinCC OA ZIP file in the installer/ directory
# Expected: installer/WinCCOA-3.21.0-debian.x86_64.zip

# Optional: Customize passwords and ports
cp .env.example .env
# Edit .env to change passwords (default: winccoasecret)
```

### 2. Add Your Project (Optional)

```bash
# Copy your WinCC OA project to the projects/ folder
cp -r /path/to/your/project projects/MyProject
```

Or create a new project after the container is running.

### 3. Build and Start

**Option A: Using Makefile (Recommended)**
```bash
make build    # Build Docker image
make up       # Start container
make logs     # View logs (optional)
```

**Option B: Using Scripts**
```bash
./scripts/build.sh           # Build image
docker compose up -d         # Start container
docker compose logs -f       # View logs (optional)
```

**First build takes ~5-10 minutes** (downloads packages, installs WinCC OA)

> 💡 **Tip:** Run `make` to see all available commands

### 4. Connect with VS Code

1. Open VS Code
2. Install **Remote-SSH** extension (`ms-vscode-remote.remote-ssh`)
3. `Ctrl+Shift+P` → `Remote-SSH: Connect to Host`
4. Enter: `winccoa@localhost -p 2222`
5. Password: `winccoasecret`

**🎉 Extensions auto-install on first connect:**

When VS Code connects, it automatically installs these extensions:
- **WinCC OA Project Admin** - Create and manage WinCC OA projects
- **WinCC OA LogViewer** - View and analyze WinCC OA logs in real-time
- **WinCC OA CTL Language** - Syntax highlighting and IntelliSense for `.ctl` files
- **WinCC OA Script Actions** - Run CTL scripts directly from VS Code
- **WinCC OA Tests** - Test framework integration
- **WinCC OA MCP Server** - Model Context Protocol server

> 💡 **Tip:** VS Code will prompt you to install recommended extensions. Click "Install All" to get started quickly!

### 5. Working with Projects

Once connected to the container via Remote-SSH:

#### Option A: Open Existing Project
1. In VS Code, navigate to **File → Open Folder**
2. Browse to `/home/winccoa/WinCCOA_Proj/YourProject`
3. Click **OK** - VS Code reloads with the project

#### Option B: Create New Project
1. Open the **WinCC OA Project Admin** extension (sidebar icon)
2. Click **"Create New Project"**
3. Enter project name and select path: `/home/winccoa/WinCCOA_Proj/MyNewProject`
4. Configure managers (Event, Data, UI) as needed
5. Click **Create** - project is ready to use

#### Option C: Add Project via Terminal
```bash
# Inside VS Code terminal (already connected to container)
cd /home/winccoa/WinCCOA_Proj
# Copy from host (if mounted)
cp -r /path/to/project ./MyProject
# Or create manually
mkdir MyProject && cd MyProject
# Initialize WinCC OA project structure here
```

**Tips:**
- Use **WinCC OA LogViewer** extension to monitor runtime logs in real-time
- **CTL Language** extension provides syntax highlighting and IntelliSense for `.ctl` files
- **Script Actions** extension allows running CTL scripts directly from VS Code
- All changes in `/home/winccoa/WinCCOA_Proj/` are automatically synced if you mounted `./projects` as volume

---

## 📂 Project Structure

```
winccoa-devcontainer/
├── .devcontainer/
│   └── devcontainer.json         # DevContainer config (auto-installs extensions)
├── .vscode/
│   ├── extensions.json           # Recommended extensions for all users
│   └── settings.json             # Workspace settings (terminal, line endings)
├── .env.example                  # Environment variables template
├── installer/                    # 🔸 Place WinCC OA ZIP file here
│   └── README.md                 # Installation instructions
├── projects/                     # 🔸 Place your WinCC OA projects here
│   └── .gitkeep
├── scripts/                      # 🔧 Helper scripts (alternative to Makefile)
│   ├── build.sh                  # Build script with ZIP validation
│   └── clean.sh                  # Interactive cleanup script
├── ssh-keys/                     # 🔸 Persistent SSH host keys
│   └── .gitkeep
├── CHANGELOG.md                  # Version history (Keep a Changelog format)
├── Dockerfile                    # Container image definition (multi-stage)
├── docker-compose.yml            # Service orchestration
├── docker-entrypoint.sh          # Startup script (root→winccoa user switch)
├── LICENSE                       # MIT License
├── Makefile                      # 🔧 Build automation (make build, make up, etc.)
├── README.md                     # This file
├── installer/                    # ⚠️ Download WinCC OA ZIP here (not in repo!)
    └── WinCCOA-3.21.0-debian.x86_64.zip
├── VERSION                       # Current version (semantic versioning)
└── WinCCOA-3.21.0-debian.x86_64.zip  # ⚠️ Download manually (not in repo!)
```

### Key Directories

- **`.devcontainer/`** - VS Code DevContainer config (auto-installs extensions when connecting)
- **`installer/`** - Place the WinCC OA ZIP file here (gitignored)
- **`.vscode/`** - Workspace settings and recommended extensions for all users
- **`projects/`** - Mount your WinCC OA projects here (gitignored except `.gitkeep`)
- **`scripts/`** - Helper scripts for building and cleaning
- **`ssh-keys/`** - Auto-generated SSH host keys (persistent across rebuilds)

---

## 🔧 Configuration

### Environment Variables (.env)

All passwords and ports can be customized via `.env` file:

```bash
# Copy example configuration
cp .env.example .env

# Edit .env with your preferred values
nano .env
```

**Available options:**

| Variable | Default | Description |
|----------|---------|-------------|
| `WINCCOA_PASSWORD` | `winccoasecret` | Password for `winccoa` user (SSH/sudo) |
| `ROOT_PASSWORD` | `winccoasecret` | Password for `root` user |
| `SSH_PORT` | `2222` | Host port for SSH access |
| `WINCCOA_EVENT_PORT` | `4999` | Event Manager port |
| `WINCCOA_UI_PORT` | `5678` | UI Manager port |
| `WINCCOA_DIST_PORT` | `4777` | Distribution Manager port |

**Security Note:** The `.env` file is gitignored and won't be committed. Change passwords before production use!

### Default Credentials

If you don't create a `.env` file, these defaults are used:

| Service | User | Password |
|---------|------|----------|
| SSH | `winccoa` | `winccoasecret` |
| Root | `root` | `winccoasecret` |

### Ports

Default port mapping (customizable via `.env`):

| Host Port | Container Port | Service |
|-----------|----------------|---------|
| 2222 | 22 | SSH (VS Code Remote) |
| 4999 | 4999 | WinCC OA Event Manager |
| 5678 | 5678 | WinCC OA UI Manager |
| 4777 | 4777 | WinCC OA Distribution |

### Additional Configuration

```yaml
# In docker-compose.yml (optional)
environment:
  - LANG=en_US.UTF-8
  - LC_ALL=en_US.UTF-8
```

---

## 🐛 Troubleshooting

### "PostgreSQL cannot be run as root"

✅ **Fixed in this container!**  
The container runs as user `winccoa` (not root) to allow PostgreSQL to start properly.

Verify:
```bash
docker exec winccoa-container whoami
# Should output: winccoa (not root)
```

### SSH Key Changed Warnings

✅ **Fixed with persistent keys!**  
SSH keys are stored in `ssh-keys/` and survive rebuilds.

If you still get warnings:
```bash
ssh-keygen -R "[localhost]:2222"
```

### VS Code Extensions Not Installing

1. Check `.devcontainer/devcontainer.json` exists
2. Ensure `"remoteUser": "winccoa"` is set
3. Kill VS Code server: `Ctrl+Shift+P` → `Remote-SSH: Kill VS Code Server on Host`
4. Reconnect

### Container Won't Start

Check logs:
```bash
docker compose logs -f
```

Common issues:
- Missing WinCC OA ZIP file
- Incorrect ZIP file name in Dockerfile
- Port conflicts (2222, 4999, etc. already in use)

### Project Not Found

If your project is in `projects/` but not visible:
1. Container mounts `projects/` to `/home/winccoa/WinCCOA_Proj/`
2. Connect via SSH and check:
   ```bash
   ls -la /home/winccoa/WinCCOA_Proj/
   ```

---

## 🏗️ Advanced Usage

### Make Commands (Recommended)

```bash
make              # Show all available commands

# Quick Start
make build        # Build Docker image
make up           # Start container
make logs         # Follow container logs

# Development
make down         # Stop container
make restart      # Restart container
make shell        # Open bash shell in container (as winccoa user)
make ssh          # Connect via SSH (password: winccoasecret)

# Cleanup  
make clean        # Remove containers and images
make clean-all    # Remove everything including volumes (⚠️ deletes SSH keys)
```

### Alternative: Shell Scripts

If you prefer scripts or don't have `make`:

```bash
./scripts/build.sh     # Build image (checks for WinCC OA ZIP)
./scripts/clean.sh     # Interactive cleanup (asks before deleting)
```

Then use Docker Compose:
```bash
docker compose up -d        # Start
docker compose down         # Stop
docker compose logs -f      # View logs
```

### Custom WinCC OA Version

Edit `Dockerfile` line 9:
```dockerfile
COPY WinCCOA-3.21.0-debian.x86_64.zip /tmp/
```

Replace with your version's filename.

### Additional Packages

Add to `Dockerfile` after line 23:
```dockerfile
RUN apt-get update && apt-get install -y \
    your-package-here \
    && rm -rf /var/lib/apt/lists/*
```

### Volume Mount Instead of COPY

For live project editing, edit `docker-compose.yml`:
```yaml
volumes:
  # Uncomment this to mount projects dynamically
  - ./projects:/home/winccoa/WinCCOA_Proj
  - ./ssh-keys:/ssh-keys
```

**Note:** Rebuild required after uncommenting!

---

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'feat: add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

---

## 📜 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## ⚠️ Disclaimer

**WinCC OA** and **Siemens** are trademarks of Siemens AG. This project is not affiliated with, endorsed by, or sponsored by Siemens AG. This is a community-driven open source project created to enhance the development experience for WinCC OA developers.

---

## 🎉 Acknowledgments

Special thanks to:
- **[winccoa-tools-pack](https://github.com/winccoa-tools-pack)** community
- **[Martin Pokorny](https://github.com/mPokornyETM)** - Docker build pipeline inspiration
- All contributors who make WinCC OA development better!

---

<div align="center">
Made with ❤️ by the WinCC OA Community
</div>
