import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FixedValues {
  final appTitle = 'Solid Color Fills';
  final appLegalese =
      'An App that lets you set your favorite color as Device Wallpaper. Not satisfied with default colors? Then you can choose your own color by using the Color Picker provided in the app. Solid Color Fills has Beautiful UI and Privacy Friendly.';
  final appVersion = '1.0.0';

  final BorderRadius fixedCardRadius = BorderRadius.circular(20.0);
  final roundShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0));
  final colorTitleStyle = TextStyle(fontWeight: FontWeight.w600);
  final logoFile = 'logo.png';

  final lightThemeDesc = 'Light Theme';
  final darkThemeDesc = 'Dark Theme';
  final systemDefaultTheme = 'System Default';
  static final Color bottomNavBg = Colors.grey[900];

  // List of Colors
  final Map colorsList = {
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
  };

  ThemeData getTheme(
      {@required Brightness brightness, @required BuildContext context}) {
    Color fg = Colors.black;
    Color bg = Colors.white;
    double elevation = 3.0;
    bool isDark = brightness == Brightness.dark;
    Color primaryColor = (isDark) ? Colors.amber : Colors.blue[600];

    if (isDark) {
      bg = Colors.black54;
      fg = Colors.white;
      elevation = 10.0;
    }

    ThemeData themeData = ThemeData(
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: isDark ? Colors.black : bg,
      applyElevationOverlayColor: brightness == Brightness.dark,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: fg),
        elevation: isDark ? 0 : elevation,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? bg
            : Colors.black,
        brightness: brightness,
        centerTitle: true,
        textTheme: TextTheme(
          headline6: Theme.of(context).textTheme.headline6.copyWith(color: fg),
        ),
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
        onPrimary: fg,
        primary: bg,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: fixedCardRadius),
        elevation: elevation,
        enableFeedback: true,
      )),
    );

    return themeData;
  }

  static SystemUiOverlayStyle changeNavBarColor(BuildContext context) {
    SystemUiOverlayStyle _light = SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    );

    SystemUiOverlayStyle _dark = SystemUiOverlayStyle(
      systemNavigationBarColor: FixedValues.bottomNavBg,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    );

    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(isLightTheme ? _light : _dark);
    return isLightTheme ? _light : _dark;
  }
}
