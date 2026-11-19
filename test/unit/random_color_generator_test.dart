import 'package:flutter_test/flutter_test.dart';
import 'package:solid_color_fills/src/features/feed/domain/services/random_color_generator.dart';

void main() {
  group('RandomColorGenerator Unit Tests', () {
    test('generates valid solid color items with non-empty names', () {
      final generator = RandomColorGenerator();
      final item = generator.nextColor();

      expect(item.name, isNotEmpty);
      expect(item.color.alpha, equals(255));
      expect(item.category, equals('Feed'));
    });

    test('generateBatch produces the requested number of items', () {
      final generator = RandomColorGenerator();
      final batch = generator.generateBatch(15);

      expect(batch.length, equals(15));
      for (final item in batch) {
        expect(item.name, isNotEmpty);
      }
    });
  });
}
