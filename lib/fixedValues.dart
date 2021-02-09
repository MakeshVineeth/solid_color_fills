import 'package:flutter/material.dart';

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

  final lightThemeId = 'light_theme';
  final lightThemeDesc = 'Light Theme';
  final darkThemeId = 'dark_theme';
  final darkThemeDesc = 'Dark Theme';

  // List of Colors
  final Map colorsList = {
    'Amber': Colors.amber,
    'OnePlus Red': Color(0xffeb0029),
    'Midnight Blue': Color(0xff2c3e50),
    'Red': Colors.red,
    'Green': Colors.green,
    'Pitch Black': Colors.black,
    'Blue': Colors.blue,
    'Neumorphic White': Color(0xffe0e5ec),
    'Neumorphic Black': Color(0xff26282B),
    'YouTube': Color(0xffcd201f),
    'WhatsApp': Color(0xff25D366),
    'Twitter': Color(0xff55acee),
    'Reddit': Color(0xffff5700),
    'Facebook': Color(0xff3b5999),
    'HackerNews': Color(0xffff6600),
    'Quora': Color(0xffb92b27),
    'Purple': Colors.purple,
    'White': Colors.white,
    'Caramel': Color(0xff8f614b),
    'Moon': Color(0xff989da6),
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
        color: (isDark) ? Colors.grey[900] : bg,
        elevation: elevation,
      ),
      cardColor: bg,
      cardTheme: CardTheme(
        color: bg,
        elevation: elevation,
        shape: roundShape,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(bg),
        foregroundColor: MaterialStateProperty.all(fg),
        padding: MaterialStateProperty.all(EdgeInsets.all(20)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: fixedCardRadius)),
        elevation: MaterialStateProperty.all(elevation),
        overlayColor: MaterialStateProperty.all(
            (isDark) ? Colors.black12 : Colors.grey[100]),
      )),
    );

    return themeData;
  }
}
