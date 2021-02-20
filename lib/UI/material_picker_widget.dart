import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solid_color_fills/UI/database/commons.dart';

class MaterialPickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return MaterialColorPicker(
      circleSize: (deviceHeight <= 600) ? 50 : 60,
      allowShades: true,
      onlyShadeSelection: true,
      physics: BouncingScrollPhysics(),
      onColorChange: (Color color) => context.read(commonProvider).changeColors(
            colorValue: color,
            colorString: color.toString(),
          ),
    );
  }
}
