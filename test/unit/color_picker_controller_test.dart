import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/controllers/color_picker_controller.dart';

void main() {
  group('ColorPickerController Unit Tests', () {
    test('initializes with default color', () {
      final controller = ColorPickerController();
      expect(controller.color, equals(Colors.blue));
      expect(controller.hexString, isNotEmpty);
    });

    test('setColor updates active color and notifies listeners', () {
      final controller = ColorPickerController();
      var notified = false;
      controller.addListener(() => notified = true);

      controller.setColor(Colors.amber);
      expect(controller.color, equals(Colors.amber));
      expect(notified, isTrue);
    });

    test('setRgb updates color channels with clamping', () {
      final controller = ColorPickerController();
      controller.setRgb(r: 255, g: 128, b: 0);

      expect(controller.red, equals(255));
      expect(controller.green, equals(128));
      expect(controller.blue, equals(0));
    });

    test('setHex validates and updates color', () {
      final controller = ColorPickerController();
      final success = controller.setHex('#FF00FF');

      expect(success, isTrue);
      expect(controller.hexString, equals('#FF00FF'));

      final fail = controller.setHex('invalid');
      expect(fail, isFalse);
    });
  });
}
