import 'package:flutter/material.dart';
import 'package:com.mvp.solid_color_fill_walls/fixedValues.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:com.mvp.solid_color_fill_walls/UI/tabItem.dart';
import 'package:com.mvp.solid_color_fill_walls/UI/fade_indexed_stack.dart';
import 'package:com.mvp.solid_color_fill_walls/custom_picker.dart';
import 'package:com.mvp.solid_color_fill_walls/home_tab.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class ScaffoldHome extends StatefulWidget {
  @override
  _ScaffoldHomeState createState() => _ScaffoldHomeState();
}

class _ScaffoldHomeState extends State<ScaffoldHome> {
  final FixedValues fixedValues = FixedValues();
  final TabItemCustom tabItemCustom = TabItemCustom();

  final bottomItems = {
    'Home': Icons.home_rounded,
    'Color Picker': Icons.colorize_rounded,
  };

  final widgetsList = [
    HomeTab(),
    CustomColorPicker(),
  ];

  void changeStatusBarColor() {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    changeStatusBarColor();
    return Scaffold(
      appBar: AppBar(
        title: Text(fixedValues.appTitle),
      ),
      body: FadeIndexedStack(
        index: _currentIndex,
        children: widgetsList,
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        color: Theme.of(context).bottomAppBarTheme.color,
        activeColor: Theme.of(context).bottomAppBarTheme.color,
        elevation: Theme.of(context).bottomAppBarTheme.elevation,
        height: 60,
        initialActiveIndex: _currentIndex,
        items: bottomItems.entries
            .map((entry) => tabItemCustom.getTabItem(
                  title: entry.key,
                  icon: bottomItems[entry.key],
                ))
            .toList(),
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
