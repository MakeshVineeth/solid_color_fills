import 'package:flutter/material.dart';
import 'package:com.mvp.solid_color_fill_walls/UI/colorItem.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // List of Colors
  Map colorsList = {
    'Amber': Colors.amber,
    'OnePlus Red': Color(0xffeb0029),
    'Yellow': Colors.yellow,
    'Red': Colors.red,
    'Green': Colors.green,
    'Black': Colors.black,
    'Blue': Colors.blue,
    'Neumorphic White': Color(0xffe0e5ec),
    'Neumorphic Black': Color(0xff26282B),
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
          childAspectRatio: 0.7,
        ),
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemBuilder: (context, index) => AnimationConfiguration.staggeredGrid(
          columnCount: columnCount,
          position: index,
          duration: const Duration(milliseconds: 800),
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
