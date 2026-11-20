import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:solid_color_fills/src/core/constants/app_constants.dart';
import 'package:solid_color_fills/src/core/widgets/animated_dialog.dart';
import 'package:solid_color_fills/src/core/widgets/floating_modal_sheet.dart';
import 'package:solid_color_fills/src/features/settings/presentation/dialogs/theme_chooser_dialog.dart';
import 'package:solid_color_fills/src/features/settings/presentation/screens/about_screen.dart';
import 'package:solid_color_fills/src/features/settings/presentation/screens/troubleshooting_screen.dart';
import 'package:url_launcher/url_launcher.dart';

/// Floating modal bottom sheet displaying app options faithful to original MenuThings.
/// Intentionally excludes Privacy Policy here (provided inside About popup).
class MenuBottomSheet extends StatelessWidget {
  const MenuBottomSheet({super.key});

  Future<void> _rateOnGooglePlay() async {
    final marketUri = Uri.parse(
      'market://details?id=com.makeshtech.solid_color_fills',
    );
    final webUri = Uri.parse(AppConstants.playStoreUrl);
    if (marketUri.scheme != 'market' || webUri.scheme != 'https') {
      return;
    }
    try {
      final launched = await launchUrl(
        marketUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      try {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } catch (_) {}
    }
  }

  Future<void> _shareApp(ScaffoldMessengerState messenger) async {
    try {
      final result = await SharePlus.instance.share(
        ShareParams(
          subject: AppConstants.appName,
          title: 'Check out this amazing app called Solid Color Fills!',
          uri: Uri.parse(AppConstants.playStoreUrl),
        ),
      );
      if (result.status == ShareResultStatus.success) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Thank you for sharing our App!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {}
  }

  Future<void> _visitWebsite() async {
    final uri = Uri.tryParse(AppConstants.developerWebsiteUrl);
    if (uri == null || uri.scheme != 'https') {
      return;
    }
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MenuItemButton(
            icon: FluentIcons.dark_theme_24_regular,
            title: 'Change Theme',
            onPressed: () {
              Navigator.of(context).pop();
              unawaited(
                showFloatingModalBottomSheet<void>(
                  context: context,
                  builder: (_) => const ThemeChooserDialog(),
                ),
              );
            },
          ),
          _MenuItemButton(
            icon: FluentIcons.question_circle_24_regular,
            title: 'Troubleshooting',
            onPressed: () {
              Navigator.of(context).pop();
              unawaited(
                showAnimatedDialog<void>(
                  context: context,
                  builder: (_) => const TroubleshootingScreen(),
                ),
              );
            },
          ),
          _MenuItemButton(
            icon: FluentIcons.info_28_regular,
            title: 'About ${AppConstants.appName}',
            onPressed: () {
              Navigator.of(context).pop();
              unawaited(
                showAnimatedDialog<void>(
                  context: context,
                  builder: (_) => const AboutScreen(),
                ),
              );
            },
          ),
          _MenuItemButton(
            icon: FluentIcons.star_emphasis_24_regular,
            title: 'Rate us on Play Store',
            onPressed: () {
              Navigator.of(context).pop();
              unawaited(_rateOnGooglePlay());
            },
          ),
          _MenuItemButton(
            icon: FluentIcons.share_24_regular,
            title: 'Share with Friends',
            onPressed: () {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.of(context).pop();
              unawaited(_shareApp(messenger));
            },
          ),
          _MenuItemButton(
            icon: FluentIcons.earth_24_regular,
            title: 'Visit Our Website',
            onPressed: () {
              Navigator.of(context).pop();
              unawaited(_visitWebsite());
            },
          ),
        ],
      ),
    );
  }
}

class _MenuItemButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  const _MenuItemButton({
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: TextButton.icon(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          foregroundColor: WidgetStateProperty.all(
            Theme.of(context).textTheme.labelLarge?.color,
          ),
        ),
        onPressed: onPressed,
        icon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Icon(icon),
        ),
        label: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, height: 1),
        ),
      ),
    );
  }
}
