# 3. Replace Discontinued Packages with Pure-Flutter Dart 3 Implementations

Date: 2026-11-19

## Status
Accepted

## Context
The legacy application depended on unmaintained, Dart 2.12-era, and discontinued packages:
- `random_color` (unmaintained for 4+ years).
- `convex_bottom_bar` & `flutter_animator` (legacy Dart 2 packages causing deprecation warnings and layout fragility).
- `app_review_plus` (outdated fork).
- `material_color_picker_wns` & `flutter_material_color_picker` (unmaintained Dart 2 wrappers).
- `modal_bottom_sheet` & `animations` (unnecessary third-party wrappers for standard modal sheets and dialogs).

## Decision
1. Replaced `random_color` with a pure-Dart `RandomColorGenerator` utilizing HSL color space.
2. Replaced `convex_bottom_bar` & `flutter_animator` with a pure-Flutter Dart 3 `ConvexNavigationBar` (`CustomPaint` Bézier convex bump + scale animation) matching the original Play Store navigation design.
3. Replaced `material_color_picker_wns` & `flutter_material_color_picker` with a zero-dependency pure-Flutter `MaterialPickerWidget` (19 primary tones + shade drilldown) and circular `CurrentColorCard` FAB.
4. Replaced `modal_bottom_sheet` and `animations` with pure-Flutter `showFloatingModalBottomSheet` and `showAnimatedDialog` + `ScaleBounce`.
5. Removed `app_review_plus` and upgraded active dependencies (`wallpaper_manager_plus ^2.0.4`, `share_plus ^13.3.1`, `device_info_plus ^13.3.0`, `package_info_plus ^10.2.2`, `flutter_displaymode ^0.7.0`, `open_filex ^5.0.0`), while retaining `flutter_colorpicker ^1.1.0` for HSV/RGB Slide & Area pickers.

## Consequences
- Zero unmaintained Dart 2 UI wrapper packages remain in `pubspec.yaml`.
- Full null-safety and Dart 3 compatibility with zero deprecation warnings.
- 100% visual fidelity to the original Play Store design preserved with minimal attack surface.
