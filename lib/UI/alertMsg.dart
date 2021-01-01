import 'package:flutter/material.dart';
import 'package:solid_color_fill/UI/fade_widget.dart';
import 'package:solid_color_fill/fixedValues.dart';

class AlertMsg extends StatelessWidget {
  final FixedValues fixedValues = FixedValues();
  final title;
  final msg;

  AlertMsg({@required this.title, @required this.msg});

  @override
  Widget build(BuildContext context) {
    return FadeWidget(
      child: AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: fixedValues.fixedCardRadius),
        buttonPadding: EdgeInsets.all(15),
        title: title,
        content: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Text(msg),
        ),
        actions: [
          FlatButton(
            child: const Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}