import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solid_color_fills/src/core/constants/app_constants.dart';

/// Material theme configurations faithful to original Solid Color Fills design.
class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      primaryColor: Colors.blue[600],
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 3.0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.black),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
      bottomAppBarTheme: const BottomAppBarThemeData(
        color: Colors.white,
        elevation: 3.0,
      ),
      cardColor: Colors.white,
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 3.0,
        shape: AppConstants.roundShape,
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          padding: const EdgeInsets.all(20),
          shape: AppConstants.roundShape,
          elevation: 3.0,
          enableFeedback: true,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: AppConstants.roundShape,
        backgroundColor: const Color(0xFFECE6F0),
        surfaceTintColor: Colors.transparent,
        elevation: 6,
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.amber,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      primaryColor: Colors.amber,
      scaffoldBackgroundColor: Colors.black,
      applyElevationOverlayColor: true,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
      bottomAppBarTheme: const BottomAppBarThemeData(
        color: Color(0xFF212121),
        elevation: 10.0,
      ),
      cardColor: const Color(0xFF1E1E1E),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        surfaceTintColor: Colors.transparent,
        elevation: 10.0,
        shape: AppConstants.roundShape,
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF1E1E1E),
          surfaceTintColor: Colors.transparent,
          padding: const EdgeInsets.all(20),
          shape: AppConstants.roundShape,
          elevation: 10.0,
          enableFeedback: true,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: AppConstants.roundShape,
        backgroundColor: const Color(0xFF242424),
        surfaceTintColor: Colors.transparent,
        elevation: 8,
      ),
    );
  }
}
