import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:solid_color_fills/UI/colorItem.dart';

class InfiniteScreen extends StatefulWidget {
  const InfiniteScreen({Key key}) : super(key: key);

  @override
  _InfiniteScreenState createState() => _InfiniteScreenState();
}

class _InfiniteScreenState extends State<InfiniteScreen> {
  final Map<String, dynamic> colorsList = {};
  final double spacing = 10.0;

  @override
  void initState() {
    super.initState();
    _generateColors();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        bool isPortrait = orientation == Orientation.portrait;

        return GridView.builder(
          padding: EdgeInsets.all(15.0),
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          cacheExtent: 2000,
          scrollDirection: Axis.vertical,
          addAutomaticKeepAlives: false,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isPortrait ? 2 : 3,
            childAspectRatio: isPortrait ? 0.70 : 1.2,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
          ),
          itemBuilder: (context, index) {
            if (index >= colorsList.length) _generateColors();

            return ColorItem(mapEntry: colorsList.entries.elementAt(index));
          },
        );
      },
    );
  }

  void _generateColors() {
    RandomColor _randomColor = RandomColor();
    List<Color> _color = _randomColor.randomColors(count: 10);
    Map<String, dynamic> colors = {};

    for (var colorItem in _color) {
      String colorName = getColorNameFromColor(colorItem).getName;
      colors.addAll({colorName: colorItem});
    }

    colorsList.addAll(colors);
  }
}
