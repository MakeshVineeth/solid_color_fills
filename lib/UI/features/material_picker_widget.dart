import 'package:flutter/material.dart';
import 'package:material_color_picker_wns/material_color_picker_wns.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solid_color_fills/database/commons.dart';

class MaterialPickerWidget extends ConsumerWidget {
  const MaterialPickerWidget({Key key}) : super(key: key);

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
