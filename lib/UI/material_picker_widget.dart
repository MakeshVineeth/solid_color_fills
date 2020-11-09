import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class MaterialPickerWidget extends StatefulWidget {
  final Function function;

  const MaterialPickerWidget({this.function});
  @override
  _MaterialPickerWidgetState createState() => _MaterialPickerWidgetState();
}

class _MaterialPickerWidgetState extends State<MaterialPickerWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialColorPicker(
      circleSize: 50,
      shrinkWrap: true,
      allowShades: true,
      onlyShadeSelection: true,
      physics: BouncingScrollPhysics(),
      onColorChange: (Color color) => widget.function(color),
    );
  }
}
