import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:solid_color_fills/UI/colorItem.dart';
import 'package:solid_color_fills/UI/scaleThis.dart';

class InfiniteScreen extends StatefulWidget {
  const InfiniteScreen({Key key}) : super(key: key);

  @override
  _InfiniteScreenState createState() => _InfiniteScreenState();
}

class _InfiniteScreenState extends State<InfiniteScreen> {
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
                : ScaleThis(
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
    RandomColor _randomColor = RandomColor();
    List<Color> _randomList = _randomColor.randomColors(count: 10);

    if (_randomList != null && _randomList.isNotEmpty) {
      Map<String, dynamic> colorsMapped = {};

      for (Color colorItem in _randomList) {
        String colorName = getColorNameFromColor(colorItem).getName;

        if (colorName != null) colorsMapped.addAll({colorName: colorItem});
      }

      if (colorsMapped.isNotEmpty) colorsList.addAll(colorsMapped);
    }
  }
}
