import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solid_color_fills/UI/animations/fade_scale_widget.dart';
import 'package:solid_color_fills/database/commons.dart';
import 'package:solid_color_fills/fixed_values.dart';

class SimpleRGB extends ConsumerStatefulWidget {
  const SimpleRGB({super.key});

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
            onColorChanged: (color) => _color = color,
            indicatorBorderRadius: fixedValues.fixedCardRadius,
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(
                  Theme.of(context).textTheme.labelLarge!.color),
              shape: WidgetStateProperty.all(fixedValues.roundShape),
            ),
            onPressed: () => onTapping(context),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: const Text(
                'Select',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
