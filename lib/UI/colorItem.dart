import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:solid_color_fill_walls/UI/wall_chooser.dart';
import 'package:solid_color_fill_walls/fixedValues.dart';

class ColorItem extends StatelessWidget {
  final MapEntry mapEntry;

  ColorItem({@required this.mapEntry});
  final FixedValues fixedValues = FixedValues();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: fixedValues.fixedCardRadius),
      child: InkWell(
        borderRadius: fixedValues.fixedCardRadius,
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
                    borderRadius: fixedValues.fixedCardRadius,
                  ),
                ),
              ),
              Text(
                mapEntry.key,
                style: fixedValues.colorTitleStyle,
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
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                )));
  }
}
