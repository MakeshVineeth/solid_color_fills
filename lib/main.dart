import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:solid_color_fill/fixedValues.dart';
import 'package:solid_color_fill/scaffoldHome.dart';
import 'package:theme_provider/theme_provider.dart';

void main() {
  runApp(ProviderScope(child: MaterialHome()));
  GestureBinding.instance.resamplingEnabled = true;
}

class MaterialHome extends StatelessWidget {
  final FixedValues fixedValues = FixedValues();

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: [
        AppTheme(
            id: 'light_theme',
            data: fixedValues.getTheme(
                brightness: Brightness.light, context: context),
            description: 'Light Theme'),
        AppTheme(
            id: 'dark_theme',
            data: fixedValues.getTheme(
                brightness: Brightness.dark, context: context),
            description: 'Dark Theme'),
      ],
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            theme: ThemeProvider.themeOf(themeContext).data,
            title: fixedValues.appTitle,
            debugShowCheckedModeBanner: false,
            home: ScaffoldHome(),
          ),
        ),
      ),
    );
  }
}
