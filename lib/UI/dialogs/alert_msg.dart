import 'package:flutter/material.dart';
import 'package:solid_color_fills/UI/animations/fade_scale_widget.dart';
import 'package:solid_color_fills/fixed_values.dart';

class AlertMsg extends StatelessWidget {
  final FixedValues fixedValues = FixedValues();
  final String title;
  final String message;

  AlertMsg({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return FadeScale(
      child: AlertDialog(
        shape: fixedValues.roundShape,
        buttonPadding: EdgeInsets.all(15),
        title: Text(title),
        content: SingleChildScrollView(
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: Text(
            message,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: fixedValues.fixedCardRadius,
                ),
              ),
              foregroundColor: WidgetStateProperty.all(
                  Theme.of(context).textTheme.labelLarge!.color),
            ),
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
