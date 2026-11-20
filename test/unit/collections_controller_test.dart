import 'package:flutter_test/flutter_test.dart';
import 'package:solid_color_fills/src/features/collections/presentation/controllers/collections_controller.dart';

void main() {
  group('CollectionsController Unit Tests', () {
    test('initializes with full curated color list', () {
      final controller = CollectionsController();
      expect(controller.colors, isNotEmpty);
      expect(controller.searchQuery, isEmpty);
    });

    test('filters list based on search query case-insensitively', () {
      final controller = CollectionsController();
      controller.setSearchQuery('blue');

      expect(controller.colors, isNotEmpty);
      for (final item in controller.colors) {
        expect(item.name.toLowerCase().contains('blue'), isTrue);
      }
    });

    test('clearSearch restores full list', () {
      final controller = CollectionsController();
      final initialCount = controller.colors.length;

      controller.setSearchQuery('OnePlus');
      expect(controller.colors.length, lessThan(initialCount));

      controller.clearSearch();
      expect(controller.colors.length, equals(initialCount));
      expect(controller.searchQuery, isEmpty);
    });
  });
}
