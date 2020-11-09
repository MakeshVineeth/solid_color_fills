import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ColorItem extends StatelessWidget {
  final MapEntry mapEntry;

  ColorItem({@required this.mapEntry});

  final BorderRadius fixedCardRadius = BorderRadius.circular(20.0);
  final colorTitleStyle = TextStyle(
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: fixedCardRadius),
      child: InkWell(
        borderRadius: fixedCardRadius,
        // temp
        onTap: () => Navigator.pushNamed(context, '/wall_chooser', arguments: {
          'title': mapEntry.key,
          'color': mapEntry.value,
        }),
        child: IgnorePointer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: mapEntry.value,
                    borderRadius: fixedCardRadius,
                  ),
                ),
              ),
              Text(
                mapEntry.key,
                style: colorTitleStyle,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
