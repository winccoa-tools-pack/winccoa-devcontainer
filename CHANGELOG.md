# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-02-01

### Added
- Initial release of WinCC OA DevContainer
- Multi-stage Dockerfile for optimized image size
- Docker Compose configuration with persistent volumes
- SSH server with persistent host keys
- User `winccoa` setup (non-root) for PostgreSQL compatibility
- VS Code Remote-SSH support with auto-extension installation
- `.devcontainer/devcontainer.json` for automatic WinCC OA extension setup
- Project folder mounting support (`projects/`)
- English locale configuration (`en_US.UTF-8`)
- Comprehensive README with quick start guide
- MIT License

### Fixed
- PostgreSQL "cannot run as root" issue by using `gosu` to switch to `winccoa` user
- SSH host key persistence across container rebuilds

### Security
- Default passwords set to `winccoasecret` (documented in README)
- SSH key persistence in `ssh-keys/` volume

[unreleased]: https://github.com/winccoa-tools-pack/winccoa-devcontainer/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/winccoa-tools-pack/winccoa-devcontainer/releases/tag/v0.1.0
