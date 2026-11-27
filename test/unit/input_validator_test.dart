import 'package:flutter_test/flutter_test.dart';
import 'package:solid_color_fills/src/core/security/input_validator.dart';

void main() {
  group('InputValidator Unit Tests', () {
    test('isValidHexColor validates legitimate 6 and 8 char hex codes', () {
      expect(InputValidator.isValidHexColor('#FFFFFF'), isTrue);
      expect(InputValidator.isValidHexColor('FFFFFF'), isTrue);
      expect(InputValidator.isValidHexColor('#1877F2'), isTrue);
      expect(InputValidator.isValidHexColor('FF1877F2'), isTrue);
      expect(InputValidator.isValidHexColor('#FF1877F2'), isTrue);
      expect(InputValidator.isValidHexColor('#abc'), isFalse);
      expect(InputValidator.isValidHexColor('ZZZZZZ'), isFalse);
      expect(InputValidator.isValidHexColor(''), isFalse);
    });

    test('normalizeHex extracts clean 6-digit hex string', () {
      expect(InputValidator.normalizeHex('#ff0000'), equals('FF0000'));
      expect(InputValidator.normalizeHex('00ff00'), equals('00FF00'));
      expect(InputValidator.normalizeHex('FF0000FF'), equals('0000FF'));
      expect(InputValidator.normalizeHex('FF#00#00'), isNull);
      expect(InputValidator.normalizeHex('invalid'), isNull);
    });

    test('sanitizeText trims and clamps length', () {
      expect(InputValidator.sanitizeText('  hello  '), equals('hello'));
      final longString = 'a' * 100;
      expect(
        InputValidator.sanitizeText(longString, maxLength: 20).length,
        equals(20),
      );
    });

    test('sanitizeText strips control and BiDi chars and collapses whitespace', () {
      expect(
        InputValidator.sanitizeText('  Amber\u0000\n\t   Red\u202E\u2066  '),
        equals('Amber Red'),
      );
      expect(
        InputValidator.sanitizeText('\u0007\u001F\u007F   \u202A\u2069'),
        isEmpty,
      );
      expect(
        InputValidator.sanitizeText('Pastel Mint'),
        equals('Pastel Mint'),
      );
    });
  });
}
