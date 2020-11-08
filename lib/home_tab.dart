import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Map colorsList = {
    'Amber': Colors.amber,
    'OP Red': Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(10.0),
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      children: colorsList.entries.map((entry) => Container(color: entry.value,)).toList(),
    );
  }
}
