import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:solid_color_fills/fixedValues.dart';
import 'package:solid_color_fills/UI/database/commons.dart';
import 'package:solid_color_fills/UI/database/helperFunctions.dart';
import 'package:solid_color_fills/UI/styleMethods.dart';

class CurrentColorCard extends ConsumerWidget {
  final FixedValues fixedValues = FixedValues();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final object = watch(commonProvider);

    return Card(
      child: InkWell(
        borderRadius: fixedValues.fixedCardRadius,
        onTap: () => openWallChooser(context),
        child: IgnorePointer(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
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
