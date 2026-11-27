import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:solid_color_fills/l10n/app_localizations.dart';
import 'package:solid_color_fills/src/core/security/input_validator.dart';
import 'package:solid_color_fills/src/core/storage/preferences_service.dart';
import 'package:solid_color_fills/src/core/theme/app_theme.dart';
import 'package:solid_color_fills/src/core/widgets/animated_dialog.dart';
import 'package:solid_color_fills/src/core/widgets/convex_navigation_bar.dart';
import 'package:solid_color_fills/src/core/widgets/fade_indexed_stack.dart';
import 'package:solid_color_fills/src/core/widgets/minimal_search_bar.dart';
import 'package:solid_color_fills/src/features/collections/presentation/controllers/collections_controller.dart';
import 'package:solid_color_fills/src/features/collections/presentation/screens/collections_screen.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/controllers/color_picker_controller.dart';
import 'package:solid_color_fills/src/features/feed/domain/services/random_color_generator.dart';
import 'package:solid_color_fills/src/features/feed/presentation/controllers/feed_controller.dart';
import 'package:solid_color_fills/src/features/feed/presentation/screens/feed_screen.dart';
import 'package:solid_color_fills/src/features/home/presentation/screens/wrapper_screen.dart';
import 'package:solid_color_fills/src/features/wallpaper/domain/repositories/wallpaper_repository.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/controllers/wallpaper_controller.dart';

class _MockWallpaperRepo extends Mock implements WallpaperRepository {}

class _MockPreferencesService extends Mock implements PreferencesService {}

Widget _buildApp({
  required Widget child,
  ThemeData? theme,
  CollectionsController? collectionsController,
  FeedController? feedController,
  WallpaperController? wallpaperController,
  ColorPickerController? colorPickerController,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<WallpaperController>(
        create: (_) =>
            wallpaperController ??
            WallpaperController(repository: _MockWallpaperRepo()),
      ),
      ChangeNotifierProvider<CollectionsController>(
        create: (_) => collectionsController ?? CollectionsController(),
      ),
      ChangeNotifierProvider<ColorPickerController>(
        create: (_) => colorPickerController ?? ColorPickerController(),
      ),
      ChangeNotifierProvider<FeedController>(
        create: (_) => feedController ?? FeedController(),
      ),
    ],
    child: MaterialApp(
      theme: theme ?? AppTheme.lightTheme,
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
  group('MinimalSearchBar functional tests', () {
    testWidgets('clear button toggles with text and fires single callback', (
      tester,
    ) async {
      var changedCalls = 0;
      var clearCalls = 0;
      String? lastChanged;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinimalSearchBar(
              onChanged: (v) {
                changedCalls++;
                lastChanged = v;
              },
              onClear: () => clearCalls++,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close_rounded), findsNothing);

      await tester.enterText(find.byType(TextField), 'Amber');
      await tester.pump();
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      expect(changedCalls, equals(1));
      expect(lastChanged, equals('Amber'));

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();

      expect(clearCalls, equals(1));
      expect(changedCalls, equals(1)); // Must NOT double-fire onChanged('')
      expect(find.byIcon(Icons.close_rounded), findsNothing);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        isEmpty,
      );
    });

    testWidgets('falls back to onChanged("") when onClear is omitted', (
      tester,
    ) async {
      String? lastChanged;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinimalSearchBar(
              initialQuery: 'Red',
              onChanged: (v) => lastChanged = v,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      expect(lastChanged, equals(''));
    });

    testWidgets('syncs external initialQuery updates without clobbering whitespace', (
      tester,
    ) async {
      var query = '';
      late StateSetter setHostState;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              setHostState = setState;
              return Scaffold(
                body: MinimalSearchBar(
                  initialQuery: query,
                  onChanged: (_) {},
                ),
              );
            },
          ),
        ),
      );

      // External non-empty update populates controller.
      setHostState(() => query = 'Blue');
      await tester.pump();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        equals('Blue'),
      );
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      // External clear clears controller.
      setHostState(() => query = '');
      await tester.pump();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        isEmpty,
      );
      expect(find.byIcon(Icons.close_rounded), findsNothing);

      // User types whitespace while initialQuery stays ''; parent rebuild keeps text.
      await tester.enterText(find.byType(TextField), '   ');
      setHostState(() {});
      await tester.pump();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        equals('   '),
      );
    });

    testWidgets('strips control/BiDi chars, caps length, and scales in RTL dark/light', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: MinimalSearchBar(onChanged: (_) {}),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.enterText(
        find.byType(TextField),
        'Amber\u0000\n\u202E${'x' * 70}',
      );
      await tester.pump();

      final text =
          tester.widget<TextField>(find.byType(TextField)).controller!.text;
      expect(text.contains('\u0000'), isFalse);
      expect(text.contains('\u202E'), isFalse);
      expect(text.length, equals(InputValidator.maxSearchLength));
      expect(tester.takeException(), isNull);
    });
  });

  group('CollectionsScreen search functional tests', () {
    testWidgets('empty state Clear search resets both grid and search field', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildApp(child: const Scaffold(body: CollectionsScreen())),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'zzzzzz');
      await tester.pumpAndSettle();

      expect(find.text('No matching colors'), findsOneWidget);
      expect(find.text('Clear search'), findsOneWidget);

      await tester.tap(find.text('Clear search'));
      await tester.pumpAndSettle();

      expect(find.text('Amber'), findsWidgets);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        isEmpty,
      );
    });

    testWidgets('tapping filtered card opens WallpaperConfirmationScreen and resets scroll on filter', (
      tester,
    ) async {
      final wallpaperController = WallpaperController(
        repository: _MockWallpaperRepo(),
      );
      final pickerController = ColorPickerController();

      await tester.pumpWidget(
        _buildApp(
          wallpaperController: wallpaperController,
          colorPickerController: pickerController,
          child: const Scaffold(body: CollectionsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll down before filtering.
      await tester.drag(find.byType(GridView), const Offset(0, -600));
      await tester.pumpAndSettle();

      final grid = tester.widget<GridView>(find.byType(GridView));
      expect(grid.controller!.offset, greaterThan(0));

      await tester.enterText(find.byType(TextField), 'Orchid');
      await tester.pumpAndSettle();

      // Filter resets scroll offset cleanly to 0 and shows matching card.
      final orchidInGrid = find.descendant(
        of: find.byType(GridView),
        matching: find.text('Orchid'),
      );
      expect(grid.controller!.offset, equals(0));
      expect(orchidInGrid, findsOneWidget);

      await tester.tap(orchidInGrid);
      await tester.pumpAndSettle();

      expect(find.text('Color Info: Orchid'), findsOneWidget);
      expect(wallpaperController.colorTitle, equals('Orchid'));
      expect(pickerController.colorTitle, equals('Orchid'));
      expect(tester.takeException(), isNull);
    });
  });

  group('FeedScreen search functional tests', () {
    testWidgets('filters deterministically, opens confirmation, loads more, and clears via X', (
      tester,
    ) async {
      final feedController = FeedController(
        generator: RandomColorGenerator(Random(42)),
      );
      final targetTitle = feedController.colors.first.name;

      await tester.pumpWidget(
        _buildApp(
          feedController: feedController,
          child: const Scaffold(body: FeedScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Filter by exact first item's title.
      await tester.enterText(find.byType(TextField), targetTitle);
      await tester.pumpAndSettle();

      expect(find.text(targetTitle), findsWidgets);
      // Matched results still allow loading more when < maxItems.
      expect(find.text('Load more'), findsOneWidget);

      // Tapping filtered card opens confirmation cleanly.
      final cardInGrid = find
          .descendant(
            of: find.byType(GridView),
            matching: find.text(targetTitle),
          )
          .first;
      await tester.tap(cardInGrid);
      await tester.pumpAndSettle();
      expect(find.text('Color Info: $targetTitle'), findsOneWidget);

      // Navigate back to Feed.
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Clear via X button restores unfiltered grid.
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
      expect(feedController.isSearching, isFalse);
      expect(find.text('Load more'), findsNothing);
    });

    testWidgets('empty state Load more loads batch and hides when maxItems reached', (
      tester,
    ) async {
      final feedController = FeedController(
        generator: RandomColorGenerator(Random(42)),
      );

      await tester.pumpWidget(
        _buildApp(
          feedController: feedController,
          child: const Scaffold(body: FeedScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'no_such_color');
      await tester.pumpAndSettle();

      expect(find.text('No matching colors'), findsOneWidget);
      expect(find.text('Load more'), findsOneWidget);

      await tester.tap(find.text('Load more'));
      await tester.pumpAndSettle();

      // Max out feed items while searching.
      feedController.loadMore(FeedController.maxItems);
      await tester.pumpAndSettle();

      expect(feedController.hasMore, isFalse);
      expect(find.text('Load more'), findsNothing);

      // Pull-to-refresh in empty state succeeds without exceptions.
      await tester.fling(
        find.byType(CustomScrollView),
        const Offset(0, 300),
        800,
      );
      await tester.pumpAndSettle();
      expect(feedController.hasMore, isTrue);
      expect(tester.takeException(), isNull);
    });
  });

  group('ConvexNavigationBar functional tests', () {
    testWidgets('animates smoothly, handles edge counts, RTL, and semantics', (
      tester,
    ) async {
      var currentIndex = 0;
      int? tapped;
      late StateSetter setHostState;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              setHostState = setState;
              return Scaffold(
                bottomNavigationBar: ConvexNavigationBar(
                  currentIndex: currentIndex,
                  onTap: (i) {
                    tapped = i;
                    setState(() => currentIndex = i);
                  },
                  backgroundColor: Colors.white,
                  color: Colors.blue,
                  activeColor: Colors.blue,
                  items: const [
                    ConvexTabItem(icon: Icons.collections, title: 'Collections'),
                    ConvexTabItem(icon: Icons.palette, title: 'Color Picker'),
                    ConvexTabItem(icon: Icons.all_inclusive, title: 'Feed'),
                  ],
                ),
              );
            },
          ),
        ),
      );

      expect(find.bySemanticsLabel('Collections'), findsOneWidget);
      expect(find.bySemanticsLabel('Color Picker'), findsOneWidget);
      expect(find.bySemanticsLabel('Feed'), findsOneWidget);

      // Tapping active circle dispatches currentIndex.
      await tester.tap(find.byIcon(Icons.collections));
      await tester.pump();
      expect(tapped, equals(0));

      // Switch 0 -> 2 and check mid-animation alignment.
      setHostState(() => currentIndex = 2);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));

      final midFrac = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      final midAlignment = midFrac.alignment as FractionalOffset;
      expect(midAlignment.dx, greaterThan(0.0));
      expect(midAlignment.dx, lessThan(1.0));

      // Rapid switch 2 -> 1 mid-animation.
      setHostState(() => currentIndex = 1);
      await tester.pumpAndSettle();

      final settledFrac = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(
        (settledFrac.alignment as FractionalOffset).dx,
        closeTo(0.5, 0.01),
      );

      // Single item and empty items do not throw RangeError.
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              bottomNavigationBar: ConvexNavigationBar(
                currentIndex: 5,
                onTap: (_) {},
                backgroundColor: Colors.white,
                color: Colors.blue,
                activeColor: Colors.blue,
                items: const [
                  ConvexTabItem(icon: Icons.home, title: 'Only Tab'),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: ConvexNavigationBar(
              currentIndex: 0,
              onTap: (_) {},
              backgroundColor: Colors.white,
              color: Colors.blue,
              activeColor: Colors.blue,
              items: const [],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('FadeIndexedStack functional tests', () {
    testWidgets('starts fade at 0.35, handles rapid switching, duration & children updates', (
      tester,
    ) async {
      var index = 0;
      var duration = const Duration(milliseconds: 140);
      var childCount = 2;
      late StateSetter setHostState;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              setHostState = setState;
              return FadeIndexedStack(
                index: index,
                duration: duration,
                children: [
                  for (var i = 0; i < childCount; i++) Text('Tab $i'),
                ],
              );
            },
          ),
        ),
      );

      final fadeFinder = find.descendant(
        of: find.byType(FadeIndexedStack),
        matching: find.byType(FadeTransition),
      );
      var fade = tester.widget<FadeTransition>(fadeFinder);
      expect(fade.opacity.value, equals(1.0));

      // Switch 0 -> 1 starts at 0.35 opacity.
      setHostState(() => index = 1);
      await tester.pump();
      fade = tester.widget<FadeTransition>(fadeFinder);
      expect(fade.opacity.value, closeTo(0.35, 0.01));

      await tester.pump(const Duration(milliseconds: 70));
      expect(fade.opacity.value, greaterThan(0.35));

      await tester.pumpAndSettle();
      expect(fade.opacity.value, equals(1.0));

      // Grow children, update duration, and rapid-switch.
      setHostState(() {
        childCount = 3;
        duration = const Duration(milliseconds: 220);
        index = 2;
      });
      await tester.pump();
      setHostState(() => index = 0);
      await tester.pumpAndSettle();

      expect(find.text('Tab 0'), findsOneWidget);
      expect(find.text('Tab 2', skipOffstage: false), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('AnimatedDialog functional tests', () {
    testWidgets('outside barrier tap dismisses when barrierDismissible is true and ignores when false', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => unawaited(
                      showAnimatedDialog<void>(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) => const AlertDialog(
                          title: Text('Dismissible Dialog'),
                        ),
                      ),
                    ),
                    child: const Text('Open Dismissible'),
                  ),
                  ElevatedButton(
                    onPressed: () => unawaited(
                      showAnimatedDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Locked Dialog'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    child: const Text('Open Locked'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Barrier dismissible: tapping top-left outside dialog dismisses it.
      await tester.tap(find.text('Open Dismissible'));
      await tester.pumpAndSettle();
      expect(find.text('Dismissible Dialog'), findsOneWidget);

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('Dismissible Dialog'), findsNothing);

      // Non-dismissible: tapping top-left leaves dialog open.
      await tester.tap(find.text('Open Locked'));
      await tester.pumpAndSettle();
      expect(find.text('Locked Dialog'), findsOneWidget);

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('Locked Dialog'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Locked Dialog'), findsNothing);
    });
  });

  group('WrapperScreen functional tests', () {
    testWidgets('wraps AnimatedSwitcher in theme scaffold ColoredBox in light & dark modes', (
      tester,
    ) async {
      final prefs = _MockPreferencesService();
      when(() => prefs.isFirstLaunch()).thenAnswer((_) async => true);
      when(() => prefs.setFirstLaunchCompleted()).thenAnswer((_) async {});
      when(() => prefs.getTabIndex()).thenAnswer((_) async => 0);

      for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
        await tester.pumpWidget(
          _buildApp(
            theme: theme,
            child: WrapperScreen(
              preferencesService: prefs,
              initialShowOnboarding: true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final switcherFinder = find.byType(AnimatedSwitcher);
        expect(switcherFinder, findsOneWidget);

        final backdrop = tester.widget<ColoredBox>(
          find.ancestor(
            of: switcherFinder,
            matching: find.byType(ColoredBox),
          ).first,
        );
        expect(backdrop.color, equals(theme.scaffoldBackgroundColor));
      }

      // Completing onboarding transitions cleanly to HomeScreen.
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
      expect(find.byType(CollectionsScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
