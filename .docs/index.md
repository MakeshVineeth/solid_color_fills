# Solid Color Fills Documentation

Welcome to the technical and architectural documentation for **Solid Color Fills**, an open-source, privacy-first Flutter and Android application enabling users to preview, customize, generate, and apply solid color wallpapers across mobile and multi-window environments.

---

## Key Highlights

- **Clean Architecture & Feature-First**: Cleanly organized into `core` and feature modules (`wallpaper`, `collections`, `color_picker`, `feed`, `onboarding`, `settings`, `shortcuts`).
- **Android 15 & 16 Ready**: Native `WindowCompat.setDecorFitsSystemWindows(window, false)`, display cutout `shortEdges`, and `SystemUiMode.edgeToEdge`.
- **Zero Third-Party Color Dependencies**: Deprecated `random_color` and `flutter_animator` replaced by high-performance pure Dart HSL generator and standard Flutter animations.
- **OWASP Mobile Security**: Strict cleartext prevention (`network_security_config.xml`), disabled backup (`allowBackup="false"`), and input validation (OWASP M4).
- **Responsive Across All Form Factors**: Verified from compact (320x568) to standard phones, foldables, tablets (portrait/landscape), and desktop/TV (1920x1080).

---

## Documentation Structure

```text
.docs/
├── adr/               # Architecture Decision Records
│   ├── 0001-record-architecture-decisions.md
│   ├── 0002-feature-first-clean-architecture.md
│   ├── 0003-replace-discontinued-packages-and-native-styling.md
│   ├── 0004-owasp-mobile-security-and-input-validation.md
│   ├── 0005-reactive-state-management-and-testing-strategy.md
│   └── 0006-android-16-edge-to-edge-display-cutout.md
├── architecture/      # C4 Model Diagrams (Context, Container, Component, Deployment)
│   ├── c4_context.dsl & svg
│   ├── c4_container.dsl & svg
│   ├── c4_component.dsl & svg
│   └── c4_deployment.dsl & svg
└── guide/             # Engineering & Operational Guides
    ├── architecture.md
    ├── security.md
    └── testing.md
```
