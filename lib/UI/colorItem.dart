import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:solid_color_fill/fixedValues.dart';
import 'package:solid_color_fill/UI/database/commons.dart';
import 'package:solid_color_fill/UI/database/helperFunctions.dart';

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
        onTap: () => changeColor(context),
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

  void changeColor(BuildContext context) {
    context.read(commonProvider).changeColors(
          colorValue: mapEntry.value,
          colorString: mapEntry.key,
        );
    openWallChooser(context);
  }
}
