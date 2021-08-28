import 'package:flutter/material.dart';
import 'package:solid_color_fills/UI/animations/fade_scale_widget.dart';
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
