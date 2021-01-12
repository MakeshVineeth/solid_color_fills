import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
          onDone: () {
            _firstTime();
            return Navigator.pop(context);
          },
          next: const Text(
            'Next',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          showNextButton: true,
          skip: const Text(
            'Skip',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          onSkip: () {
            _firstTime();
            return Navigator.pop(context);
          },
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
            PageViewModel(
              title: 'Select a Material Tone',
              body:
                  'Not satisfied with the default collections? You can choose your own tone from the Material Color Picker available in Color Picker Tab.',
              image: Center(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/Tut_3.png'),
                    ),
                  ),
                ),
              ),
            ),
            PageViewModel(
              title: 'Advanced Color Picker',
              body:
                  'Feeling little bored? You can play around with the Advanced Color Picker included in the app.',
              image: Center(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/Tut_4.png'),
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

_firstTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('first_launch', false);
}
