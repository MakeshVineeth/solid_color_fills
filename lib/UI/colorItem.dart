import 'package:flutter/material.dart';

class ColorItem extends StatelessWidget {
  final MapEntry mapEntry;

  ColorItem({@required this.mapEntry});

  final BorderRadius fixedCardRadius = BorderRadius.circular(20.0);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: fixedCardRadius),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: mapEntry.value,
                borderRadius: fixedCardRadius,
              ),
            ),
          ),
          Text(
            mapEntry.key,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
