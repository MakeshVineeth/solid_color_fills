import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:solid_color_fills/fixedValues.dart';

class IntroScreen extends StatelessWidget {
  final FixedValues fixedValues = FixedValues();

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          done: const Text(
            'Done',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          onDone: () => Navigator.pushReplacementNamed(context, '/home'),
          next: const Text(
            'Next',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          showNextButton: true,
          skip: const Text(
            'Skip',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          onSkip: () => Navigator.pushReplacementNamed(context, '/home'),
          showSkipButton: true,
          pages: [
            PageViewModel(
              title: 'Welcome to ' + fixedValues.appTitle,
              body:
                  'Click Next to proceed to the Tutorial or you can skip it now.',
              image: Center(
                child: Image(
                  image: AssetImage('assets/logo.png'),
                  height: 120,
                ),
              ),
            ),
            PageViewModel(
              title: 'Cherry-Picked Colors.',
              body:
                  'You can choose from a variety of cherry-picked colors available on Collections Tab.',
              image: Center(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/Tut_1.png'),
                    ),
                  ),
                ),
              ),
            ),
            PageViewModel(
              title: 'Set as Wallpaper',
              body:
                  'Click on any Color to open the Wall Chooser, where you can set the Color as your Lockscreen or Homescreen Wallpaper',
              image: Center(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/Tut_2.png'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
