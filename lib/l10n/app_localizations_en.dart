// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Solid Color Fills';

  @override
  String get collections => 'Collections';

  @override
  String get colorPicker => 'Color Picker';

  @override
  String get feed => 'Feed';

  @override
  String get setWallpaper => 'Set Wallpaper';

  @override
  String get homeScreen => 'Set As Home Screen';

  @override
  String get lockScreen => 'Set As Lock Screen';

  @override
  String get bothScreens => 'Set As Both';

  @override
  String get openInGallery => 'Open in Gallery';

  @override
  String get wallpaperConfirmation => 'Wallpaper Confirmation';

  @override
  String colorInfo(String colorName) {
    return 'Color Info: $colorName';
  }

  @override
  String get pickAColor => 'Pick a Color';

  @override
  String get select => 'Select';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get about => 'About';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get troubleshooting => 'Troubleshooting';

  @override
  String get rateApp => 'Rate App';

  @override
  String get shareApp => 'Share App';

  @override
  String get wallpaperSuccess => 'Wallpaper set successfully!';

  @override
  String get wallpaperFailed => 'Failed to set wallpaper. Please try again.';

  @override
  String get searchCollections => 'Search collections...';

  @override
  String get searchFeed => 'Search feed...';

  @override
  String get searchColors => 'Search colors...';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get noMatchingColors => 'No matching colors';

  @override
  String get loadMore => 'Load more';
}
