import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:solid_color_fills/UI/animations/scaleBounce.dart';
import 'package:solid_color_fills/UI/features/colorItem.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final Map<String, dynamic> colorsList = {};
  final double spacing = 10.0;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        bool isPortrait = orientation == Orientation.portrait;

        return GridView.builder(
          padding: EdgeInsets.all(15.0),
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          scrollDirection: Axis.vertical,
          addAutomaticKeepAlives: false,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isPortrait ? 2 : 3,
            childAspectRatio: isPortrait ? 0.70 : 1.2,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
          ),
          itemBuilder: (context, index) {
            if (index >= colorsList.length - 1) _generateColors();

            return (index >= colorsList.length)
                ? null
                : ScaleBounce(
                    child: ColorItem(
                      mapEntry: colorsList.entries.elementAt(index),
                    ),
                  );
          },
        );
      },
    );
  }

  void _generateColors() {
    RandomColor randomColor = RandomColor();
    List<Color> randomList = randomColor.randomColors(count: 10);

    if (randomList.isNotEmpty) {
      Map<String, dynamic> colorsMapped = {};

      for (Color colorItem in randomList) {
        String colorName = getColorNameFromColor(colorItem).getName;
        colorsMapped.addAll({colorName: colorItem});
      }

      if (colorsMapped.isNotEmpty) colorsList.addAll(colorsMapped);
    }
  }
}
