import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatelessWidget {
  final textStyle = TextStyle(fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        done: const Text('Done'),
        onDone: () => Navigator.pushReplacementNamed(context, '/home'),
        pages: [
          PageViewModel(
            title: 'Welcome',
            body: '',
            image: Image(
              image: AssetImage('assets/logo.png'),
              width: 50,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
