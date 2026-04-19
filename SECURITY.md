# Security Policy

## Supported Versions

Only the latest release of OdinUP receives security fixes.

| Version | Supported |
|---------|-----------|
| Latest  | ✅ Yes     |
| Older   | ❌ No      |

---

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

If you discover a security vulnerability in OdinUP, report it responsibly by opening a [GitHub Security Advisory](https://github.com/prathmeshcodes-ai/odinup/security/advisories/new) on this repository. This keeps the report private until a fix is ready.

Include the following in your report:

- A clear description of the vulnerability
- Steps to reproduce the issue
- The potential impact
- Your suggested fix if you have one

You will receive a response within **72 hours** acknowledging the report. We will keep you updated as we work on a fix and will credit you in the release notes unless you prefer to remain anonymous.

---

## Security Considerations

OdinUP downloads compiler binaries from GitHub Releases over HTTPS. It uses the official GitHub API to resolve asset URLs and does not execute any downloaded code beyond the Odin compiler binary itself.

If you notice any behavior that deviates from this — such as unexpected network requests or file system writes outside `~/.odinup` — please report it immediately.
