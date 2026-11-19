import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

/// Floating modal content for switching between Light, Dark, and System Default themes.
class ThemeChooserDialog extends StatelessWidget {
  const ThemeChooserDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.labelLarge?.color;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ThemeOptionButton(
            title: 'Light Theme',
            textColor: textColor,
            onPressed: () {
              AdaptiveTheme.of(context).setLight();
              Navigator.of(context).pop();
            },
          ),
          _ThemeOptionButton(
            title: 'Dark Theme',
            textColor: textColor,
            onPressed: () {
              AdaptiveTheme.of(context).setDark();
              Navigator.of(context).pop();
            },
          ),
          _ThemeOptionButton(
            title: 'System Default',
            textColor: textColor,
            onPressed: () {
              AdaptiveTheme.of(context).setSystem();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _ThemeOptionButton extends StatelessWidget {
  final String title;
  final Color? textColor;
  final VoidCallback onPressed;

  const _ThemeOptionButton({
    required this.title,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
