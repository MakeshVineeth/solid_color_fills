import 'package:flutter/material.dart';

class MenuThings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: FlatButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              onPressed: () {},
              icon: Icon(
                Icons.info_outline,
              ),
              label: Text(
                'About This App',
              )),
        ),
      ],
    );
  }
}
