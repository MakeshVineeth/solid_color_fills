import 'dart:async';
import 'dart:ui';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solid_color_fills/src/app.dart';
import 'package:solid_color_fills/src/core/constants/app_constants.dart';
import 'package:solid_color_fills/src/core/storage/preferences_service.dart';
import 'package:solid_color_fills/src/core/utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    AppLogger.error('Unhandled Flutter framework error', details.exception, details.stack);
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error('Unhandled platform dispatcher error', error, stack);
    return true;
  };

  // Android 15 & 16 Edge-to-Edge window layout (MainActivity sets native edge-to-edge early)
  unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  final prefsFuture = SharedPreferences.getInstance();
  final themeFuture = AdaptiveTheme.getThemeMode();
  final prefs = await prefsFuture;
  final savedThemeMode = await themeFuture;

  final preferencesService = SharedPreferencesServiceImpl(prefs);
  final initialShowOnboarding = prefs.getBool(AppConstants.keyFirstLaunch) ?? true;
  final initialTabIndex = prefs.getInt(AppConstants.keyTabIndex) ?? 0;

  runApp(SolidColorFillsApp(
    savedThemeMode: savedThemeMode,
    preferencesService: preferencesService,
    initialShowOnboarding: initialShowOnboarding,
    initialTabIndex: initialTabIndex,
  ));
}
