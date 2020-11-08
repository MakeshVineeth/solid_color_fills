import 'package:flutter/material.dart';

class FixedValues {
  final appTitle = 'Solid Color Fill';

  ThemeData getTheme(Brightness brightness) {
    Color fg = Colors.black;
    Color bg = Colors.white;

    if (brightness == Brightness.dark) {}

    ThemeData themeData = ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      appBarTheme: AppBarTheme(
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
    );
    return themeData;
  }
}
