import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solid_color_fills/UI/menuThings.dart';
import 'package:solid_color_fills/fixedValues.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:solid_color_fills/UI/tabItem.dart';
import 'package:solid_color_fills/UI/fade_indexed_stack.dart';
import 'package:solid_color_fills/custom_picker.dart';
import 'package:solid_color_fills/floating_modal.dart';
import 'package:solid_color_fills/home_tab.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class ScaffoldHome extends StatefulWidget {
  @override
  _ScaffoldHomeState createState() => _ScaffoldHomeState();
}

class _ScaffoldHomeState extends State<ScaffoldHome> {
  final FixedValues fixedValues = FixedValues();
  final TabItemCustom tabItemCustom = TabItemCustom();

  final bottomItems = {
    'Collections': FluentIcons.collections_24_regular,
    'Color Picker': FluentIcons.color_24_regular,
  };

  final widgetsList = [
    HomeTab(),
    CustomColorPicker(),
  ];

  _firstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool check = prefs.getBool('first_launch') ?? true;
    if (check) Navigator.pushNamed(context, '/intro');
  }

  @override
  void initState() {
    super.initState();
    _firstLaunch();
  }

  void changeStatusBarColor() =>
      FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    changeStatusBarColor();
    return Scaffold(
      appBar: AppBar(
        title: Text(fixedValues.appTitle),
        actions: [menuButton()],
      ),
      body: FadeIndexedStack(
        index: _currentIndex,
        children: widgetsList,
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Theme.of(context).bottomAppBarTheme.color,
        color: Theme.of(context).primaryColor,
        activeColor: Theme.of(context).primaryColor,
        elevation: Theme.of(context).bottomAppBarTheme.elevation,
        height: (MediaQuery.of(context).orientation == Orientation.portrait)
            ? 60
            : 50,
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

  Widget menuButton() => IconButton(
        onPressed: () => showFloatingModalBottomSheet(
          context: context,
          builder: (context) => MenuThings(),
        ),
        icon: Icon(FluentIcons.navigation_24_regular),
      );
}
