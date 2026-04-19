# Changelog

All notable changes to OdinUP will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/). OdinUP uses [Semantic Versioning](https://semver.org/).

---

## [v0.1.1] - 2026-04-19

### Fixed
- CI workflow now uses `release: latest` for `laytan/setup-odin@v2` — `release: dev` caused "Not Found" errors across all build jobs
- Fixed syntax errors in `install.sh` — missing spaces after `if` keyword caused parse failures on all platforms
- Fixed `Join-Path` call in `install.ps1` — `GetTempPath()` now correctly wrapped in parentheses

---

## [v0.1.0] - 2026-04-19

### Added
- Initial release of OdinUP
- `install` / `i` — download and install any Odin compiler release by tag
- `use` / `u` — swap the active compiler version using execution shims
- `list` / `ls` — display all locally installed compiler versions
- `list-remote` / `lr` — query GitHub API for all available Odin releases
- `env` — print the PATH configuration string for shell setup
- Execution shim system for Windows (`.bat`) and Unix (shell script) — no symlinks, no admin rights required
- Script installer for Linux and macOS (`install.sh`)
- Script installer for Windows PowerShell (`install.ps1`)
- GitHub Actions CI/CD pipeline — builds for Linux amd64/arm64, macOS amd64/arm64, Windows amd64/i386
- Zero external dependencies — pure Odin with native `curl`, `tar`, and `unzip`
