import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solid_color_fills/database/commons.dart';

class MaterialPickerWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double deviceHeight = MediaQuery.of(context).size.height;

    return MaterialColorPicker(
      circleSize: (deviceHeight <= 600) ? 50 : 60,
      allowShades: true,
      onlyShadeSelection: true,
      physics: BouncingScrollPhysics(),
      onColorChange: (Color color) =>
          ref.read(commonProvider.notifier).changeColors(
                colorValue: color,
                colorString: color.toString(),
              ),
    );
  }
}
