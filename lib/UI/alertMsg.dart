import 'package:flutter/material.dart';
import 'package:solid_color_fills/UI/fade_widget.dart';
import 'package:solid_color_fills/fixedValues.dart';

class AlertMsg extends StatelessWidget {
  final FixedValues fixedValues = FixedValues();
  final String title;
  final String message;

  AlertMsg({@required this.title, @required this.message})
      : assert(message != null),
        assert(title != null);

  @override
  Widget build(BuildContext context) {
    return FadeWidget(
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
        actions: [
          TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: fixedValues.fixedCardRadius,
                ),
              ),
              foregroundColor: MaterialStateProperty.all(
                  Theme.of(context).textTheme.button.color),
            ),
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
