# Contributing to OdinUP

First off — thank you for taking the time to contribute. OdinUP is a community-driven tool and every improvement, bug report, and idea matters.

## Table of Contents
1. Code of Conduct
2. Ways to Contribute
3. Getting Started
4. Development Workflow
5. Commit Message Guidelines
6. Pull Request Process
7. AI Usage Policy
8. Reporting Bugs
9. Suggesting Features
10. Community Files

---

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md). Please read it before contributing.

---

## Ways to Contribute

You do not need to write code to contribute. There are many valuable ways to help:

- **Report a bug** — open an issue with a clear description and reproduction steps
- **Fix a bug** — pick up an open issue labeled `bug` and submit a pull request
- **Improve documentation** — typos, unclear sections, missing examples
- **Suggest a feature** — open a discussion or issue with your idea
- **Test on your platform** — OdinUP targets Linux, macOS, and Windows; real-world testing is invaluable
- **Review pull requests** — share constructive feedback on open PRs

---

## Getting Started

### Prerequisites

You need an existing Odin compiler to build OdinUP from source.

```bash
# Clone the repository
git clone https://github.com/prathmeshcodes-ai/odinup.git
cd odinup

# Build the project
odin build . -o:speed
```

### Project Structure

```
odinup/
├── main.odin       # Entry point and CLI router
├── cli.odin        # Argument parsing and help menu
├── config.odin     # Home path and directory setup
├── remote.odin     # GitHub API integration
├── local.odin      # Installed version scanning
├── install.odin    # Download pipeline and asset matching
├── download.odin   # curl and extraction commands
└── utils.odin      # run_command and wrapper script generator
```

---

## Development Workflow

1. **Fork** the repository on GitHub
2. **Clone** your fork locally
3. **Create a branch** for your change — use a descriptive name:

```bash
git checkout -b fix/download-progress-bar
git checkout -b feat/pin-version-command
git checkout -b docs/improve-troubleshooting
```

4. **Make your changes** — keep them focused and minimal
5. **Test your changes** manually across platforms if possible
6. **Commit** your changes following the commit guidelines below
7. **Push** your branch and open a pull request

---

## Commit Message Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) standard. This keeps the changelog clean and readable.

### Format

```
<type>: <short description>
```

### Types

| Type | When to use |
|------|-------------|
| `feat` | A new feature or command |
| `fix` | A bug fix |
| `docs` | Documentation changes only |
| `refactor` | Code restructuring without behavior change |
| `chore` | Build scripts, CI, tooling changes |
| `test` | Adding or fixing tests |

### Examples

```
feat: add odinup pin command for locking compiler version
fix: resolve wrapper path resolution on Windows ARM64
docs: add troubleshooting entry for curl rate limiting
chore: update CI to use odin release latest
```

---

## Pull Request Process

1. Make sure your branch is up to date with `main` before opening a PR
2. Fill out the pull request template completely
3. Link any related issues in the description using `Closes #<issue number>`
4. Keep pull requests focused — one logical change per PR
5. Be responsive to review feedback
6. A maintainer will merge your PR once it is approved

---

## AI Usage Policy

We have a clear and honest stance on AI tools in this project.

### ✅ AI is allowed for:

- **Documentation** — drafting or improving README sections, guides, and comments
- **Commit messages** — generating clear, well-formatted conventional commit messages
- **Grammar and clarity** — proofreading and rephrasing written content
- **Boilerplate** — generating repetitive non-critical structures like markdown tables or config templates
- **Research and understanding** — using AI to understand a concept, API, or error before writing the solution yourself

The rule is simple: AI is welcome where it saves time on things that **cannot break the project**. Writing words is safe. Writing logic is not.

### ❌ AI is not allowed for:

- **Source code** — do not use AI to generate or modify any `.odin` files
- **Bug fixes** — the fix must come from your own understanding of the problem
- **CI/CD and build scripts** — do not use AI to generate GitHub Actions workflows or install scripts
- **Security-sensitive logic** — any code touching downloads, file writes, or PATH modification must be written and understood by a human

### Why this rule exists

AI-generated code looks correct and fails silently. In a tool that manages compiler binaries and modifies shell profiles, a subtle logic error causes real damage to a developer's machine. Every line of Odin in this project must be written by someone who understands exactly what it does.

Documentation errors are easy to spot and fix. Code errors are not. That is where we draw the line.

---

## Reporting Bugs

Open an issue and include:

- **Your OS and architecture** (e.g. Linux amd64, Windows ARM64)
- **OdinUP version** — run `odinup --version` or check `~/.odinup/.version`
- **Steps to reproduce** the problem exactly
- **What you expected** to happen
- **What actually happened** — paste the full error output

---

## Suggesting Features

Open an issue with the label `enhancement` and describe:

- **The problem** you are trying to solve
- **Your proposed solution**
- **Alternatives you considered**

We review all suggestions. Even if an idea is not immediately accepted, it shapes the project roadmap.

---

## Community Files

| Document | Description |
|----------|-------------|
| [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) | Community behavior standards |
| [SECURITY.md](SECURITY.md) | How to report vulnerabilities responsibly |
| [CHANGELOG.md](CHANGELOG.md) | Full history of releases and changes |
| [SUPPORT.md](SUPPORT.md) | Where to get help and how to report bugs |

---

## License

By contributing to OdinUP, you agree that your contributions will be licensed under the [Apache License 2.0](LICENSE).