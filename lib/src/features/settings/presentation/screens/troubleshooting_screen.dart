import 'package:flutter/material.dart';
import 'package:solid_color_fills/src/core/constants/app_constants.dart';

/// Blurred AlertDialog explaining lock screen wallpaper troubleshooting steps.
/// Faithful to Play Store screenshot and original design (without Mail To Dev button).
class TroubleshootingScreen extends StatelessWidget {
  const TroubleshootingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: AppConstants.roundShape,
      buttonPadding: const EdgeInsets.all(10.0),
      content: const SingleChildScrollView(
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Troubleshooting',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
                height: 1,
              ),
            ),
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
    );
  }
}
