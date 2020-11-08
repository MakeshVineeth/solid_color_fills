import 'package:flutter/material.dart';
import 'package:solid_color_fill_walls/fixedValues.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:solid_color_fill_walls/UI/tabItem.dart';
import 'package:solid_color_fill_walls/UI/fade_indexed_stack.dart';
import 'package:solid_color_fill_walls/custom_picker.dart';
import 'package:solid_color_fill_walls/home_tab.dart';

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

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(fixedValues.appTitle),
      ),
      body: FadeIndexedStack(
        index: _currentIndex,
        children: widgetsList,
      ),
      bottomNavigationBar: ConvexAppBar(
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
