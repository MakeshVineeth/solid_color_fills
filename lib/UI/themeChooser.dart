import 'package:flutter/material.dart';
import 'package:solid_color_fills/UI/menuThings.dart';
import 'package:solid_color_fills/fixedValues.dart';
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
          function: () => setTheme(context, fixedValues.lightThemeId),
          context: context,
        ),
        menuThings.menuItem(
          title: fixedValues.darkThemeDesc,
          function: () => setTheme(context, fixedValues.darkThemeId),
          context: context,
        ),
      ],
    );
  }

  void setTheme(BuildContext context, String themeID) =>
      ThemeProvider.controllerOf(context).setTheme(themeID);
}
