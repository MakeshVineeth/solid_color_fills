import 'package:flutter/material.dart';
import 'package:solid_color_fills/UI/animations/fade_scale_widget.dart';
import 'package:solid_color_fills/UI/animations/show_blur_dialog.dart';
import 'package:solid_color_fills/UI/dialogs/dialog_text_btn.dart';
import 'package:solid_color_fills/fixed_values.dart';
import 'package:url_launcher/url_launcher.dart';

class TroubleshootingPage extends StatelessWidget {
  TroubleshootingPage({super.key});

  final FixedValues _fixedValues = FixedValues();

  @override
  Widget build(BuildContext context) {
    return FadeScale(
      child: AlertDialog(
        shape: _fixedValues.roundShape,
        buttonPadding: const EdgeInsets.all(10.0),
        actions: [
          DialogTextBtn(
            function: () {
              try {
                final uri = Uri.parse('mailto:makeshvineeth9@gmail.com');
                launchUrl(uri, mode: LaunchMode.externalApplication);
              } catch (_) {}
            },
            title: 'Mail To Dev',
          ),
        ],
        content: SingleChildScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Troubleshooting', style: _fixedValues.appTitleStyle),
                    SizedBox(height: 20),
                    Text(
                      'If you are facing any issues while setting the lockscreen wallpaper, please try the following steps:',
                    ),
                    SizedBox(height: 10),
                    Text(
                      '1. Choose any color of your choice.\n'
                      '2. Choose the Open in Gallery option.\n'
                      '3. Open in the default System Gallery app.\n'
                      '4. Try to set the lockscreen wallpaper from the System Gallery app.\n'
                      '5. Contact support if the issue persists.',
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Reasons for failure:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Some OEMs deliberately block third-party apps from setting the lockscreen wallpaper.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showTroubleShootDialogFunc(BuildContext context) async {
    try {
      showBlurDialog(context: context, child: TroubleshootingPage());
    } catch (_) {}
  }
}
