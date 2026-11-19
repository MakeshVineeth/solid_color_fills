import 'dart:math';
import 'dart:ui';
import 'package:solid_color_fills/src/features/collections/domain/entities/solid_color_item.dart';

/// Pure Dart service to generate aesthetically pleasing random solid colors with names.
/// Replaces the deprecated external random_color dependency (SRP, OCP).
class RandomColorGenerator {
  final Random _random;

  RandomColorGenerator([Random? random]) : _random = random ?? Random();

  static const List<String> _hueNames = [
    'Crimson',
    'Scarlet',
    'Coral',
    'Amber',
    'Gold',
    'Citrus',
    'Emerald',
    'Mint',
    'Teal',
    'Cyan',
    'Cobalt',
    'Indigo',
    'Lavender',
    'Violet',
    'Magenta',
    'Rose',
  ];

  static const List<String> _toneModifiers = [
    'Deep',
    'Vibrant',
    'Mellow',
    'Soft',
    'Radiant',
    'Neon',
    'Pastel',
    'Subtle',
    'Electric',
    'Cosmic',
  ];

  Color _hslToRgb(double h, double s, double l) {
    double r, g, b;

    if (s == 0) {
      r = g = b = l;
    } else {
      double hue2rgb(double p, double q, double t) {
        var localT = t;
        if (localT < 0) localT += 1;
        if (localT > 1) localT -= 1;
        if (localT < 1 / 6) return p + (q - p) * 6 * localT;
        if (localT < 1 / 2) return q;
        if (localT < 2 / 3) return p + (q - p) * (2 / 3 - localT) * 6;
        return p;
      }

      final q = l < 0.5 ? l * (1 + s) : l + s - l * s;
      final p = 2 * l - q;
      r = hue2rgb(p, q, h + 1 / 3);
      g = hue2rgb(p, q, h);
      b = hue2rgb(p, q, h - 1 / 3);
    }

    return Color.fromARGB(
      255,
      (r * 255).round().clamp(0, 255),
      (g * 255).round().clamp(0, 255),
      (b * 255).round().clamp(0, 255),
    );
  }

  /// Generates a single pleasing random solid color item with a clean descriptive name.
  SolidColorItem nextColor() {
    final h = _random.nextDouble(); // 0.0 - 1.0
    final s = 0.55 + _random.nextDouble() * 0.40;
    final l = 0.35 + _random.nextDouble() * 0.40;

    final color = _hslToRgb(h, s, l);
    final hueIndex = (h * _hueNames.length).floor() % _hueNames.length;
    final toneIndex = _random.nextInt(_toneModifiers.length);
    final name = '${_toneModifiers[toneIndex]} ${_hueNames[hueIndex]}';

    return SolidColorItem(
      name: name,
      color: color,
      category: 'Feed',
    );
  }

  /// Generates a batch of distinct random solid colors.
  List<SolidColorItem> generateBatch(int count) {
    final list = <SolidColorItem>[];
    for (var i = 0; i < count; i++) {
      list.add(nextColor());
    }
    return list;
  }
}
