import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solid_color_fills/UI/intro_screen.dart';
import 'package:solid_color_fills/fixedValues.dart';
import 'package:solid_color_fills/scaffoldHome.dart';
import 'package:theme_provider/theme_provider.dart';

void main() => runApp(ProviderScope(child: MaterialHome()));

class MaterialHome extends StatelessWidget {
  final FixedValues fixedValues = FixedValues();

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: false,
      onInitCallback: (controller, savedThemeFuture) async {
        String savedTheme = await savedThemeFuture;

        if (savedTheme != null) {
          controller.setTheme(savedTheme);
        } else {
          Brightness platformBrightness =
              SchedulerBinding.instance.window.platformBrightness;
          String defaultTheme = platformBrightness == Brightness.light
              ? fixedValues.lightThemeId
              : fixedValues.darkThemeId;

          controller.setTheme(defaultTheme);
          controller.forgetSavedTheme();
        }
      },
      themes: [
        AppTheme(
          id: fixedValues.lightThemeId,
          data: fixedValues.getTheme(
              brightness: Brightness.light, context: context),
          description: fixedValues.lightThemeDesc,
        ),
        AppTheme(
          id: fixedValues.darkThemeId,
          data: fixedValues.getTheme(
              brightness: Brightness.dark, context: context),
          description: fixedValues.darkThemeDesc,
        ),
      ],
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            theme: ThemeProvider.themeOf(themeContext).data,
            title: fixedValues.appTitle,
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/': (themeContext) => ScaffoldHome(),
              '/intro': (themeContext) => IntroScreen(),
            },
          ),
        ),
      ),
    );
  }
}
