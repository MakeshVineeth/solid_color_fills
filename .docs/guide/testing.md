# Testing Guide

Solid Color Fills features an automated multi-tier testing pipeline.

---

## 1. Test Levels

- **Unit Tests**: Test pure business logic, utilities, color algorithms, input sanitizers, and state controllers.
  - `test/unit/color_utils_test.dart`
  - `test/unit/input_validator_test.dart`
  - `test/unit/random_color_generator_test.dart`
  - `test/unit/wallpaper_controller_test.dart`
  - `test/unit/collections_controller_test.dart`
- **Architecture Evaluation Tests**:
  - `test/architecture/clean_architecture_test.dart`: Validates that domain layers never import Flutter UI widgets (`package:flutter/material.dart` or `package:flutter/widgets.dart`).
- **Widget & Screen Tests**:
  - `test/widget/collections_screen_test.dart`
  - `test/widget/color_picker_screen_test.dart`
  - `test/widget/feed_screen_test.dart`
  - `test/widget/wallpaper_confirmation_screen_test.dart`
- **Multi-Device Responsive Tests**:
  - `test/responsive/multi_device_responsive_test.dart`: Simulates rendering across compact phones (320x568), standard phones (390x844), foldables (673x841), tablets (800x1280 and 1280x800), and TV/Desktop (1920x1080) to ensure zero `RenderFlex` overflow errors.

---

## 2. Running Tests

```bash
# Run all automated tests
flutter test

# Run static analysis
flutter analyze

# Run pre-commit PII and secrets scanner
dart run .agents/skills/conventional-commit/bin/scan_pii.dart
```
