import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solid_color_fills/database/wrapper.dart';
import 'package:solid_color_fills/fixed_values.dart';

void main() async => runZonedGuarded(() async {
      WidgetsFlutterBinding.ensureInitialized();

      final AdaptiveThemeMode savedTheme =
          await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.system;

      runApp(ProviderScope(child: MaterialHome(initialTheme: savedTheme)));
    }, (error, stack) {});

class MaterialHome extends StatelessWidget {
  final AdaptiveThemeMode initialTheme;

  MaterialHome({super.key, required this.initialTheme});

  final FixedValues fixedValues = FixedValues();

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: fixedValues.getTheme(
        brightness: Brightness.light,
        context: context,
      ),
      dark: fixedValues.getTheme(
        brightness: Brightness.dark,
        context: context,
      ),
      initial: initialTheme,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        title: fixedValues.appTitle,
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
