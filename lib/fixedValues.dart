import 'package:flutter/material.dart';

class FixedValues {
  final appTitle = 'Solid Color Fill';
  final BorderRadius fixedCardRadius = BorderRadius.circular(20.0);
  final colorTitleStyle = TextStyle(
    fontWeight: FontWeight.w600,
  );

  // List of Colors
  final Map colorsList = {
    'Amber': Colors.amber,
    'OnePlus Red': Color(0xffeb0029),
    'Yellow': Colors.yellow,
    'Red': Colors.red,
    'Green': Colors.green,
    'Black': Colors.black,
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
  };

  // Height for color card in main tab.
  final double heightCard = 0.65;

  ThemeData getTheme(Brightness brightness) {
    Color fg = Colors.black;
    Color bg = Colors.white;

    if (brightness == Brightness.dark) {
      bg = Colors.black;
      fg = Colors.white;
    }

    ThemeData themeData = ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      applyElevationOverlayColor: brightness == Brightness.dark,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: fg,
        ),
        brightness: brightness,
        centerTitle: true,
        color: bg,
        textTheme: TextTheme(
          headline6: TextStyle(
            color: fg,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: Colors.blue[600],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(bg),
        foregroundColor: MaterialStateProperty.all(fg),
        padding: MaterialStateProperty.all(EdgeInsets.all(20)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: fixedCardRadius,
        )),
        elevation: MaterialStateProperty.all(3),
        overlayColor: MaterialStateProperty.all(Colors.grey[100]),
      )),
    );
    return themeData;
  }
}
