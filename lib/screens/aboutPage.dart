import 'package:flutter/material.dart';
import 'package:solid_color_fills/UI/animations/showBlurDialog.dart';
import 'package:solid_color_fills/UI/dialogs/dialogTextBtn.dart';
import 'package:solid_color_fills/fixedValues.dart';
import 'package:url_launcher/url_launcher.dart';

import '../UI/animations/fade_scale_widget.dart';
import '../UI/buttons_links.dart';

class AboutPage extends StatelessWidget {
  final FixedValues _fixedValues = FixedValues();

  @override
  Widget build(BuildContext context) {
    return FadeScale(
      child: AlertDialog(
        shape: _fixedValues.roundShape,
        buttonPadding: const EdgeInsets.all(10.0),
        actions: [
          DialogTextBtn(
            function: () => showLicensePage(
                context: context,
                applicationName: _fixedValues.appTitle,
                applicationVersion: _fixedValues.appVersion,
                applicationLegalese: _fixedValues.appLegalese,
                applicationIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: applicationIconImg(),
                )),
            title: 'VIEW LICENSES',
          ),
        ],
        content: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              applicationIconImg(),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _fixedValues.appTitle,
                      style: _fixedValues.appTitleStyle,
                    ),
                    Text(
                      _fixedValues.appVersion,
                    ),
                    SizedBox(height: 20),
                    Text(
                      _fixedValues.appLegalese,
                      style: appLegaleseStyle,
                    ),
                    SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ButtonLinks(
                              title: 'Play Store',
                              icon: Icons.shop_outlined,
                              backgroundColor: Color(0xff078C30),
                              function: () => launchUrl(
                                  url:
                                      'https://play.google.com/store/apps/details?id=com.makeshtech.solid_color_fills'),
                            ),
                            SizedBox(width: 5),
                            ButtonLinks(
                              title: 'GitHub',
                              icon: Icons.code_outlined,
                              backgroundColor: Color(0xff24292E),
                              function: () => launchUrl(
                                  url:
                                      'https://github.com/MakeshVineeth/solid_color_fills'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget applicationIconImg() => Image(
        image: AssetImage('assets/' + _fixedValues.logo),
        width: 30,
      );

  Future<void> launchUrl({
    required String url,
    bool forceWebView = false,
    bool enableJavaScript = false,
  }) async {
    try {
      final urlEncoded = Uri.encodeFull(url);
      if (await canLaunchUrl(Uri.parse(urlEncoded)))
        launchUrl(
          url: urlEncoded,
          forceWebView: forceWebView,
          enableJavaScript: enableJavaScript,
        );
    } catch (_) {}
  }

  final TextStyle appLegaleseStyle = TextStyle(
      // any styles
      );

  static void showAboutDialogFunc(BuildContext context) async {
    try {
      showBlurDialog(
        context: context,
        child: AboutPage(),
      );
    } catch (_) {}
  }
}
