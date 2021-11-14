import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:solid_color_fills/UI/animations/fade_scale_widget.dart';
import 'package:solid_color_fills/database/commons.dart';
import 'package:solid_color_fills/fixedValues.dart';

class SimpleRGB extends ConsumerStatefulWidget {
  const SimpleRGB({Key key}) : super(key: key);

  @override
  _SimpleRGBState createState() => _SimpleRGBState();
}

class _SimpleRGBState extends ConsumerState<SimpleRGB> {
  final FixedValues fixedValues = FixedValues();
  Color _color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return FadeScale(
      child: AlertDialog(
        shape: fixedValues.roundShape,
        actionsPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: SlidePicker(
            pickerColor: _color,
            enableAlpha: false,
            paletteType: PaletteType.rgb,
            onColorChanged: (color) => _color = color,
            indicatorBorderRadius: fixedValues.fixedCardRadius,
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
