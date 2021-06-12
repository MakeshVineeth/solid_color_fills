import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:solid_color_fills/UI/menuThings.dart';
import 'package:solid_color_fills/fixedValues.dart';

class ThemeChooser extends StatelessWidget {
  final MenuThings menuThings = MenuThings();
  final FixedValues fixedValues = FixedValues();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        menuThings.menuItem(
          title: fixedValues.lightThemeDesc,
          function: () => setTheme(context, AdaptiveThemeMode.light),
          context: context,
        ),
        menuThings.menuItem(
          title: fixedValues.darkThemeDesc,
          function: () => setTheme(context, AdaptiveThemeMode.dark),
          context: context,
        ),
        menuThings.menuItem(
          title: fixedValues.systemDefaultTheme,
          function: () => setTheme(context, AdaptiveThemeMode.system),
          context: context,
        ),
      ],
    );
  }

  void setTheme(BuildContext context, AdaptiveThemeMode themeID) =>
      AdaptiveTheme.of(context).setThemeMode(themeID);
}
