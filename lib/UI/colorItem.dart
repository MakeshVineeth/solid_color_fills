import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:solid_color_fill_walls/UI/wall_chooser.dart';

class ColorItem extends StatelessWidget {
  final MapEntry mapEntry;

  ColorItem({@required this.mapEntry});

  final BorderRadius fixedCardRadius = BorderRadius.circular(20.0);
  final colorTitleStyle = TextStyle(
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: fixedCardRadius),
      child: InkWell(
        borderRadius: fixedCardRadius,
        // temp
        onTap: () => openWallChooser(context),
        child: IgnorePointer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: mapEntry.value,
                    borderRadius: fixedCardRadius,
                  ),
                ),
              ),
              Text(
                mapEntry.key,
                style: colorTitleStyle,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openWallChooser(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WallChooser(
                  mapEntry: mapEntry,
                  size: MediaQuery.of(context).size,
                )));
  }
}
