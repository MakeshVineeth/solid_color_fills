import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solid_color_fills/screens/intro_screen.dart';
import 'package:solid_color_fills/bottomNavigation.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Future<void> future;
  Widget currentChild = placeHolder();

  Future<void> initialTasks() async {
    try {
      await FlutterDisplayMode.setHighRefreshRate();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool showTutorial = prefs.getBool('first_launch') ?? true;

      setState(() => currentChild =
          showTutorial ? IntroScreen(function: hideTutorial) : ScaffoldHome());
    } catch (_) {}
  }

  @override
  void initState() {
    future = initialTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: currentChild,
    );
  }

  static Widget placeHolder() => Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );

  void hideTutorial() {
    if (mounted) setState(() => currentChild = ScaffoldHome());
  }
}
