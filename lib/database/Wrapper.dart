import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solid_color_fills/bottom_navigation.dart';
import 'package:solid_color_fills/screens/intro_screen.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late Future<void> future;
  Widget currentChild = placeHolder();

  Future<void> initialTasks() async {
    try {
      if (Platform.isAndroid) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        int? sdkVer = androidInfo.version.sdkInt;

        if (sdkVer >= 23) await FlutterDisplayMode.setHighRefreshRate();
      }
    } catch (_) {}

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showTutorial = prefs.getBool('first_launch') ?? true;

    setState(() => currentChild =
        showTutorial ? IntroScreen(function: hideTutorial) : ScaffoldHome());
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
