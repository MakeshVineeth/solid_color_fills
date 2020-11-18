import 'dart:ui';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:solid_color_fill/UI/database/commons.dart';
import 'package:solid_color_fill/fixedValues.dart';

class AdvancedColorPicker extends StatelessWidget {
  final blurRad = 15.0;
  final FixedValues fixedValues = FixedValues();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blurRad, sigmaY: blurRad),
      child: AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: fixedValues.fixedCardRadius),
        buttonPadding: EdgeInsets.all(15),
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: ColorPicker(
            pickerColor: Colors.blue,
            onColorChanged: (color) {
              context.read(commonProvider).changeColors(
                    colorValue: color,
                    colorString: color.toString(),
                  );
            },
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          FlatButton(
            child: const Text('Choose'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
