import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:solid_color_fills/fixedValues.dart';
import 'package:solid_color_fills/UI/database/commons.dart';
import 'package:solid_color_fills/UI/database/helperFunctions.dart';

class ColorItem extends StatelessWidget {
  final MapEntry mapEntry;

  ColorItem({@required this.mapEntry});
  final FixedValues fixedValues = FixedValues();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => changeColor(context),
      child: IgnorePointer(
        child: Card(
          elevation: 3,
          shape: fixedValues.roundShape,
          child: GridTile(
            child: Container(
              margin: const EdgeInsets.fromLTRB(6, 6, 6, 20),
              decoration: BoxDecoration(
                color: mapEntry.value,
                borderRadius: fixedValues.fixedCardRadius,
              ),
            ),
            footer: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Text(
                  mapEntry.key,
                  style: fixedValues.colorTitleStyle,
                ),
              ),
            ),
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
