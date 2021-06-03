import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solid_color_fills/UI/menuThings.dart';
import 'package:solid_color_fills/fixedValues.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:solid_color_fills/UI/tabItem.dart';
import 'package:solid_color_fills/UI/fade_indexed_stack.dart';
import 'package:solid_color_fills/custom_picker.dart';
import 'package:solid_color_fills/floating_modal.dart';
import 'package:solid_color_fills/home_tab.dart';

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
    if (check) await Navigator.pushNamed(context, '/intro');
  }

  @override
  void initState() {
    _firstLaunch();
    super.initState();
  }

  SystemUiOverlayStyle changeStatusBarColor() {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;

    SystemUiOverlayStyle light = SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    );

    SystemUiOverlayStyle dark = SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: FixedValues.bottomNavBg,
      systemNavigationBarIconBrightness: Brightness.light,
    );

    return isLightTheme ? light : dark;
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: changeStatusBarColor(),
      child: Scaffold(
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
          curve: Curves.linear,
          activeColor: Theme.of(context).primaryColor,
          elevation: Theme.of(context).bottomAppBarTheme.elevation,
          height: (MediaQuery.of(context).orientation == Orientation.portrait)
              ? 60
              : 55,
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
