import 'package:flutter/material.dart';
import 'package:solid_color_fills/UI/fade_widget.dart';
import 'package:solid_color_fills/fixedValues.dart';

class AlertMsg extends StatelessWidget {
  final FixedValues fixedValues = FixedValues();
  final String title;
  final String msg;

  AlertMsg({@required this.title, @required this.msg});

  @override
  Widget build(BuildContext context) {
    return FadeWidget(
      child: AlertDialog(
        shape: fixedValues.roundShape,
        buttonPadding: EdgeInsets.all(15),
        title: Text(title),
        content: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Text(
            msg,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: fixedValues.fixedCardRadius),
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
