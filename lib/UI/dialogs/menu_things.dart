import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:app_review_plus/app_review_plus.dart';
import 'package:solid_color_fills/UI/dialogs/floating_modal.dart';
import 'package:solid_color_fills/UI/dialogs/theme_chooser.dart';
import 'package:solid_color_fills/UI/screens/troubleshooting_page.dart';
import 'package:solid_color_fills/fixed_values.dart';
import 'package:solid_color_fills/UI/screens/about_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class MenuThings extends StatelessWidget {
  final FixedValues fixedValues = FixedValues();

  MenuThings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        menuItem(
          icon: FluentIcons.dark_theme_24_regular,
          title: 'Change Theme',
          function:
              () => showFloatingModalBottomSheet(
                context: context,
                builder: (context) => ThemeChooser(),
                backgroundColor: null,
              ),
          context: context,
        ),
        menuItem(
          icon: FluentIcons.question_circle_24_regular,
          title: 'Troubleshooting',
          function: () {
            TroubleshootingPage.showTroubleShootDialogFunc(context);
          },
          context: context,
        ),
        menuItem(
          context: context,
          icon: FluentIcons.info_28_regular,
          title: 'About ${fixedValues.appTitle}',
          function: () => AboutPage.showAboutDialogFunc(context),
        ),
        menuItem(
          icon: FluentIcons.shield_24_regular,
          title: 'Privacy Policy',
          function:
              () => _launchUrl(
                url: 'https://makeshvineeth.github.io/privacy_policy/',
              ),
          context: context,
        ),
        menuItem(
          icon: FluentIcons.star_emphasis_24_regular,
          title: 'Rate us on Play Store',
          function: () {
            AppReview.storeListing;
          },
          context: context,
        ),
        menuItem(
          icon: FluentIcons.share_24_regular,
          title: 'Share with Friends',
          function: () async {
            final result = await SharePlus.instance.share(
              ShareParams(
                text:
                    'Check out this Amazing App - https://play.google.com/store/apps/details?id=com.makeshtech.solid_color_fills',
                subject: 'Solid Color Fills',
                title: 'Share Solid Color Fills',
                uri: Uri(
                  scheme: 'https',
                  host: 'play.google.com',
                  path: 'store/apps/details',
                  queryParameters: {'id': 'com.makeshtech.solid_color_fills'},
                ),
              ),
            );

            if (result.status == ShareResultStatus.success) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Thank you for sharing our App!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            }
          },
          context: context,
        ),
        menuItem(
          icon: FluentIcons.earth_24_regular,
          title: 'Visit Our Website',
          function: () {
            _launchUrl(url: 'https://makeshvineeth.github.io/');
          },
          context: context,
        ),
      ],
    );
  }

  void _launchUrl({required String url}) async {
    try {
      final uri = Uri.parse(url);
      launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Widget menuItem({
    IconData? icon,
    required String title,
    required Function function,
    required BuildContext context,
  }) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    child:
        (icon != null)
            ? TextButton.icon(
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                foregroundColor: WidgetStateProperty.all(
                  Theme.of(context).textTheme.labelLarge!.color,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                function();
              },
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Icon(icon),
              ),
              label: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, height: 1),
              ),
            )
            : MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onPressed: () {
                Navigator.pop(context);
                function();
              },
              child: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
            ),
  );
}
