import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
        menuThings.menuItem(
          title: fixedValues.systemDefaultTheme,
          function: () => setTheme(context, fixedValues.systemDefaultTheme),
          context: context,
        ),
      ],
    );
  }

  void setTheme(BuildContext context, String themeID) {
    ThemeController controller = ThemeProvider.controllerOf(context);

    if (themeID.contains(fixedValues.systemDefaultTheme)) {
      Brightness platformBrightness =
          SchedulerBinding.instance.window.platformBrightness;

      String defaultTheme = platformBrightness == Brightness.light
          ? fixedValues.lightThemeId
          : fixedValues.darkThemeId;

      controller.setTheme(defaultTheme);
      controller.forgetSavedTheme();
    } else
      controller.setTheme(themeID);
  }
}
