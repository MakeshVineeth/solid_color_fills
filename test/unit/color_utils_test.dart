import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_color_fills/src/core/utils/color_utils.dart';

void main() {
  group('ColorUtils Unit Tests', () {
    test('toHex converts Color to correct uppercase hex string', () {
      expect(ColorUtils.toHex(const Color(0xFF000000)), equals('#000000'));
      expect(ColorUtils.toHex(const Color(0xFFFFFFFF)), equals('#FFFFFF'));
      expect(ColorUtils.toHex(const Color(0xFFFF0000)), equals('#FF0000'));
      expect(ColorUtils.toHex(const Color(0xFF00FF00)), equals('#00FF00'));
      expect(ColorUtils.toHex(const Color(0xFF0000FF)), equals('#0000FF'));
      expect(ColorUtils.toHex(const Color(0xFF1877F2)), equals('#1877F2'));
    });

    test('fromHex parses 6-digit and 8-digit hex strings correctly', () {
      expect(ColorUtils.fromHex('FF0000'), equals(const Color(0xFFFF0000)));
      expect(ColorUtils.fromHex('#00FF00'), equals(const Color(0xFF00FF00)));
      expect(ColorUtils.fromHex('#FF0000FF'), equals(const Color(0xFF0000FF)));
      expect(ColorUtils.fromHex('invalid'), equals(Colors.black));
    });

    test('getContrastingTextColor returns black for light and white for dark', () {
      expect(ColorUtils.getContrastingTextColor(Colors.white), equals(Colors.black87));
      expect(ColorUtils.getContrastingTextColor(Colors.yellow), equals(Colors.black87));
      expect(ColorUtils.getContrastingTextColor(Colors.black), equals(Colors.white));
      expect(ColorUtils.getContrastingTextColor(Colors.indigo), equals(Colors.white));
    });
  });
}
