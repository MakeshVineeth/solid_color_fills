import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:solid_color_fill/fixedValues.dart';

class MenuThings extends StatelessWidget {
  final FixedValues fixedValues = FixedValues();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        menuItem(
          context: context,
          icon: FluentIcons.info_28_regular,
          title: 'About',
          function: () => showAbout(context),
        ),
      ],
    );
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
    @required IconData icon,
    @required String title,
    @required Function function,
    @required BuildContext context,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: FlatButton.icon(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          onPressed: () {
            Navigator.pop(context);
            function();
          },
          icon: Icon(
            icon,
          ),
          label: Text(
            title,
          ),
        ),
      );
}
