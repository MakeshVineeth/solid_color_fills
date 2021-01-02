import 'package:flutter/material.dart';
import 'package:solid_color_fill/UI/menuThings.dart';
import 'package:solid_color_fill/fixedValues.dart';
import 'package:theme_provider/theme_provider.dart';

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
          function: () => ThemeProvider.controllerOf(context)
              .setTheme(fixedValues.lightThemeId),
          context: context,
        ),
        menuThings.menuItem(
          title: fixedValues.darkThemeDesc,
          function: () => ThemeProvider.controllerOf(context)
              .setTheme(fixedValues.darkThemeId),
          context: context,
        ),
      ],
    );
  }
}
