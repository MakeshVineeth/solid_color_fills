import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FixedValues {
  final String appTitle = 'Solid Color Fills';
  final TextStyle appTitleStyle = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 25,
    height: 1,
  );

  final String appLegalese =
      'An App that lets you set your favorite color as Device Wallpaper. Not satisfied with default colors? Then you can choose your own color by using the Color Picker provided in the app. Solid Color Fills has Beautiful UI and Privacy Friendly.';
  final String appVersion = '1.0.5';

  final BorderRadius fixedCardRadius = BorderRadius.circular(20.0);
  final roundShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0));
  final colorTitleStyle = TextStyle(fontWeight: FontWeight.w600);
  final logoFile = 'logo.png';

  final String lightThemeDesc = 'Light Theme';
  final String darkThemeDesc = 'Dark Theme';
  final String systemDefaultTheme = 'System Default';
  final Color bottomNavBg = Colors.grey[900]!;

  final String logo = 'logo.png';
  final double sigmaLevel = 5.0;

  static const String collectionScreenTitle = 'Collections';
  static const String colorPickersScreenTitle = 'Color Picker';
  static const String feedScreenTitle = 'Feed';
  static const String tabIndexPref = 'tab_index';

  // List of Colors
  final Map<String, dynamic> colorsList = {
    'Amber': Colors.amber,
    'Red': Colors.red,
    'Green': Colors.green,
    'Blue': Colors.blue,
    'OnePlus Red': '#EB0029',
    'Pitch Black': Colors.black,
    'White': Colors.white,
    'Neumorphic White': '#E0E5EC',
    'Neumorphic Black': '#26282B',
    'Midnight Blue': '#2C3E50',
    'Foursquare': '#F94877',
    'Reddit': '#FF4500',
    'WhatsApp': '#075E54',
    'Twitch': '#9146ff',
    'Facebook': '#1877F2',
    'Classic Blue': '#34568B',
    'Rose Quartz': '#F7CAC9',
    'Caramel': '#8F614B',
    'Moon': '#989DA6',
    'Serenity': '#92A8D1',
    'HackerNews': '#FF6600',
    'Crimson': '#DC143C',
    'Teal': Colors.teal,
    'Cornflower Blue': '#6495ED',
    'Royal Blue': '#4169E1',
    'Corn Silk': '#FFF8DC',
    'Forest Green': '#228B22',
    'Silver': '#C0C0C0',
    'Bisque': '#FFE4C4',
    'Telegram': '#0088CC',
    'Mauve': '#E0B0FF',
    'Khaki': '#F0E68C',
    'Indigo': Colors.indigo,
    'Pink': Colors.pink,
    'Sky Blue': '#87CEEB',
    'Orchid': '#DA70D6'
  };

  ThemeData getTheme({
    required Brightness brightness,
    required BuildContext context,
  }) {
    Color fg = Colors.black;
    Color bg = Colors.white;
    double elevation = 3.0;
    bool isDark = brightness == Brightness.dark;
    Color? primaryColor = (isDark) ? Colors.amber : Colors.blue[600];

    if (isDark) {
      bg = Colors.black54;
      fg = Colors.white;
      elevation = 10.0;
    }

    ThemeData themeData = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: isDark ? Colors.black : bg,
      applyElevationOverlayColor: brightness == Brightness.dark,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: fg),
        elevation: isDark ? 0 : elevation,
        backgroundColor: isDark ? Colors.black : bg,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: brightness,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
        centerTitle: true,
        titleTextStyle:
            Theme.of(context).textTheme.titleLarge!.copyWith(color: fg),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: (isDark) ? bottomNavBg : bg,
        elevation: elevation,
      ),
      cardColor: bg,
      cardTheme: CardTheme(
        color: bg,
        elevation: elevation,
        shape: roundShape,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: fg,
          backgroundColor: bg,
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: fixedCardRadius),
          elevation: elevation,
          enableFeedback: true,
        ),
      ),
    );

    return themeData;
  }

  static SystemUiOverlayStyle changeNavBarColor(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;

    final SystemUiOverlayStyle flatTheme = SystemUiOverlayStyle(
      systemNavigationBarColor:
          isLightTheme ? Colors.white : FixedValues().bottomNavBg,
      systemNavigationBarIconBrightness:
          isLightTheme ? Brightness.dark : Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          isLightTheme ? Brightness.dark : Brightness.light,
    );

    SystemChrome.setSystemUIOverlayStyle(flatTheme);
    return flatTheme;
  }

  static TextStyle buttonText() => const TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        fontSize: 15,
      );
}
