---
name: clean-architecture-and-solid-standards
description: Enforces SOLID design principles, clean architecture layer isolation, and Flutter recommended patterns for Solid Color Fills.
version: 1.0.0
---

# Clean Architecture & SOLID Standards Skill

## Purpose
Enforces modular feature-first Clean Architecture, strict SOLID adherence, and complexity management for all features added or modified in Solid Color Fills.

## Rules & Invariants
1. **Layer Separation**:
   - `domain/`: Pure business logic, value objects, entities, and abstract repository contracts. No Flutter UI imports (`package:flutter/material.dart`, `package:flutter/widgets.dart` are forbidden in domain layer).
   - `data/`: Concrete implementations of repository contracts, data sources (WallpaperManagerPlus, CanvasImageService, SharedPreferences, OpenFilex), DTOs, and adapters.
   - `presentation/`: Flutter widgets, state notifiers, view models, and controllers. No direct calls to low-level platform APIs or file I/O outside repositories.
2. **SOLID Principles**:
   - **SRP**: Functions and widgets must perform a single focused task. Canvas rendering, wallpaper application, palette generation, and UI layout are decoupled.
   - **OCP**: Wallpaper targets and color generation strategies use polymorphism and strategy patterns.
   - **LSP**: All repository contracts must be mockable and substitutable in test suites.
   - **ISP**: Interfaces must have minimal surface area.
   - **DIP**: High-level presentation and controllers rely on abstract interfaces (`WallpaperRepository`, `PreferencesService`), injected via constructor parameters and Provider.
3. **Complexity Ceiling**:
   - Max cyclomatic complexity: 10 per method.
   - Max cognitive complexity: 15 per method.
   - If a method exceeds these limits, decompose into helper transformers or rule classes.
