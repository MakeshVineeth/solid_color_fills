import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solid_color_fills/src/features/wallpaper/domain/entities/wallpaper_target.dart';
import 'package:solid_color_fills/src/features/wallpaper/domain/repositories/wallpaper_repository.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/controllers/wallpaper_controller.dart';

class MockWallpaperRepository extends Mock implements WallpaperRepository {}

void main() {
  late MockWallpaperRepository mockRepo;
  late WallpaperController controller;

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(WallpaperTarget.homeScreen);
  });

  setUp(() {
    mockRepo = MockWallpaperRepository();
    controller = WallpaperController(repository: mockRepo);
  });

  group('WallpaperController Unit Tests', () {
    test('setColor updates selected color and resets state', () {
      controller.setColor(color: Colors.red, title: 'Test Red');
      expect(controller.selectedColor, equals(Colors.red));
      expect(controller.colorTitle, equals('Test Red'));
      expect(controller.lastOperationSuccess, isNull);
    });

    test('applyWallpaper delegates to repository and marks success', () async {
      when(() => mockRepo.setWallpaper(
            imageBytes: any(named: 'imageBytes'),
            colorTitle: any(named: 'colorTitle'),
            target: any(named: 'target'),
          )).thenAnswer((_) async => true);

      final result = await controller.applyWallpaper(
        target: WallpaperTarget.homeScreen,
        width: 100,
        height: 100,
      );

      expect(result, isTrue);
      expect(controller.lastOperationSuccess, isTrue);
      expect(controller.isLoading, isFalse);
    });

    test('applyWallpaper handles repository failure cleanly', () async {
      when(() => mockRepo.setWallpaper(
            imageBytes: any(named: 'imageBytes'),
            colorTitle: any(named: 'colorTitle'),
            target: any(named: 'target'),
          )).thenAnswer((_) async => false);

      final result = await controller.applyWallpaper(
        target: WallpaperTarget.bothScreens,
        width: 100,
        height: 100,
      );

      expect(result, isFalse);
      expect(controller.lastOperationSuccess, isFalse);
    });
  });
}
