import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solid_color_fills/database/commons.dart';
import 'package:solid_color_fills/database/helperFunctions.dart';
import 'package:solid_color_fills/fixedValues.dart';

class ColorItem extends ConsumerWidget {
  final MapEntry<String, dynamic> mapEntry;

  ColorItem({required this.mapEntry});

  final FixedValues fixedValues = FixedValues();
  final Random random = Random();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String coStr = mapEntry.key.toLowerCase().replaceAll(' ', '_');
    final heroTag =
        coStr + coStr.hashCode.toString() + random.nextInt(999999).toString();

    return Hero(
      tag: heroTag,
      child: Card(
        elevation: 3,
        shape: fixedValues.roundShape,
        child: InkWell(
          onTap: () => changeColor(context, ref, heroTag),
          borderRadius: fixedValues.fixedCardRadius,
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
    );
  }

  Color returnColorItem() {
    if (mapEntry.value is String) {
      String hexCodeStr = mapEntry.value.toString().substring(1);
      String color = '0xFF$hexCodeStr';
      return Color(int.tryParse(color)!);
    } else
      return mapEntry.value;
  }

  void changeColor(BuildContext context, WidgetRef ref, String heroTag) {
    ref.read(commonProvider.notifier).changeColors(
          colorValue: returnColorItem(),
          colorString: mapEntry.key,
        );

    openWallChooser(context: context, ref: ref, heroTag: heroTag);
  }
}
