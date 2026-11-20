# Architecture Guide

Solid Color Fills is designed around **Clean Architecture** and a **Feature-First** structure.

---

## 1. Directory Structure

```text
lib/
├── l10n/                 # Localization generated files and ARB definitions
├── main.dart             # Application entrypoint & edge-to-edge bootstrap
└── src/
    ├── app.dart          # MultiProvider DI, AdaptiveTheme, MaterialApp
    ├── core/             # Cross-cutting primitives
    │   ├── constants/    # Fixed values, palette lists, tokens
    │   ├── navigation/   # Routes and navigation wrappers
    │   ├── security/     # Input validation, FLAG_SECURE
    │   ├── storage/      # SharedPreferences abstraction
    │   ├── theme/        # Light and dark Material 3 themes
    │   ├── utils/        # ColorUtils, PlatformUtils, AppLogger
    │   └── widgets/      # Reusable UI widgets & responsive wrappers
    └── features/         # Decoupled domain/data/presentation features
        ├── collections/  # Curated solid color palette with search
        ├── color_picker/ # Custom studio (RGB, Hex, HSV wheel)
        ├── feed/         # Infinite random color feed
        ├── home/         # Bottom navigation shell
        ├── onboarding/   # First-launch introduction
        ├── settings/     # Theme, About, Troubleshooting
        ├── shortcuts/    # Quick Actions (Android App Shortcuts)
        └── wallpaper/    # Canvas rendering & Android WallpaperManager
```

---

## 2. SOLID Adherence

- **SRP (Single Responsibility)**: UI widgets handle presentation only. Controllers manage state. Repositories communicate with platform channels.
- **OCP (Open/Closed)**: Targets and color generators are polymorphic strategies.
- **LSP (Liskov Substitution)**: Domain interfaces (`WallpaperRepository`, `PreferencesService`) are substitutable with test doubles.
- **ISP (Interface Segregation)**: Granular interfaces without bloated contracts.
- **DIP (Dependency Inversion)**: High-level use cases depend on domain abstractions injected via Provider.
