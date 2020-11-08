import 'package:flutter/material.dart';
import 'package:solid_color_fill_walls/UI/colorItem.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // List of Colors
  Map colorsList = {
    'Amber': Colors.amber,
    'OP Red': Colors.red,
  };

  final columnCount = 2;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.builder(
        itemCount: colorsList.length,
        padding: EdgeInsets.all(15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemBuilder: (context, index) => AnimationConfiguration.staggeredGrid(
          columnCount: columnCount,
          position: index,
          duration: const Duration(milliseconds: 500),
          child: ScaleAnimation(
            child: FadeInAnimation(
              child: ColorItem(
                mapEntry: colorsList.entries.elementAt(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
