import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solid_color_fills/fixedValues.dart';
import 'package:solid_color_fills/UI/database/commons.dart';
import 'package:solid_color_fills/UI/database/helperFunctions.dart';

class ColorItem extends StatelessWidget {
  final mapEntry;

  ColorItem({@required this.mapEntry});
  final FixedValues fixedValues = FixedValues();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => changeColor(context),
      child: IgnorePointer(
        child: Hero(
          tag: mapEntry.key.toString().toLowerCase().replaceAll(' ', '_'),
          child: Card(
            elevation: 3,
            shape: fixedValues.roundShape,
            child: GridTile(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 30),
                child: ClipRRect(
                  borderRadius: fixedValues.fixedCardRadius,
                  child: ColoredBox(color: returnColorItem()),
                ),
              ),
              footer: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    mapEntry.key,
                    style: fixedValues.colorTitleStyle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color returnColorItem() {
    if (mapEntry.value is String) {
      String hexCodeStr = mapEntry.value.toString().substring(1);
      String color = '0xFF$hexCodeStr';
      return Color(int.tryParse(color));
    } else
      return mapEntry.value;
  }

  void changeColor(BuildContext context) {
    context.read(commonProvider.notifier).changeColors(
          colorValue: returnColorItem(),
          colorString: mapEntry.key,
        );

    openWallChooser(context);
  }
}
