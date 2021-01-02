import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:solid_color_fill/UI/themeChooser.dart';
import 'package:solid_color_fill/fixedValues.dart';
import 'package:solid_color_fill/floating_modal.dart';
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
            url:
                'https://raw.githubusercontent.com/MakeshVineeth/commons/main/privacy_policy.txt',
            forceWebView: true,
            enableJavaScript: true,
          ),
          context: context,
        ),
        menuItem(
          icon: FluentIcons.star_emphasis_24_regular,
          title: 'Rate Us on Play Store',
          function: () => launchUrl(
              url:
                  'https://play.google.com/store/apps/details?id=com.makeshtech.clock'),
          context: context,
        )
      ],
    );
  }

  launchUrl(
      {@required String url,
      bool forceWebView = false,
      bool enableJavaScript = false}) async {
    try {
      if (await canLaunch(url))
        await launch(url,
            forceWebView: forceWebView, enableJavaScript: enableJavaScript);
    } catch (e) {}
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: (icon != null)
          ? FlatButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              onPressed: () {
                Navigator.pop(context);
                function();
              },
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
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
}
