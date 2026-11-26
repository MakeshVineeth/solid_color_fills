import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:solid_color_fills/l10n/app_localizations.dart';
import 'package:solid_color_fills/src/core/constants/app_constants.dart';
import 'package:solid_color_fills/src/core/storage/preferences_service.dart';
import 'package:solid_color_fills/src/core/theme/app_theme.dart';
import 'package:solid_color_fills/src/features/collections/presentation/controllers/collections_controller.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/controllers/color_picker_controller.dart';
import 'package:solid_color_fills/src/features/feed/presentation/controllers/feed_controller.dart';
import 'package:solid_color_fills/src/features/home/presentation/screens/wrapper_screen.dart';
import 'package:solid_color_fills/src/features/wallpaper/data/repositories/wallpaper_repository_impl.dart';
import 'package:solid_color_fills/src/features/wallpaper/domain/repositories/wallpaper_repository.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/controllers/wallpaper_controller.dart';

/// Root application widget orchestrating dependency injection, themes, and localization.
class SolidColorFillsApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  final PreferencesService preferencesService;
  final WallpaperRepository? wallpaperRepository;
  final bool? initialShowOnboarding;
  final int? initialTabIndex;

  const SolidColorFillsApp({
    super.key,
    this.savedThemeMode,
    required this.preferencesService,
    this.wallpaperRepository,
    this.initialShowOnboarding,
    this.initialTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PreferencesService>.value(value: preferencesService),
        Provider<WallpaperRepository>(
          create: (_) => wallpaperRepository ?? WallpaperRepositoryImpl(),
        ),
        ChangeNotifierProvider<WallpaperController>(
          create: (context) => WallpaperController(
            repository: context.read<WallpaperRepository>(),
          ),
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
      child: AdaptiveTheme(
        light: AppTheme.lightTheme,
        dark: AppTheme.darkTheme,
        initial: savedThemeMode ?? AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: WrapperScreen(
            preferencesService: preferencesService,
            initialShowOnboarding: initialShowOnboarding,
            initialTabIndex: initialTabIndex,
          ),
        ),
      ),
    );
  }
}
