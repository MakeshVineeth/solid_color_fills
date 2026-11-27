import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:solid_color_fills/src/core/security/input_validator.dart';
import 'package:solid_color_fills/src/features/collections/presentation/controllers/collections_controller.dart';
import 'package:solid_color_fills/src/features/feed/domain/services/random_color_generator.dart';
import 'package:solid_color_fills/src/features/feed/presentation/controllers/feed_controller.dart';

void main() {
  group('CollectionsController search filtering', () {
    test('filters case-insensitively, trims input, and clears cleanly', () {
      final controller = CollectionsController();
      final totalCount = controller.colors.length;

      expect(controller.isSearching, isFalse);

      controller.setSearchQuery('  amber  ');
      expect(controller.isSearching, isTrue);
      expect(controller.searchQuery, equals('amber'));
      expect(controller.colors.map((c) => c.name), contains('Amber'));
      expect(controller.colors.length, lessThan(totalCount));

      controller.clearSearch();
      expect(controller.isSearching, isFalse);
      expect(controller.searchQuery, isEmpty);
      expect(controller.colors.length, equals(totalCount));
    });

    test('handles zero-match, redundant notifications, max length, and immutability', () {
      final controller = CollectionsController();
      final totalCount = controller.colors.length;
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);

      // Clear when already empty & whitespace-only query do not notify.
      controller.clearSearch();
      controller.setSearchQuery('   \t\n  ');
      expect(notifyCount, equals(0));
      expect(controller.isSearching, isFalse);
      expect(controller.colors.length, equals(totalCount));

      // Zero-match yields empty unmodifiable list.
      controller.setSearchQuery('zzzzzz_no_match');
      expect(notifyCount, equals(1));
      expect(controller.colors, isEmpty);
      expect(
        () => controller.colors.clear(),
        throwsUnsupportedError,
      );

      // Duplicate sanitized query does not re-notify.
      controller.setSearchQuery('  zzzzzz_no_match  ');
      expect(notifyCount, equals(1));

      // Exceeding maxSearchLength truncates safely.
      controller.setSearchQuery('x' * 80);
      expect(
        controller.searchQuery.length,
        equals(InputValidator.maxSearchLength),
      );
      expect(notifyCount, equals(2));

      controller.clearSearch();
      expect(notifyCount, equals(3));
      expect(controller.colors.length, equals(totalCount));
    });
  });

  group('FeedController search filtering', () {
    test('filters loaded colors, reapplies on loadMore/refresh, and clears', () {
      final controller = FeedController(
        generator: RandomColorGenerator(Random(42)),
      );
      expect(controller.isSearching, isFalse);
      expect(controller.colors.length, equals(20));

      final firstTitle = controller.colors.first.name;
      final keyword = firstTitle.split(' ').first;

      controller.setSearchQuery('  $keyword  ');
      expect(controller.isSearching, isTrue);
      expect(controller.searchQuery, equals(keyword));
      expect(controller.colors, isNotEmpty);
      expect(
        controller.colors.every(
          (item) => item.name.toLowerCase().contains(keyword.toLowerCase()),
        ),
        isTrue,
      );

      controller.loadMore(40);
      expect(
        controller.colors.every(
          (item) => item.name.toLowerCase().contains(keyword.toLowerCase()),
        ),
        isTrue,
      );

      controller.refresh();
      expect(controller.isSearching, isTrue);
      expect(
        controller.colors.every(
          (item) => item.name.toLowerCase().contains(keyword.toLowerCase()),
        ),
        isTrue,
      );

      controller.clearSearch();
      expect(controller.isSearching, isFalse);
      expect(controller.searchQuery, isEmpty);
      expect(controller.colors.length, equals(20));
    });

    test('handles maxItems cap while searching, no-op notifications, immutability, and dispose', () {
      final controller = FeedController(
        generator: RandomColorGenerator(Random(42)),
      );
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);

      // Redundant clear/whitespace/invalid counts do not notify.
      controller.clearSearch();
      controller.setSearchQuery('   ');
      controller.loadMore(0);
      controller.loadMore(-5);
      expect(notifyCount, equals(0));

      final keyword = controller.colors.first.name.split(' ').first;
      controller.setSearchQuery(keyword);
      expect(notifyCount, equals(1));
      expect(
        () => controller.colors.clear(),
        throwsUnsupportedError,
      );

      // Duplicate sanitized query does not notify.
      controller.setSearchQuery('  $keyword  ');
      expect(notifyCount, equals(1));

      // Exhaust maxItems (600) while actively searching.
      controller.loadMore(FeedController.maxItems);
      expect(controller.hasMore, isFalse);
      expect(notifyCount, equals(2));

      // Further loadMore is a no-op with zero notifications.
      controller.loadMore(40);
      expect(controller.hasMore, isFalse);
      expect(notifyCount, equals(2));

      // Refresh while searching resets pool to 20 items and restores hasMore.
      controller.refresh();
      expect(controller.isSearching, isTrue);
      expect(controller.hasMore, isTrue);
      expect(notifyCount, equals(3));

      // Dispose clears backing lists cleanly while searching.
      controller.dispose();
      expect(controller.colors, isEmpty);
    });
  });
}
