import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:solid_color_fills/fixedValues.dart';
import 'package:solid_color_fills/database/commons.dart';
import 'package:solid_color_fills/database/helperFunctions.dart';

class CurrentColorCard extends ConsumerWidget {
  final FixedValues fixedValues = FixedValues();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final object = ref.watch(commonProvider);

    return Tooltip(
      message: 'Click to set wallpaper with this color.',
      child: Card(
        child: InkWell(
          borderRadius: fixedValues.fixedCardRadius,
          onTap: () => openWallChooser(
            context: context,
            ref: ref,
            transition: const Duration(milliseconds: 300),
          ),
          child: IgnorePointer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleColor(
                    circleSize: 35,
                    color: object.color,
                    elevation: 2,
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      object.colorTitle,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: FixedValues.buttonText(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
