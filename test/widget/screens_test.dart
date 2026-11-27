import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:solid_color_fills/l10n/app_localizations.dart';
import 'package:solid_color_fills/src/core/storage/preferences_service.dart';
import 'package:solid_color_fills/src/core/widgets/convex_navigation_bar.dart';
import 'package:solid_color_fills/src/features/collections/presentation/controllers/collections_controller.dart';
import 'package:solid_color_fills/src/features/collections/presentation/screens/collections_screen.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/controllers/color_picker_controller.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/dialogs/advanced_color_picker_dialog.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/dialogs/simple_rgb_dialog.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/screens/color_picker_screen.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/widgets/current_color_card.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/widgets/material_picker_widget.dart';
import 'package:solid_color_fills/src/features/feed/presentation/controllers/feed_controller.dart';
import 'package:solid_color_fills/src/features/feed/presentation/screens/feed_screen.dart';
import 'package:solid_color_fills/src/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:solid_color_fills/src/features/settings/presentation/dialogs/menu_bottom_sheet.dart';
import 'package:solid_color_fills/src/features/settings/presentation/dialogs/theme_chooser_dialog.dart';
import 'package:solid_color_fills/src/features/settings/presentation/screens/about_screen.dart';
import 'package:solid_color_fills/src/features/settings/presentation/screens/troubleshooting_screen.dart';
import 'package:solid_color_fills/src/features/wallpaper/domain/repositories/wallpaper_repository.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/controllers/wallpaper_controller.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/screens/wallpaper_confirmation_screen.dart';

class MockWallpaperRepo extends Mock implements WallpaperRepository {}

class MockPreferencesService extends Mock implements PreferencesService {}

Widget createTestHarness({
  required Widget child,
  WallpaperRepository? repo,
}) {
  final wallpaperRepo = repo ?? MockWallpaperRepo();

  return MultiProvider(
    providers: [
      ChangeNotifierProvider<WallpaperController>(
        create: (_) => WallpaperController(repository: wallpaperRepo),
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
  group('Screen Widget Tests', () {
    testWidgets('CollectionsScreen renders curated color grid and filters via search bar', (tester) async {
      await tester.pumpWidget(createTestHarness(child: const Scaffold(body: CollectionsScreen())));
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Amber'), findsWidgets);
      expect(find.text('Red'), findsWidgets);
      expect(find.text('Green'), findsWidgets);
      expect(find.text('Blue'), findsWidgets);

      await tester.enterText(find.byType(TextField), 'Amber');
      await tester.pumpAndSettle();
      expect(find.text('Amber'), findsWidgets);
      expect(find.text('Blue'), findsNothing);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Blue'), findsWidgets);
    });

    testWidgets('ColorPickerScreen renders tone picker, buttons, and floating FAB', (tester) async {
      await tester.pumpWidget(createTestHarness(child: const Scaffold(body: ColorPickerScreen())));
      await tester.pumpAndSettle();

      expect(find.text('Select a Tone'), findsOneWidget);
      expect(find.text('Simple RGB'), findsOneWidget);
      expect(find.text('Advanced Color Picker'), findsOneWidget);
      expect(find.byType(CurrentColorCard), findsOneWidget);
      expect(find.text('Color:'), findsNothing);
    });

    testWidgets('AdvancedColorPickerDialog renders faithful layout and hex field', (tester) async {
      await tester.pumpWidget(
        createTestHarness(
          child: const Scaffold(
            body: AdvancedColorPickerDialog(initialColor: Colors.blue),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Pick a color'), findsOneWidget);
      expect(find.text('Select'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.tag_rounded), findsOneWidget);
      expect(find.byIcon(Icons.content_paste_outlined), findsOneWidget);
    });

    testWidgets('SimpleRgbDialog renders SlidePicker and Select button', (tester) async {
      await tester.pumpWidget(
        createTestHarness(
          child: const Scaffold(
            body: SimpleRgbDialog(initialColor: Colors.blue),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Select'), findsOneWidget);
      expect(find.byType(SlidePicker), findsOneWidget);
    });

    testWidgets('MenuBottomSheet renders expected items without Privacy Policy or Mail', (tester) async {
      await tester.pumpWidget(
        createTestHarness(
          child: const Scaffold(body: MenuBottomSheet()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Change Theme'), findsOneWidget);
      expect(find.text('Troubleshooting'), findsOneWidget);
      expect(find.text('About Solid Color Fills'), findsOneWidget);
      expect(find.text('Rate us on Play Store'), findsOneWidget);
      expect(find.text('Share with Friends'), findsOneWidget);
      expect(find.text('Visit Our Website'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsNothing);
      expect(find.textContaining('Mail'), findsNothing);
    });

    testWidgets('ThemeChooserDialog renders Light, Dark, and System Default options', (tester) async {
      await tester.pumpWidget(
        createTestHarness(
          child: const Scaffold(body: ThemeChooserDialog()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Light Theme'), findsOneWidget);
      expect(find.text('Dark Theme'), findsOneWidget);
      expect(find.text('System Default'), findsOneWidget);
    });

    testWidgets('TroubleshootingScreen renders steps without Mail button', (tester) async {
      await tester.pumpWidget(
        createTestHarness(
          child: const Scaffold(body: TroubleshootingScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Troubleshooting'), findsOneWidget);
      expect(find.text('Reasons for failure:'), findsOneWidget);
      expect(find.textContaining('Mail'), findsNothing);
    });

    testWidgets('AboutScreen renders app info, buttons, Privacy Policy, and Licenses', (tester) async {
      await tester.pumpWidget(
        createTestHarness(
          child: const Scaffold(body: AboutScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Solid Color Fills'), findsOneWidget);
      expect(find.text('Play Store'), findsOneWidget);
      expect(find.text('GitHub'), findsOneWidget);
      expect(find.text('PRIVACY POLICY'), findsOneWidget);
      expect(find.text('VIEW LICENSES'), findsOneWidget);
    });

    testWidgets('FeedScreen renders infinite grid and filters via search bar', (tester) async {
      await tester.pumpWidget(createTestHarness(child: const Scaffold(body: FeedScreen())));
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'zzzzzz');
      await tester.pumpAndSettle();
      expect(find.text('No matching colors'), findsOneWidget);

      await tester.tap(find.text('Clear search'));
      await tester.pumpAndSettle();
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('WallpaperConfirmationScreen renders action buttons', (tester) async {
      await tester.pumpWidget(
        createTestHarness(
          child: const WallpaperConfirmationScreen(heroTag: 'test_hero'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Set As Home Screen'), findsOneWidget);
      expect(find.text('Set As Lock Screen'), findsOneWidget);
      expect(find.text('Set As Both'), findsOneWidget);
      expect(find.text('Open in Gallery'), findsOneWidget);
    });

    testWidgets('OnboardingScreen renders pages and next button', (tester) async {
      final mockPrefs = MockPreferencesService();
      when(() => mockPrefs.setFirstLaunchCompleted()).thenAnswer((_) async {});

      var completed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: OnboardingScreen(
            preferencesService: mockPrefs,
            onCompleted: () => completed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Solid Color Fills'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);

      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
      expect(completed, isTrue);
    });

    testWidgets('MaterialPickerWidget navigates primary tones, shades, and back arrow', (tester) async {
      Color? selectedShade;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MaterialPickerWidget(
              onColorChange: (color) => selectedShade = color,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 19 primary swatches shown initially; back button hidden
      expect(find.byType(InkWell), findsNWidgets(19));
      expect(find.byIcon(Icons.arrow_back), findsNothing);

      // Tap first primary tone -> opens shade selection without firing onColorChange yet
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(selectedShade, isNull);

      // Tap a shade -> fires onColorChange
      await tester.tap(find.byType(InkWell).at(1));
      await tester.pumpAndSettle();
      expect(selectedShade, isNotNull);

      // Tap back arrow -> returns to 19 primary swatches
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(InkWell), findsNWidgets(19));
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('ConvexNavigationBar renders tabs and dispatches onTap index', (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: ConvexNavigationBar(
              currentIndex: 0,
              onTap: (index) => tappedIndex = index,
              backgroundColor: Colors.white,
              color: Colors.blue,
              activeColor: Colors.blue,
              items: const [
                ConvexTabItem(icon: Icons.collections, title: 'Collections'),
                ConvexTabItem(icon: Icons.palette, title: 'Color Picker'),
                ConvexTabItem(icon: Icons.all_inclusive, title: 'Feed'),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Color Picker'), findsOneWidget);
      expect(find.text('Feed'), findsOneWidget);

      await tester.tap(find.text('Color Picker'));
      await tester.pumpAndSettle();
      expect(tappedIndex, equals(1));
    });
  });
}
