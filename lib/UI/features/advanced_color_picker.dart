import 'dart:ui';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solid_color_fills/UI/animations/fade_scale_widget.dart';
import 'package:solid_color_fills/database/commons.dart';
import 'package:solid_color_fills/fixedValues.dart';

class AdvancedColorPicker extends ConsumerStatefulWidget {
  @override
  _AdvancedColorPickerState createState() => _AdvancedColorPickerState();
}

class _AdvancedColorPickerState extends ConsumerState<AdvancedColorPicker> {
  final FixedValues fixedValues = FixedValues();
  Color _color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return FadeScale(
      child: AlertDialog(
        shape: fixedValues.roundShape,
        actionsPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        title: const Text(
          'Pick a color',
        ),
        content: SingleChildScrollView(
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: ColorPicker(
              pickerColor: _color,
              enableAlpha: false,
              onColorChanged: (color) => _color = color,
              pickerAreaBorderRadius: fixedValues.fixedCardRadius,
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: const Text(
                'Select',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                  Theme.of(context).textTheme.button.color),
              shape: MaterialStateProperty.all(fixedValues.roundShape),
            ),
            onPressed: () => onTapping(context),
          ),
        ],
      ),
    );
  }

  void onTapping(BuildContext context) {
    ref.read(commonProvider.notifier).changeColors(
          colorValue: _color,
          colorString: _color.toString(),
        );

    Navigator.of(context).pop();
  }
}
