import 'package:flutter/material.dart';
import 'package:solid_color_fill/UI/colorItem.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:solid_color_fill/fixedValues.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final columnCount = 2;
  final FixedValues fixedValues = FixedValues();
  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.builder(
        itemCount: fixedValues.colorsList.length,
        padding: EdgeInsets.all(15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: fixedValues.heightCard,
        ),
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemBuilder: (context, index) => AnimationConfiguration.staggeredGrid(
          columnCount: columnCount,
          position: index,
          duration: const Duration(milliseconds: 800),
          child: ScaleAnimation(
            child: FadeInAnimation(
              child: ColorItem(
                mapEntry: fixedValues.colorsList.entries.elementAt(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
