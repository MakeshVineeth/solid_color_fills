# 2. Feature-First Clean Architecture

Date: 2026-11-19

## Status
Accepted

## Context
The legacy application coupled UI widgets directly with SharedPreferences, Riverpod state providers, and platform methods across sprawling directories (`lib/database/`, `lib/UI/`). Testing was absent, and modifying features carried risks of regressions.

## Decision
We refactored the entire codebase into Clean Architecture with a Feature-First structure:
- `lib/src/core/`: Cross-cutting concerns (constants, navigation, security, storage, theme, utils, widgets).
- `lib/src/features/<feature>/`: Divided into `domain/` (pure entities and repository contracts), `data/` (implementations, canvas generation, platform calls), and `presentation/` (state controllers, screens, widgets).
- Domain layers are forbidden from importing `package:flutter/*`.

## Consequences
- Single Responsibility Principle (SRP) and Dependency Inversion Principle (DIP) are strictly enforced.
- Repositories are easily mocked with test doubles.
- Code is modular, maintainable, and verifiable.
