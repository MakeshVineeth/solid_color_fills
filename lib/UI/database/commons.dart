import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonProvider = StateNotifierProvider<ColorProvider>((ref) {
  return ColorProvider();
});

class ColorProvider extends StateNotifier<ColorDetails> {
  static final _initialColor = Colors.transparent;
  static final _initialText = 'Not Selected';
  static final _initial =
      ColorDetails(color: _initialColor, colorTitle: _initialText);

  ColorProvider() : super(_initial);

  void changeColors(
      {@required Color colorValue, @required String colorString}) {
    colorValue = colorValue ?? _initialColor;

    if (colorString != null)
      colorString = colorString.split('0x').length == 2
          ? convertColorStr(colorString)
          : colorString;
    else
      colorString = _initialText;

    state = ColorDetails(color: colorValue, colorTitle: colorString);
  }

  String convertColorStr(String title) => title.split('0x')[1].split(')')[0];
}

class ColorDetails {
  final String colorTitle;
  final Color color;

  ColorDetails({@required this.colorTitle, @required this.color});
}

final screenSize = StateProvider<ScreenSize>((ref) {
  return ScreenSize(2000, 1000);
});

class ScreenSize {
  int width;
  int height;

  ScreenSize(this.width, this.height);
}
