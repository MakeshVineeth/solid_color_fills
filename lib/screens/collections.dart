import 'package:flutter/material.dart';
import 'package:solid_color_fills/UI/features/colorItem.dart';
import 'package:solid_color_fills/UI/animations/scaleBounce.dart';
import 'package:solid_color_fills/fixedValues.dart';

class HomeTab extends StatelessWidget {
  final FixedValues fixedValues = FixedValues();
  final double spacing = 10.0;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) => CustomScrollView(
        primary: false,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(15),
            sliver: SliverGrid.count(
              crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
              childAspectRatio:
                  (orientation == Orientation.portrait) ? 0.70 : 1.2,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              children: List.generate(
                fixedValues.colorsList.length,
                (index) => ScaleBounce(
                  child: ColorItem(
                    mapEntry: fixedValues.colorsList.entries.elementAt(index),
                  ),
                ),
              ),
            ),
          ),
        ],
        scrollDirection: Axis.vertical,
        semanticChildCount: fixedValues.colorsList.length,
        cacheExtent: 5500,
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      ),
    );
  }
}
