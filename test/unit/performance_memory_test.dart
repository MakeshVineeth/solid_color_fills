import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:solid_color_fills/l10n/app_localizations.dart';
import 'package:solid_color_fills/src/core/constants/color_palette.dart';
import 'package:solid_color_fills/src/core/storage/preferences_service.dart';
import 'package:solid_color_fills/src/core/widgets/fade_indexed_stack.dart';
import 'package:solid_color_fills/src/core/widgets/scale_bounce.dart';
import 'package:solid_color_fills/src/features/collections/domain/entities/solid_color_item.dart';
import 'package:solid_color_fills/src/features/collections/presentation/controllers/collections_controller.dart';
import 'package:solid_color_fills/src/features/collections/presentation/widgets/color_grid_card.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/controllers/color_picker_controller.dart';
import 'package:solid_color_fills/src/features/feed/presentation/controllers/feed_controller.dart';
import 'package:solid_color_fills/src/features/home/presentation/screens/home_screen.dart';
import 'package:solid_color_fills/src/features/home/presentation/screens/wrapper_screen.dart';
import 'package:solid_color_fills/src/features/wallpaper/data/services/canvas_image_service.dart';
import 'package:solid_color_fills/src/features/wallpaper/domain/repositories/wallpaper_repository.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/controllers/wallpaper_controller.dart';

class _MockWallpaperRepo extends Mock implements WallpaperRepository {}

class _MockPrefsService extends Mock implements PreferencesService {}

class _MockCanvasImageService extends Mock implements CanvasImageService {}

int _readUint32BE(Uint8List bytes, int offset) {
  return (bytes[offset] << 24) |
      (bytes[offset + 1] << 16) |
      (bytes[offset + 2] << 8) |
      bytes[offset + 3];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CanvasImageService Performance & PNG Validity', () {
    const service = CanvasImageService();

    test('encodes valid PNG with exact decoded dimensions and pixel colors',
        () async {
      const testColor = Color(0xFFEB0029);
      final bytes = await service.generateSolidColorPng(
        color: testColor,
        width: 16,
        height: 12,
      );

      expect(bytes.length, greaterThan(24));
      expect(
        bytes.sublist(0, 8),
        equals(const [137, 80, 78, 71, 13, 10, 26, 10]),
      );

      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final decoded = frame.image;
      expect(decoded.width, equals(16));
      expect(decoded.height, equals(12));

      final rgba = await decoded.toByteData(format: ui.ImageByteFormat.rawRgba);
      decoded.dispose();
      codec.dispose();
      expect(rgba, isNotNull);

      void expectPixelAt(int x, int y) {
        final offset = (y * 16 + x) * 4;
        expect(rgba!.getUint8(offset), equals(0xEB));
        expect(rgba.getUint8(offset + 1), equals(0x00));
        expect(rgba.getUint8(offset + 2), equals(0x29));
        expect(rgba.getUint8(offset + 3), equals(0xFF));
      }

      expectPixelAt(0, 0);
      expectPixelAt(8, 6);
      expectPixelAt(15, 11);
    });

    test('handles 1x1 edge case and clamps invalid or oversized dimensions',
        () async {
      final tinyBytes = await service.generateSolidColorPng(
        color: const Color(0xFF1877F2),
        width: 1,
        height: 1,
      );
      final codec = await ui.instantiateImageCodec(tinyBytes);
      final frame = await codec.getNextFrame();
      final rgba =
          await frame.image.toByteData(format: ui.ImageByteFormat.rawRgba);
      frame.image.dispose();
      codec.dispose();

      expect(rgba!.getUint8(0), equals(0x18));
      expect(rgba.getUint8(1), equals(0x77));
      expect(rgba.getUint8(2), equals(0xF2));
      expect(rgba.getUint8(3), equals(0xFF));

      final fallbackBytes = await service.generateSolidColorPng(
        color: Colors.black,
        width: 0,
        height: 0,
      );
      expect(_readUint32BE(fallbackBytes, 16), equals(1080));
      expect(_readUint32BE(fallbackBytes, 20), equals(1920));

      final clampedBytes = await service.generateSolidColorPng(
        color: Colors.white,
        width: 99999,
        height: 2,
      );
      expect(_readUint32BE(clampedBytes, 16), equals(4096));
      expect(_readUint32BE(clampedBytes, 20), equals(2));
    });
  });

  group('FeedController Lifecycle & Cap', () {
    test('provides unmodifiable view, enforces maxItems cap, and clears on dispose',
        () {
      final controller = FeedController();
      expect(controller.colors.length, equals(20));
      expect(controller.hasMore, isTrue);

      expect(
        () => controller.colors.add(
          const SolidColorItem(name: 'X', color: Colors.black),
        ),
        throwsUnsupportedError,
      );

      controller.loadMore(FeedController.maxItems);
      expect(controller.colors.length, equals(FeedController.maxItems));
      expect(controller.hasMore, isFalse);

      var notifiedAtCap = false;
      controller.addListener(() => notifiedAtCap = true);
      controller.loadMore(10);
      expect(notifiedAtCap, isFalse);
      expect(controller.colors.length, equals(FeedController.maxItems));

      controller.refresh();
      expect(controller.colors.length, equals(20));
      expect(controller.hasMore, isTrue);

      final retainedView = controller.colors;
      controller.dispose();
      expect(retainedView, isEmpty);
    });
  });

  group('WallpaperController Cache Behavior', () {
    test(
        'reuses cache for matching dimensions, invalidates on resize, and clears without notifying',
        () async {
      final mockRepo = _MockWallpaperRepo();
      final mockCanvas = _MockCanvasImageService();
      when(
        () => mockCanvas.generateSolidColorPng(
          color: Colors.blue,
          width: 100,
          height: 200,
        ),
      ).thenAnswer((_) async => Uint8List.fromList([1, 2, 3]));
      when(
        () => mockCanvas.generateSolidColorPng(
          color: Colors.blue,
          width: 200,
          height: 400,
        ),
      ).thenAnswer((_) async => Uint8List.fromList([4, 5, 6]));

      final controller = WallpaperController(
        repository: mockRepo,
        canvasImageService: mockCanvas,
      );
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);

      final first = await controller.prepareImageBytes(width: 100, height: 200);
      final second =
          await controller.prepareImageBytes(width: 100, height: 200);
      expect(identical(first, second), isTrue);
      expect(notifyCount, equals(0));
      verify(
        () => mockCanvas.generateSolidColorPng(
          color: Colors.blue,
          width: 100,
          height: 200,
        ),
      ).called(1);

      final resized =
          await controller.prepareImageBytes(width: 200, height: 400);
      expect(resized, equals(Uint8List.fromList([4, 5, 6])));
      expect(notifyCount, equals(0));
      verify(
        () => mockCanvas.generateSolidColorPng(
          color: Colors.blue,
          width: 200,
          height: 400,
        ),
      ).called(1);

      controller.clearCache();
      expect(controller.cachedImageBytes, isNull);
      expect(notifyCount, equals(0));
    });
  });

  group('Startup & Lazy Widget Optimization Tests', () {
    testWidgets(
        'FadeIndexedStack lazily builds tabs on first visit at full initial opacity',
        (tester) async {
      final builtTabs = <int>{};

      Widget buildTabHost(int index) {
        return MaterialApp(
          home: Scaffold(
            body: FadeIndexedStack(
              index: index,
              children: [
                Builder(
                  builder: (_) {
                    builtTabs.add(0);
                    return const Text('Tab 0');
                  },
                ),
                Builder(
                  builder: (_) {
                    builtTabs.add(1);
                    return const Text('Tab 1');
                  },
                ),
                Builder(
                  builder: (_) {
                    builtTabs.add(2);
                    return const Text('Tab 2');
                  },
                ),
              ],
            ),
          ),
        );
      }

      await tester.pumpWidget(buildTabHost(0));
      expect(builtTabs, equals({0}));
      final fade = tester.widget<FadeTransition>(
        find.descendant(
          of: find.byType(FadeIndexedStack),
          matching: find.byType(FadeTransition),
        ),
      );
      expect(fade.opacity.value, equals(1.0));

      await tester.pumpWidget(buildTabHost(1));
      await tester.pumpAndSettle();
      expect(builtTabs, equals({0, 1}));

      await tester.pumpWidget(buildTabHost(0));
      await tester.pumpAndSettle();
      expect(builtTabs, equals({0, 1}));
    });

    testWidgets(
        'WrapperScreen with initialShowOnboarding: false skips loading spinner frame',
        (tester) async {
      final mockPrefs = _MockPrefsService();
      final mockRepo = _MockWallpaperRepo();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<PreferencesService>.value(value: mockPrefs),
            Provider<WallpaperRepository>.value(value: mockRepo),
            ChangeNotifierProvider<WallpaperController>(
              create: (_) => WallpaperController(repository: mockRepo),
            ),
            ChangeNotifierProvider<CollectionsController>(
              create: (_) => CollectionsController(),
            ),
            ChangeNotifierProvider<ColorPickerController>(
              create: (_) => ColorPickerController(),
            ),
            ChangeNotifierProvider<FeedController>(
              create: (_) => FeedController(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: WrapperScreen(
              preferencesService: mockPrefs,
              initialShowOnboarding: false,
              initialTabIndex: 0,
            ),
          ),
        ),
      );

      // Frame 1 immediately renders HomeScreen with no spinner flash.
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets(
        'ScaleBounce lazily allocates animation without dropping first InkWell tap',
        (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ScaleBounce(
                child: InkWell(
                  onTap: () => tapCount++,
                  child: const SizedBox(
                    width: 80,
                    height: 80,
                    child: Center(child: Text('Tap')),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final scaleFinder = find.descendant(
        of: find.byType(ScaleBounce),
        matching: find.byType(ScaleTransition),
      );
      expect(scaleFinder, findsOneWidget);
      final initialTransition = tester.widget<ScaleTransition>(scaleFinder);
      expect(initialTransition.scale, isA<AlwaysStoppedAnimation<double>>());
      expect(initialTransition.scale.value, equals(1.0));

      final gesture = await tester.startGesture(tester.getCenter(find.text('Tap')));
      await tester.pump(const Duration(milliseconds: 50));
      final activeTransition = tester.widget<ScaleTransition>(scaleFinder);
      expect(activeTransition.scale, isNot(isA<AlwaysStoppedAnimation<double>>()));

      await gesture.up();
      await tester.pumpAndSettle();

      expect(tapCount, equals(1));
      expect(tester.takeException(), isNull);
    });

    testWidgets('ColorGridCard opens wallpaper on the very first touch',
        (tester) async {
      var tapped = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 180,
              height: 220,
              child: ColorGridCard(
                item: const SolidColorItem(name: 'Amber', color: Colors.amber),
                heroTag: 'first_touch_test',
                onTap: () => tapped++,
              ),
            ),
          ),
        ),
      );

      final gesture = await tester.startGesture(tester.getCenter(find.text('Amber')));
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(tapped, equals(1));
    });
  });

  group('ColorPalette Lookup Precedence', () {
    test('preserves curated priority, primary fallback, and hex fallback', () {
      expect(
        ColorPalette.findName(ColorPalette.curatedColors['OnePlus Red']!),
        equals('OnePlus Red'),
      );
      expect(ColorPalette.findName(Colors.black), equals('Pitch Black'));
      expect(ColorPalette.findName(Colors.white), equals('White'));
      expect(ColorPalette.findName(Colors.blue), equals('Blue'));
      expect(ColorPalette.findName(Colors.deepPurple), equals('Deep Purple'));
      expect(ColorPalette.findName(Colors.orange), equals('Orange'));
      expect(
        ColorPalette.findName(const Color(0xFF123456)),
        equals('#123456'),
      );
    });
  });
}
