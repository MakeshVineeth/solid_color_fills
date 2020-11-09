import 'package:flutter/material.dart';

class FixedValues {
  final appTitle = 'Solid Color Fill';
  final BorderRadius fixedCardRadius = BorderRadius.circular(20.0);
  final colorTitleStyle = TextStyle(
    fontWeight: FontWeight.w600,
  );

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
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        )),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: fixedCardRadius,
        )),
        elevation: MaterialStateProperty.all(3),
      )),
    );
    return themeData;
  }
}
