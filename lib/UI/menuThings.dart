import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:solid_color_fills/UI/themeChooser.dart';
import 'package:solid_color_fills/fixedValues.dart';
import 'package:solid_color_fills/floating_modal.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuThings extends StatelessWidget {
  final FixedValues fixedValues = FixedValues();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        menuItem(
          icon: FluentIcons.dark_theme_24_regular,
          title: 'Change Theme',
          function: () => showFloatingModalBottomSheet(
              context: context, builder: (context) => ThemeChooser()),
          context: context,
        ),
        menuItem(
          context: context,
          icon: FluentIcons.info_28_regular,
          title: 'About ' + fixedValues.appTitle,
          function: () => showAbout(context),
        ),
        menuItem(
          icon: FluentIcons.shield_24_regular,
          title: 'Privacy Policy',
          function: () => launchUrl(
            url: 'https://makeshvineeth.github.io/privacy_policy/',
          ),
          context: context,
        ),
        menuItem(
          icon: FluentIcons.star_emphasis_24_regular,
          title: 'Rate us on Play Store',
          function: () {
            final InAppReview inAppReview = InAppReview.instance;
            inAppReview.openStoreListing();
          },
          context: context,
        )
      ],
    );
  }

  void launchUrl(
      {@required String url,
      bool forceWebView = false,
      bool enableJavaScript = false}) async {
    try {
      url = Uri.encodeFull(url);
      if (await canLaunch(url))
        await launch(
          url,
          forceWebView: forceWebView,
          enableJavaScript: enableJavaScript,
        );
    } catch (_) {}
  }

  void showAbout(BuildContext context) => showAboutDialog(
        context: context,
        applicationName: fixedValues.appTitle,
        applicationLegalese: fixedValues.appLegalese,
        applicationVersion: fixedValues.appVersion,
        applicationIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo.png',
            width: 30,
          ),
        ),
      );

  Widget menuItem({
    IconData icon,
    @required String title,
    @required Function function,
    @required BuildContext context,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: (icon != null)
            ? TextButton.icon(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
                  foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).textTheme.button.color),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  function();
                },
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Icon(
                    icon,
                  ),
                ),
                label: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              )
            : MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                onPressed: () {
                  Navigator.pop(context);
                  function();
                },
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
      );
}
