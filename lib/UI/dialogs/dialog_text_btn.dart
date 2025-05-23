import 'package:flutter/material.dart';
import 'package:solid_color_fills/fixed_values.dart';

class DialogTextBtn extends StatelessWidget {
  final Function function;
  final String title;
  final FixedValues _fixedValues = FixedValues();

  DialogTextBtn({super.key, required this.function, required this.title});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(_fixedValues.roundShape),
      ),
      onPressed: () => function(),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          title,
          textAlign: TextAlign.end,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
