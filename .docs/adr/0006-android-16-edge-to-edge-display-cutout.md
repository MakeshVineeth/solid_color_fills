# 6. Android 15 & 16 Edge-to-Edge & Display Cutout Compliance

Date: 2026-11-19

## Status
Accepted

## Context
Google Play policy mandates Edge-to-Edge window fitting and flags deprecated window parameters on targetSdkVersion 35/36.

## Decision
1. In `android/app/build.gradle`: Configured `compileSdkVersion 36` and `targetSdkVersion 36`.
2. In `MainActivity.kt`: Set `WindowCompat.setDecorFitsSystemWindows(window, false)` in `onCreate()`.
3. In `styles.xml` across all themes: Added `<item name="android:windowLayoutInDisplayCutoutMode">shortEdges</item>`.
4. In `lib/main.dart`: Enabled `SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)`.
5. Wrapped all screen contents in `SafeArea` or adaptive window insets.

## Consequences
- Guaranteed compliance with Google Play Android 15 and Android 16 mandates.
- Seamless, edge-to-edge visual presentation across camera notches, dynamic islands, and system gesture bars.
