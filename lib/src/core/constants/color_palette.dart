import 'package:flutter/material.dart';

/// Curated collections of solid colors with aesthetic presets.
class ColorPalette {
  const ColorPalette._();

  static const Map<String, Color> curatedColors = {
    'Amber': Colors.amber,
    'Red': Colors.red,
    'Green': Colors.green,
    'Blue': Colors.blue,
    'OnePlus Red': Color(0xFFEB0029),
    'Pitch Black': Colors.black,
    'White': Colors.white,
    'Neumorphic White': Color(0xFFE0E5EC),
    'Neumorphic Black': Color(0xFF26282B),
    'Midnight Blue': Color(0xFF2C3E50),
    'Foursquare': Color(0xFFF94877),
    'Reddit': Color(0xFFFF4500),
    'Classic WhatsApp': Color(0xFF075E54),
    'Twitch': Color(0xFF9146FF),
    'Facebook': Color(0xFF1877F2),
    'Classic Blue': Color(0xFF34568B),
    'Rose Quartz': Color(0xFFF7CAC9),
    'Caramel': Color(0xFF8F614B),
    'Moon': Color(0xFF989DA6),
    'Serenity': Color(0xFF92A8D1),
    'HackerNews': Color(0xFFFF6600),
    'Crimson': Color(0xFFDC143C),
    'Teal': Colors.teal,
    'Cornflower Blue': Color(0xFF6495ED),
    'Royal Blue': Color(0xFF4169E1),
    'Corn Silk': Color(0xFFFFF8DC),
    'Forest Green': Color(0xFF228B22),
    'Silver': Color(0xFFC0C0C0),
    'Bisque': Color(0xFFFFE4C4),
    'Telegram': Color(0xFF0088CC),
    'Mauve': Color(0xFFE0B0FF),
    'Khaki': Color(0xFFF0E68C),
    'Indigo': Colors.indigo,
    'Pink': Colors.pink,
    'Sky Blue': Color(0xFF87CEEB),
    'Orchid': Color(0xFFDA70D6),
  };

  static const List<Color> materialPrimaries = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];

  /// Finds a human-readable display name for a given color.
  static String findName(Color color) {
    final targetArgb = color.toARGB32();
    for (final entry in curatedColors.entries) {
      if (entry.value.toARGB32() == targetArgb) {
        return entry.key;
      }
    }
    final primaryNames = <int, String>{
      Colors.red.toARGB32(): 'Red',
      Colors.pink.toARGB32(): 'Pink',
      Colors.purple.toARGB32(): 'Purple',
      Colors.deepPurple.toARGB32(): 'Deep Purple',
      Colors.indigo.toARGB32(): 'Indigo',
      Colors.blue.toARGB32(): 'Blue',
      Colors.lightBlue.toARGB32(): 'Light Blue',
      Colors.cyan.toARGB32(): 'Cyan',
      Colors.teal.toARGB32(): 'Teal',
      Colors.green.toARGB32(): 'Green',
      Colors.lightGreen.toARGB32(): 'Light Green',
      Colors.lime.toARGB32(): 'Lime',
      Colors.yellow.toARGB32(): 'Yellow',
      Colors.amber.toARGB32(): 'Amber',
      Colors.orange.toARGB32(): 'Orange',
      Colors.deepOrange.toARGB32(): 'Deep Orange',
      Colors.brown.toARGB32(): 'Brown',
      Colors.grey.toARGB32(): 'Grey',
      Colors.blueGrey.toARGB32(): 'Blue Grey',
      Colors.black.toARGB32(): 'Pitch Black',
      Colors.white.toARGB32(): 'White',
    };
    if (primaryNames.containsKey(targetArgb)) {
      return primaryNames[targetArgb]!;
    }
    final r = (color.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (color.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (color.b * 255).round().toRadixString(16).padLeft(2, '0');
    return '#$r$g$b'.toUpperCase();
  }
}
