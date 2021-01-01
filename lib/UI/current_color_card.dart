import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:solid_color_fill/fixedValues.dart';
import 'package:solid_color_fill/UI/database/commons.dart';
import 'package:solid_color_fill/UI/database/helperFunctions.dart';
import 'package:solid_color_fill/UI/styleMethods.dart';

class CurrentColorCard extends ConsumerWidget {
  final FixedValues fixedValues = FixedValues();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final object = watch(commonProvider.state);

    return Card(
      elevation:
          Theme.of(context).elevatedButtonTheme.style.elevation.resolve(null),
      shape: RoundedRectangleBorder(borderRadius: fixedValues.fixedCardRadius),
      child: InkWell(
        borderRadius: fixedValues.fixedCardRadius,
        onTap: () => openWallChooser(context),
        child: IgnorePointer(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Color:',
                  style: buttonText(),
                ),
                SizedBox(width: 10),
                CircleColor(
                  circleSize: 35,
                  color: object.color,
                  elevation: 2,
                ),
                SizedBox(width: 10),
                Text(
                  object.colorTitle,
                  style: buttonText(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
