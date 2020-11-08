import 'package:flutter/material.dart';

class FixedValues {
  final appTitle = 'Solid Color Fill';

  ThemeData getTheme(Brightness brightness) {
    return (brightness == Brightness.light)
        ? ThemeData.light()
        : ThemeData.dark();
  }
}
