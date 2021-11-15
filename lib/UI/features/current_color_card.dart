import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:solid_color_fills/UI/animations/fade_scale_widget.dart';
import 'package:solid_color_fills/UI/animations/scaleBounce.dart';
import 'package:solid_color_fills/database/commons.dart';
import 'package:solid_color_fills/database/helperFunctions.dart';
import 'package:solid_color_fills/fixedValues.dart';

class CurrentColorCard extends ConsumerWidget {
  final double elevation = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final object = ref.watch(commonProvider);

    return Tooltip(
      message: 'Click to set wallpaper with this color.',
      child: Hero(
        tag: object.colorTitle.toLowerCase().replaceAll(' ', '_'),
        child: FadeScale(
          child: ScaleBounce(
            child: Card(
              elevation: elevation,
              shape: CircleBorder(),
              child: InkWell(
                borderRadius: FixedValues().fixedCardRadius,
                onTap: () => openWallChooser(
                  context: context,
                  ref: ref,
                  transition: const Duration(milliseconds: 400),
                ),
                child: IgnorePointer(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleColor(
                      circleSize: 50,
                      color: object.color,
                      elevation: elevation,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
