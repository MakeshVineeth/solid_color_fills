---
name: conventional-commit-and-pii-scan
description: Enforces Conventional Commits 1.0.0 format and performs pre-commit PII/secrets scanning for all git commits.
version: 1.0.0
---

# Conventional Commit & PII Scan Skill

## Purpose
This skill ensures that all changes committed to the Solid Color Fills repository adhere to standard Conventional Commits 1.0.0 specifications, and guarantees that no Personally Identifiable Information (PII), credentials, private keys, or API tokens are leaked into the git history.

---

## 1. Conventional Commit Specification

Every commit message must follow this exact structure:

```text
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Allowed Types
- `feat`: A new feature or capability introduced for the user or system.
- `fix`: A bug fix.
- `refactor`: A code change that neither fixes a bug nor adds a feature (e.g., restructuring, SOLID improvements).
- `perf`: A code change that improves execution or rendering performance.
- `test`: Adding missing tests or correcting existing tests.
- `docs`: Documentation-only changes (including `.docs/`, ADRs, and README).
- `chore`: Routine maintenance, updating build tasks, package manager dependencies, or configs.
- `style`: Changes that do not affect the meaning of the code (formatting, white-space, semicolon fixes).
- `ci`: Changes to CI/CD configuration files and automation scripts.

### Allowed Scopes
- `wallpaper`: Canvas rendering, image encoding, wallpaper manager platform channels.
- `collections`: Curated palette, grid card, color search.
- `color_picker`: RGB sliders, material palette, advanced HSV wheel.
- `feed`: Random color generator, infinite feed.
- `ui`: Reusable UI components, themes, layouts, animations.
- `security`: OWASP security hardening, input validation, window manager.
- `deps`: Pub package updates or dependency replacements.
- `docs`: Architecture docs, ADRs, diagrams, and README.

---

## 2. Pre-Commit PII & Secrets Scanning Procedure

Before any commit is finalized, the agent MUST run the PII and Secrets Scanner:

```bash
dart run .agents/skills/conventional-commit/bin/scan_pii.dart
```

If the scanner detects any potential PII or secret, the commit MUST BE ABORTED immediately and the offending string must be removed or sanitized before proceeding.
