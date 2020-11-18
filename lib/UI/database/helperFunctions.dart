import 'package:flutter/cupertino.dart';
import 'package:solid_color_fill/UI/database/commons.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter/material.dart';
import 'package:solid_color_fill/UI/wall_chooser.dart';

void openWallChooser(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  context.read(screenSize).state = ScreenSize(size.width, size.height);

  final color = context.read(commonProvider.state).color;
  if (color != null && color != Colors.transparent)
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WallChooser()));
}
