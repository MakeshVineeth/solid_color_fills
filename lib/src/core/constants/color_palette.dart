import 'package:flutter/material.dart';
import 'package:solid_color_fills/src/core/utils/color_utils.dart';

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

  static final Map<int, String> _argbToName = _buildArgbToNameMap();

  static Map<int, String> _buildArgbToNameMap() {
    final map = <int, String>{};
    for (final entry in curatedColors.entries) {
      map.putIfAbsent(entry.value.toARGB32(), () => entry.key);
    }
    const primaryEntries = <MapEntry<Color, String>>[
      MapEntry(Colors.red, 'Red'),
      MapEntry(Colors.pink, 'Pink'),
      MapEntry(Colors.purple, 'Purple'),
      MapEntry(Colors.deepPurple, 'Deep Purple'),
      MapEntry(Colors.indigo, 'Indigo'),
      MapEntry(Colors.blue, 'Blue'),
      MapEntry(Colors.lightBlue, 'Light Blue'),
      MapEntry(Colors.cyan, 'Cyan'),
      MapEntry(Colors.teal, 'Teal'),
      MapEntry(Colors.green, 'Green'),
      MapEntry(Colors.lightGreen, 'Light Green'),
      MapEntry(Colors.lime, 'Lime'),
      MapEntry(Colors.yellow, 'Yellow'),
      MapEntry(Colors.amber, 'Amber'),
      MapEntry(Colors.orange, 'Orange'),
      MapEntry(Colors.deepOrange, 'Deep Orange'),
      MapEntry(Colors.brown, 'Brown'),
      MapEntry(Colors.grey, 'Grey'),
      MapEntry(Colors.blueGrey, 'Blue Grey'),
      MapEntry(Colors.black, 'Pitch Black'),
      MapEntry(Colors.white, 'White'),
    ];
    for (final entry in primaryEntries) {
      map.putIfAbsent(entry.key.toARGB32(), () => entry.value);
    }
    return Map<int, String>.unmodifiable(map);
  }

  /// Finds a human-readable display name for a given color.
  static String findName(Color color) {
    return _argbToName[color.toARGB32()] ?? ColorUtils.toHex(color);
  }
}
