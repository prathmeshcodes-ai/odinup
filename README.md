# OdinUP: The Native Odin Version Manager

C and C++ developers fight their toolchains. Odin developers shouldn't have to.

The Odin language iterates fast. Nightly builds push the `core` library forward on a weekly basis. Managing these compiler binaries manually breaks momentum. You download the zip. You extract the files. You rewrite your system paths. This manual repetition drains focus.

OdinUP removes the friction. It operates as a zero-dependency version manager built from pure Odin. It queries the GitHub API, fetches the exact archive for your hardware, and hot-swaps your active compiler using native execution wrappers.

OdinUP handles the toolchain. You write the code.

## Table of Contents
1. The Architecture
2. Script Installation
3. Installation from Source
4. Command Reference
5. The Wrapper System Logic
6. Project Anatomy
7. Contributing
8. Community
9. License
10. Troubleshooting

## The Architecture

OdinUP relies on systemic integration. It does not reinvent standard operations. It acts as a precise orchestrator for tools your operating system already possesses.

* **Zero External Dependencies:** Built from pure Odin code.
* **Native Downloading:** It utilizes `curl` for secure network requests.
* **Native Extraction:** It invokes `tar` and `unzip`. These utilities ship natively on modern Windows, macOS, and Linux.
* **Path Preservation:** It builds executable wrapper shims instead of raw symlinks. This ensures Odin's standard library resolves accurately against the specific downloaded version.

## Script Installation

The fastest way to get OdinUP running. One command downloads the correct binary for your system, installs it, and configures your shell automatically.

### Linux and macOS

Open your terminal and run:

```bash
curl -fsSL https://raw.githubusercontent.com/prathmeshcodes-ai/odinup/main/install.sh | bash
```

The installer will:
- Detect your OS and CPU architecture automatically
- Fetch the latest release from GitHub
- Install the binary to `~/.odinup/bin/`
- Add OdinUP to your shell PATH permanently (`~/.bashrc`, `~/.zshrc`, etc.)

After installation, restart your terminal or run:

```bash
source ~/.bashrc
```

Then verify it works:

```bash
odinup help
```

### Windows (PowerShell)

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/prathmeshcodes-ai/odinup/main/install.ps1 | iex
```

The installer will:
- Detect your CPU architecture automatically
- Fetch the latest release from GitHub
- Install the binary to `%USERPROFILE%\.odinup\bin\`
- Add OdinUP to your Windows User PATH permanently

Open a new terminal and verify:

```powershell
odinup help
```

### Updating OdinUP

Running the installer again when OdinUP is already installed will detect your current version and offer to update it automatically. No manual steps required.

---

## Installation from Source

You need an existing Odin compiler to build the manager the first time. Once built, OdinUP becomes entirely self-sufficient.

### Step 1: Clone and Build
Navigate to your workspace. Compile the source code. The `-o:speed` flag ensures the manager executes with maximum efficiency.

```bash
git clone https://github.com/prathmeshcodes-ai/odinup.git
cd odinup
odin build . -o:speed 
```

**NOTE:** A prebuilt binary for `linux_amd64` is available in the `./bin` directory. If you have a different target, follow the steps above.

### Step 2: Initialize
Run the executable once. This generates the hidden `.odinup` directory structure on your machine.

```bash
./odinup help
```

### Step 3: Configure Your Shell
OdinUP installs all versions into isolated directories. It exposes a single, static binary path for your terminal. Add this path to your system environment variables.

For Linux and macOS, open your shell profile (`~/.bashrc` or `~/.zshrc`) and append:

```bash
export PATH="$HOME/.odinup/bin:$PATH"
```

Reload your shell.

For Windows, add `%USERPROFILE%\.odinup\bin` to your System PATH variables via the Environment Variables GUI.

## Command Reference

The command-line interface uses strict, readable output. Color-coded syntax prevents visual fatigue.

### odinup list-remote (lr)
Queries the official Odin repository. Prints a chronological list of every available release tag.

**Input:**

```bash
odinup lr
```

**Output:** A descending list from the latest nightly build down to older legacy versions.

### odinup install `<version>` (i)
Locates the specific binary for your exact OS and CPU architecture. Downloads it and extracts the payload into your local version registry.

**Input:**

```bash
odinup i dev-2026-04
```

**Output:** Progress bar execution followed by extraction verification.

### odinup list (ls)
Prints all locally installed compilers. The currently active version is marked with a star and a bold green indicator.

**Input:**

```bash
odinup ls
```

**Output:** Your local roster, highlighting the active toolchain.

### odinup use `<version>` (u)
Swaps the active compiler. This command generates the execution shim.

**Input:**

```bash
odinup use dev-2026-04
```

**Output:** Success confirmation. Your terminal now utilizes the specified version.

### odinup env
Prints the exact path string required to update your system environment variables. Use this for quick copy-pasting or scripting.

## The Wrapper System Logic

Standard version managers attempt to use symbolic links to point a global command toward a specific executable. In the context of Odin, symlinks introduce severe architectural flaws.

Windows requires Administrator privileges to create symlinks. Forcing a developer to elevate their terminal just to swap a compiler version breaks the workflow. Furthermore, the Odin compiler relies on relative path resolution to find its standard library and vendor packages. A raw symlink often tricks the operating system into resolving paths from the symlink's location rather than the target's origin. This causes immediate build failures.

OdinUP bypasses this entirely using Execution Shims.

When you run the use command, the manager creates a physical script inside the binary folder. On Windows, it writes a batch file containing a direct call to the exact executable path. On Linux and macOS, it writes an executable shell script passing process arguments transparently.

The wrapper fires. The compiler boots up knowing its exact location on the hard drive. Path resolution executes perfectly. No admin rights required.

## Project Anatomy

The codebase splits into eight distinct files. This modularity ensures that network logic, file system operations, and CLI routing never entangle.

* **main.odin:** The core router block and entry point.
* **cli.odin:** Argument parsing, color definitions, and the help menu.
* **config.odin:** Determines the home path and ensures the folder tree exists.
* **remote.odin:** Interfaces with the GitHub API to download JSON release payloads.
* **local.odin:** Scans the filesystem to determine installed versions and active states.
* **install.odin:** Matches hardware signatures to GitHub assets and manages the download pipeline.
* **download.odin:** Spawns curl and extraction shell commands for network operations.
* **utils.odin:** Houses the run_command abstraction and the wrapper script generator.

## Contributing

OdinUP welcomes contributions of all kinds — bug fixes, documentation improvements, platform testing, and feature ideas.

Read the full [CONTRIBUTING.md](CONTRIBUTING.md) before submitting a pull request. It covers the development workflow, branch naming, commit message format, and our policy on AI usage in contributions.

## Community

| Document | Description |
|----------|-------------|
| [CONTRIBUTING.md](CONTRIBUTING.md) | How to contribute code, docs, and ideas |
| [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) | Community behavior standards |
| [SECURITY.md](SECURITY.md) | How to report vulnerabilities responsibly |
| [CHANGELOG.md](CHANGELOG.md) | Full history of releases and changes |
| [SUPPORT.md](SUPPORT.md) | Where to get help and how to report bugs |

## License

OdinUP is released under the **Apache License 2.0**.

You are free to use, modify, and distribute this software for any purpose — personal, commercial, or open source — as long as you include the original license and attribution notice. See the [LICENSE](LICENSE) file for the full terms.

## Troubleshooting

**Problem: The terminal says command not found.**
Solution: You have not added the OdinUP binary path to your shell configuration. Run the env command. Copy the output into your shell profile or Windows Environment Variables. Restart your terminal.

**Problem: OdinUP fails to download the release list.**
Solution: Ensure your machine has curl installed. Verify your internet connection. The GitHub API occasionally rate-limits IPs that make too many unauthenticated requests in a short window.

**Problem: A permission denied error occurs when swapping versions.**
Solution: On Linux and macOS, OdinUP attempts to run a modification command on the generated wrapper script. If this fails due to strict user permissions on the parent directory, you must manually grant execution rights to the target file inside the bin directory.