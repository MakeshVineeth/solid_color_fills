import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_animator/flutter_animator.dart';

class TabItemCustom {
  // get Tab Item for NavBar
  TabItem<dynamic> getTabItem({
    @required String title,
    @required IconData icon,
  }) =>
      TabItem(
        icon: icon,
        title: title,
        activeIcon: Bounce(
          key: UniqueKey(),
          child: Icon(icon),
        ),
      );
}
