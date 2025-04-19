import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solid_color_fills/fixedValues.dart';

class IntroScreen extends StatelessWidget {
  final FixedValues fixedValues = FixedValues();
  final Function function;

  IntroScreen({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FixedValues.changeNavBarColor(context).copyWith(
        systemNavigationBarColor:
            Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
      ),
      child: Scaffold(
        body: SafeArea(
          child: IntroductionScreen(
            animationDuration: 280,
            curve: Curves.decelerate,
            done: textWidget('Done'),
            onDone: () => finishTask(context),
            next: textWidget('Next'),
            showNextButton: true,
            skip: textWidget('Skip'),
            onSkip: () => finishTask(context),
            showSkipButton: true,
            pages: [
              PageViewModel(
                title: 'Welcome to ${fixedValues.appTitle}',
                body:
                    'Click Next to proceed to the Tutorial or you can skip it now.',
                image: Center(
                  child: Image(
                    image: AssetImage('assets/logo.png'),
                    height: 120,
                  ),
                ),
              ),
              returnPage(
                title: 'Cherry-Picked Colors.',
                body:
                    'You can choose from a variety of cherry-picked colors available on Collections Tab.',
                path: 'assets/Tut_1.png',
              ),
              returnPage(
                title: 'Set as Wallpaper',
                body:
                    'Click on any Color to open the Wall Chooser, where you can set the Color as your Lockscreen or Homescreen Wallpaper',
                path: 'assets/Tut_2.png',
              ),
              returnPage(
                title: 'Select a Material Tone',
                body:
                    'Not satisfied with the default collections? You can choose your own tone from the Material Color Picker available in Color Picker Tab.',
                path: 'assets/Tut_3.png',
              ),
              returnPage(
                title: 'Advanced Color Picker',
                body:
                    'Feeling little bored? You can play around with the Advanced Color Picker included in the app.',
                path: 'assets/Tut_4.png',
              )
            ],
          ),
        ),
      ),
    );
  }

  void finishTask(BuildContext context) async {
    await firstTime();
    function();
  }

  Future<void> firstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);
  }

  Text textWidget(String text) => Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      );

  PageViewModel returnPage({@required title, @required body, @required path}) =>
      PageViewModel(
        title: title,
        body: body,
        image: Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(path),
              ),
            ),
          ),
        ),
      );
}
