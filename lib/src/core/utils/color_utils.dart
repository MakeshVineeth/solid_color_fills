import 'package:flutter/material.dart';

/// Pure utility functions for color manipulation and conversion.
class ColorUtils {
  const ColorUtils._();

  /// Converts a [Color] to a hex string format '#RRGGBB'.
  static String toHex(Color color, {bool includeHash = true}) {
    final r = (color.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (color.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (color.b * 255).round().toRadixString(16).padLeft(2, '0');
    final prefix = includeHash ? '#' : '';
    return '$prefix$r$g$b'.toUpperCase();
  }

  /// Parses a hex color string into a [Color]. Returns fallback if invalid.
  static Color fromHex(String hexString, {Color fallback = Colors.black}) {
    var cleanHex = hexString.replaceAll('#', '').trim();
    if (cleanHex.length == 6) {
      cleanHex = 'FF$cleanHex';
    }
    if (cleanHex.length != 8) {
      return fallback;
    }
    final intVal = int.tryParse(cleanHex, radix: 16);
    return intVal != null ? Color(intVal) : fallback;
  }

  /// Determines whether light or dark text contrasts better with the given color.
  static Color getContrastingTextColor(Color background) {
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}
