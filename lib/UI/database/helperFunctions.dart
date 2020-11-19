import 'package:flutter/cupertino.dart';
import 'package:solid_color_fill/UI/database/commons.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter/material.dart';
import 'package:solid_color_fill/UI/wall_chooser.dart';

void openWallChooser(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  ScreenSize newSize = ScreenSize(size.width.round(), size.height.round());
  final currentState = context.read(screenSize);

  if (currentState.state.width != newSize.width) currentState.state = newSize;

  final color = context.read(commonProvider.state).color;
  if (color != null && color != Colors.transparent)
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WallChooser()));
}
