import 'dart:io';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:solid_color_fills/database/app_shortcuts.dart';
import 'package:solid_color_fills/database/helperFunctions.dart';
import 'package:solid_color_fills/UI/dialogs/menuThings.dart';
import 'package:solid_color_fills/fixedValues.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:solid_color_fills/UI/tabItem.dart';
import 'package:solid_color_fills/UI/animations/fade_indexed_stack.dart';
import 'package:solid_color_fills/screens/color_pickers_screen.dart';
import 'package:solid_color_fills/UI/dialogs/floating_modal.dart';
import 'package:solid_color_fills/screens/collections.dart';
import 'package:solid_color_fills/screens/feed_screen.dart';

class ScaffoldHome extends StatefulWidget {
  @override
  _ScaffoldHomeState createState() => _ScaffoldHomeState();
}

class _ScaffoldHomeState extends State<ScaffoldHome> with RestorationMixin {
  final FixedValues fixedValues = FixedValues();
  final TabItemCustom tabItemCustom = TabItemCustom();
  final QuickActions quickActions = const QuickActions();
  final GlobalKey<ConvexAppBarState> _bottomAppBarKey =
      GlobalKey<ConvexAppBarState>();

  final Map<String, IconData> bottomItems = {
    'Collections': FluentIcons.collections_24_regular,
    'Color Picker': FluentIcons.color_24_regular,
    'Feed': Icons.all_inclusive_outlined
  };

  final widgetsList = <Widget>[
    HomeTab(),
    CustomColorPicker(),
    FeedScreen(),
  ];

  final RestorableInt _currentIndex = RestorableInt(0);

  @override
  void initState() {
    super.initState();
    initialTasks();
  }

  Future<void> initialTasks() async {
    _onItemTapped(await getTabIndex());
    quickShortcuts();
    askForReview();
  }

  void quickShortcuts() {
    if (Platform.isAndroid) {
      quickActions.initialize((shortcutType) {
        int index;

        if (shortcutType == AppShortcuts.collectionQuickAction.type)
          index = 0;
        else if (shortcutType == AppShortcuts.colorsQuickAction.type)
          index = 1;
        else if (shortcutType == AppShortcuts.feedQuickAction.type) index = 2;

        _onItemTapped(index);
      });

      quickActions.setShortcutItems(AppShortcuts.shortcutsList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FixedValues.changeNavBarColor(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(fixedValues.appTitle),
          actions: <Widget>[
            menuButton(),
          ],
        ),
        body: FadeIndexedStack(
          index: _currentIndex.value,
          children: widgetsList,
        ),
        bottomNavigationBar: ConvexAppBar(
          key: _bottomAppBarKey,
          backgroundColor: Theme.of(context).bottomAppBarTheme.color,
          color: Theme.of(context).primaryColor,
          curve: Curves.linear,
          activeColor: Theme.of(context).primaryColor,
          elevation: Theme.of(context).bottomAppBarTheme.elevation,
          height: (MediaQuery.of(context).orientation == Orientation.portrait)
              ? 60
              : 55,
          initialActiveIndex: _currentIndex.value,
          items: bottomItems.entries
              .map(
                (entry) => tabItemCustom.getTabItem(
                  title: entry.key,
                  icon: bottomItems[entry.key],
                ),
              )
              .toList(),
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget menuButton() => IconButton(
        onPressed: () => showFloatingModalBottomSheet(
          context: context,
          builder: (context) => MenuThings(),
        ),
        icon: Icon(
          FluentIcons.navigation_24_regular,
        ),
      );

  void _onItemTapped(int index) {
    if (mounted && index != null && index < widgetsList.length) {
      setState(() => _currentIndex.value = index);
      _bottomAppBarKey.currentState
          .animateTo(index); // ConvexAppBar doesn't navigate by itself.
      setTabIndex(index);
    }
  }

  @override
  String get restorationId => 'landing_page';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(_currentIndex, restorationId);
  }
}
