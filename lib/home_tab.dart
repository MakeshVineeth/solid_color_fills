import 'package:flutter/material.dart';
import 'package:solid_color_fills/UI/colorItem.dart';
import 'package:solid_color_fills/UI/scaleThis.dart';
import 'package:solid_color_fills/fixedValues.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final columnCount = 2;
  final FixedValues fixedValues = FixedValues();
  double spacing = 10.0;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.all(15),
      crossAxisCount: columnCount,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      childAspectRatio: fixedValues.heightCard,
      addAutomaticKeepAlives: true,
      addRepaintBoundaries: true,
      cacheExtent: 5000,
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      children: List.generate(
        fixedValues.colorsList.length,
        (index) => ScaleThis(
          child: ColorItem(
            mapEntry: fixedValues.colorsList.entries.elementAt(index),
          ),
        ),
      ),
    );
  }
}
