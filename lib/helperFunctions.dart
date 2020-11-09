import 'package:flutter/material.dart';
import 'package:com.mvp.solid_color_fill_walls/UI/wall_chooser.dart';

class HelperFunctions {
  void openWallChooser({BuildContext context, Color color, String colorTitle}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WallChooser(
                  color: color,
                  colorTitle: colorTitle,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                )));
  }
}
