import 'dart:ui';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solid_color_fills/UI/database/commons.dart';
import 'package:solid_color_fills/UI/fade_widget.dart';
import 'package:solid_color_fills/fixedValues.dart';

class AdvancedColorPicker extends StatefulWidget {
  @override
  _AdvancedColorPickerState createState() => _AdvancedColorPickerState();
}

class _AdvancedColorPickerState extends State<AdvancedColorPicker> {
  final FixedValues fixedValues = FixedValues();
  Color _color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return FadeWidget(
      child: AlertDialog(
        shape: fixedValues.roundShape,
        buttonPadding: EdgeInsets.all(15),
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: ColorPicker(
            pickerColor: _color,
            onColorChanged: (color) => _color = color,
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Choose'),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).textTheme.button.color)),
            onPressed: () => onTapping(context),
          ),
        ],
      ),
    );
  }

  void onTapping(BuildContext context) {
    context.read(commonProvider).changeColors(
          colorValue: _color,
          colorString: _color.toString(),
        );
    Navigator.of(context).pop();
  }
}
