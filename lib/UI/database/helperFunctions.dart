import 'package:flutter/cupertino.dart';
import 'package:solid_color_fills/UI/database/commons.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter/material.dart';
import 'package:solid_color_fills/UI/wall_chooser.dart';
import 'dart:ui';

void openWallChooser(BuildContext context) {
  Size size = window.physicalSize;

  if (size != Size.zero) {
    final ScreenSize newSize =
        ScreenSize(size.width.ceil(), size.height.ceil());
    final currentState = context.read(screenSize);

    if (currentState.state.width != newSize.width) currentState.state = newSize;
  }

  final color = context.read(commonProvider.state).color;
  if (color != null && color != Colors.transparent)
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WallChooser()));
}
