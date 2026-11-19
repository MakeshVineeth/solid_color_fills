import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solid_color_fills/src/app.dart';
import 'package:solid_color_fills/src/core/storage/preferences_service.dart';
import 'package:solid_color_fills/src/core/utils/logger.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Android 15 & 16 Edge-to-Edge window layout requirement
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    final preferencesService = SharedPreferencesServiceImpl(prefs);
    final savedThemeMode = await AdaptiveTheme.getThemeMode();

    runApp(SolidColorFillsApp(
      savedThemeMode: savedThemeMode,
      preferencesService: preferencesService,
    ));
  }, (error, stack) {
    AppLogger.error('Unhandled app error in runZonedGuarded', error, stack);
  });
}
