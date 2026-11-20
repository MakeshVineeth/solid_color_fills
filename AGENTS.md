# AGENTS.md — Solid Color Fills Agent Operational & Engineering Guidelines

Welcome to the **Solid Color Fills** repository. This document serves as the single source of truth for AI agents and human contributors regarding architectural rules, design patterns, coding standards, security, and verification workflows.

---

## 1. Architectural Principles & SOLID Guidelines

Solid Color Fills adheres strictly to **Clean Architecture** organized by a **Feature-First** structure under `lib/src/`:

- **Single Responsibility Principle (SRP)**: Each class, widget, and service must have exactly one reason to change. Business logic, state management, canvas image encoding, wallpaper platform interactions, and UI rendering are strictly decoupled.
- **Open/Closed Principle (OCP)**: Wallpaper targets, color palettes, and random color generators use polymorphism and extensible strategy patterns. Adding new wallpaper target modes (e.g. ambient display or wearable sync) must not modify existing stable evaluators.
- **Liskov Substitution Principle (LSP)**: Repositories and external service interfaces (e.g., `WallpaperRepository`, `PreferencesService`) must be fully substitutable with test doubles/mocks.
- **Interface Segregation Principle (ISP)**: Clients depend only on focused, narrow interfaces rather than monolithic service classes.
- **Dependency Inversion Principle (DIP)**: High-level business use cases depend on abstract domain interfaces, never on concrete Android platform channels, file systems, or SharedPreferences.

### Directory Organization
```text
lib/
  main.dart
  src/
    app.dart
    core/
      constants/       # Global constants, operational tokens, fixed values, color palette
      navigation/      # App routes and navigation handlers
      security/        # OWASP security utilities, sanitization, secure window manager
      storage/         # Local preferences abstractions & SharedPreferences implementations
      theme/           # Material 3 dynamic themes, colors, typography
      utils/           # Pure formatting, color utilities, platform helpers, structured logger
      widgets/         # Reusable atomic UI components (dialogs, buttons, responsive wrappers)
    features/
      wallpaper/       # Domain (entities, repo), Data (canvas service, repo impl), Presentation (controller, screen)
      collections/     # Domain (entity), Presentation (controller, screen, grid card)
      color_picker/    # Presentation (controller, screen, dialogs, sliders, palette)
      feed/            # Domain (random color generator), Presentation (controller, screen)
      onboarding/      # Presentation (screen, controller)
      settings/        # Presentation (about, troubleshooting, theme chooser, menu sheet)
      shortcuts/       # Services (quick actions / app shortcuts)
```

---

## 2. Code Quality & Complexity Limits

- **Cognitive & Cyclomatic Complexity**:
  - Cyclomatic complexity must not exceed **10** per function/method.
  - Cognitive complexity must not exceed **15**.
  - Avoid deeply nested `if-else` or switch cascades. Decompose complex logic into lookup maps, helper transformers, or dedicated rules.
- **Commentary Rule**:
  - Do NOT clutter code with verbose line-by-line commentary. Code must be expressive and self-documenting with descriptive naming.
  - Architectural rationale, trade-offs, and specifications belong in `.docs/` and Architecture Decision Records (ADRs).
- **Static Analysis & Linters**:
  - `analysis_options.yaml` is enforced at build time with strict mode (`strict-casts`, `strict-inference`, `strict-raw-types`).
  - Zero warnings, zero errors permitted on `flutter analyze`.
  - Always prefer `const` constructors and immutable models.
  - Never call `print()` in production; use structured `AppLogger` or debug-only handlers.

---

## 3. OWASP Mobile Top 10 & Secure Coding Standards

1. **Input Validation (OWASP M4)**:
   - Sanitize all hex strings and user inputs via `InputValidator` before color conversion to prevent invalid formats or unexpected exceptions.
2. **Network Security (OWASP M5 & M8)**:
   - All external HTTP calls must use HTTPS with strict timeouts.
   - Cleartext HTTP traffic is explicitly prohibited via Android `network_security_config.xml`.
3. **Data Storage & Privacy (OWASP M6 & M9)**:
   - User preferences and state are stored locally on device via `SharedPreferences`.
   - Never log or transmit user wallpaper choices or telemetry off-device.
4. **Android Platform Protections (OWASP M7 & M8)**:
   - Sensitive screen protection (`WindowSecurityManager` with `FLAG_SECURE`) is supported.
   - Backup is restricted (`android:allowBackup="false"`).
   - Display Cutout mode is set to `shortEdges` for full Android 15 & 16 compliance.

---

## 4. State Management Guidelines

- State is managed via reactive, predictable patterns (`ChangeNotifier` / `Provider`).
- Business logic is isolated from Flutter UI widgets.
- Widgets observe state via narrow listeners (`Consumer`, `context.select()`, or `context.read()`) to avoid unnecessary widget rebuilds.
- State objects must properly dispose resources (`dispose()`, stream subscriptions, controllers).

---

## 5. Agent Workflow & Conventional Commits

- Agents working on this codebase must check `.agents/` for active skills and evaluation suites.
- All commits must strictly follow the **Conventional Commits 1.0.0** specification (`type(scope): description`).
- Prior to every commit, the agent must run the **PII & Secrets Scan**:
  ```bash
  dart run .agents/skills/conventional-commit/bin/scan_pii.dart
  ```
- Run `flutter analyze` and `flutter test` to ensure clean builds before completing tasks.
