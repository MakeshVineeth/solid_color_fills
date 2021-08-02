import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_color_picker_wns/material_color_picker_wns.dart';
import 'package:solid_color_fills/fixedValues.dart';
import 'package:solid_color_fills/UI/database/commons.dart';
import 'package:solid_color_fills/UI/database/helperFunctions.dart';
import 'package:solid_color_fills/UI/styleMethods.dart';

class CurrentColorCard extends ConsumerWidget {
  final FixedValues fixedValues = FixedValues();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final object = ref.watch(commonProvider);

    return Card(
      child: InkWell(
        borderRadius: fixedValues.fixedCardRadius,
        onTap: () => openWallChooser(
          context: context,
          ref: ref,
          transition: const Duration(milliseconds: 300),
        ),
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
