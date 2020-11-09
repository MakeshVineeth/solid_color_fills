import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:solid_color_fill_walls/fixedValues.dart';
import 'package:solid_color_fill_walls/scaffoldHome.dart';
import 'package:solid_color_fill_walls/UI/wall_chooser.dart';

void main() {
  runApp(MaterialHome());
  GestureBinding.instance.resamplingEnabled = true;
}

class MaterialHome extends StatelessWidget {
  final FixedValues fixedValues = FixedValues();

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: fixedValues.getTheme(Brightness.light),
      dark: fixedValues.getTheme(Brightness.dark),
      initial: AdaptiveThemeMode.system,
      builder: (light, dark) => MaterialApp(
        theme: light,
        darkTheme: dark,
        title: fixedValues.appTitle,
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => ScaffoldHome(),
          '/wall_chooser': (context) => WallChooser(),
        },
      ),
    );
  }
}
