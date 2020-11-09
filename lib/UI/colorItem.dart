import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:com.mvp.solid_color_fill_walls/fixedValues.dart';
import 'package:com.mvp.solid_color_fill_walls/helperFunctions.dart';

class ColorItem extends StatelessWidget {
  final MapEntry mapEntry;

  ColorItem({@required this.mapEntry});
  final FixedValues fixedValues = FixedValues();
  final HelperFunctions helperFunctions = HelperFunctions();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: fixedValues.fixedCardRadius),
      child: InkWell(
        borderRadius: fixedValues.fixedCardRadius,
        // temp
        onTap: () => helperFunctions.openWallChooser(
          context: context,
          colorTitle: mapEntry.key,
          color: mapEntry.value,
        ),
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
}
