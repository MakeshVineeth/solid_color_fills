import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_animator/flutter_animator.dart';

class TabItemCustom {
  TabItem<dynamic> getTabItem(
      {@required String title, @required IconData icon}) {
    return TabItem(
      icon: icon,
      title: title,
      activeIcon: Bounce(
        key: UniqueKey(),
        child: Icon(icon),
      ),
    );
  }
}
