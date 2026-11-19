import 'package:flutter/material.dart';
import 'package:solid_color_fills/src/core/constants/color_palette.dart';
import 'package:solid_color_fills/src/core/security/input_validator.dart';
import 'package:solid_color_fills/src/core/utils/color_utils.dart';

/// State controller for color picking and manipulation.
class ColorPickerController extends ChangeNotifier {
  Color _color = Colors.blue;
  String _colorTitle = 'Blue';
  bool _isColorSelected = true;

  Color get color => _color;
  String get colorTitle => _colorTitle;
  bool get isColorSelected => _isColorSelected;
  int get red => (_color.r * 255).round();
  int get green => (_color.g * 255).round();
  int get blue => (_color.b * 255).round();
  String get hexString => ColorUtils.toHex(_color);

  void setColor(Color newColor, {String? title}) {
    _color = newColor;
    _colorTitle = title ?? ColorPalette.findName(newColor);
    _isColorSelected = true;
    notifyListeners();
  }

  void setRgb({int? r, int? g, int? b}) {
    final newR = (r ?? red).clamp(0, 255);
    final newG = (g ?? green).clamp(0, 255);
    final newB = (b ?? blue).clamp(0, 255);
    final newColor = Color.fromARGB(255, newR, newG, newB);
    setColor(newColor);
  }

  bool setHex(String input) {
    final normalized = InputValidator.normalizeHex(input);
    if (normalized != null) {
      final newColor = ColorUtils.fromHex(normalized);
      setColor(newColor);
      return true;
    }
    return false;
  }
}
