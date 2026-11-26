import 'package:flutter/material.dart';

/// Centralized application constants and design tokens.
class AppConstants {
  const AppConstants._();

  static const String appName = 'Solid Color Fills';
  static const String logoAsset = 'assets/logo.png';
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.makeshtech.solid_color_fills';
  static const String privacyPolicyUrl =
      'https://makeshvineeth.github.io/privacy_policy/';
  static const String developerWebsiteUrl =
      'https://makeshvineeth.github.io/';
  static const String githubRepoUrl =
      'https://github.com/MakeshVineeth/solid_color_fills';

  // Storage Keys
  static const String keyFirstLaunch = 'first_launch';
  static const String keyTabIndex = 'tab_index';
  static const String keySavedColors = 'saved_colors';

  // Responsive Breakpoints
  static const double compactBreakpoint = 600.0;
  static const double mediumBreakpoint = 840.0;
  static const double expandedBreakpoint = 1200.0;

  // Shapes & Radii
  static const double defaultRadius = 20.0;
  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(defaultRadius),
  );
  static const RoundedRectangleBorder roundShape = RoundedRectangleBorder(
    borderRadius: cardRadius,
  );

  // Animations
  static const Duration shortAnimationDuration = Duration(milliseconds: 250);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
}
