import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:solid_color_fills/l10n/app_localizations.dart';
import 'package:solid_color_fills/src/features/collections/presentation/controllers/collections_controller.dart';
import 'package:solid_color_fills/src/features/collections/presentation/screens/collections_screen.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/controllers/color_picker_controller.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/screens/color_picker_screen.dart';
import 'package:solid_color_fills/src/features/feed/presentation/controllers/feed_controller.dart';
import 'package:solid_color_fills/src/features/feed/presentation/screens/feed_screen.dart';
import 'package:solid_color_fills/src/features/wallpaper/domain/repositories/wallpaper_repository.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/controllers/wallpaper_controller.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/screens/wallpaper_confirmation_screen.dart';

class MockWallpaperRepo extends Mock implements WallpaperRepository {}

Widget buildTestApp(Widget child) {
  final repo = MockWallpaperRepo();

  return MultiProvider(
    providers: [
      ChangeNotifierProvider<WallpaperController>(
        create: (_) => WallpaperController(repository: repo),
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
      home: child,
    ),
  );
}

void main() {
  const targetSizes = [
    Size(320, 568),   // Compact / small screen
    Size(390, 844),   // Standard modern phone
    Size(673, 841),   // Foldable
    Size(800, 1280),  // Tablet portrait
    Size(1280, 800),  // Tablet landscape
    Size(1920, 1080), // Desktop / TV
  ];

  group('Cross-Device Responsive Layout Overflow Tests', () {
    for (final size in targetSizes) {
      testWidgets('No overflow on CollectionsScreen at ${size.width}x${size.height}', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestApp(const Scaffold(body: CollectionsScreen())));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      });

      testWidgets('No overflow on ColorPickerScreen at ${size.width}x${size.height}', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestApp(const Scaffold(body: ColorPickerScreen())));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      });

      testWidgets('No overflow on FeedScreen at ${size.width}x${size.height}', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestApp(const Scaffold(body: FeedScreen())));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      });

      testWidgets('No overflow on WallpaperConfirmationScreen at ${size.width}x${size.height}', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          buildTestApp(const WallpaperConfirmationScreen(heroTag: 'resp_hero')),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      });
    }
  });
}
