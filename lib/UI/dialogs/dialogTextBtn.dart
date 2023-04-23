import 'package:flutter/material.dart';
import 'package:solid_color_fills/fixedValues.dart';

class DialogTextBtn extends StatelessWidget {
  final Function function;
  final String title;
  final FixedValues _fixedValues = FixedValues();

  DialogTextBtn({required this.function, required this.title});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(_fixedValues.roundShape),
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
