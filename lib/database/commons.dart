import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonProvider = StateNotifierProvider<ColorProvider, ColorDetails>(
    (ref) => ColorProvider());

class ColorProvider extends StateNotifier<ColorDetails> {
  static final _initialColor = Colors.transparent;
  static final _initialText = 'Not Selected';
  static final _initial =
      ColorDetails(color: _initialColor, colorTitle: _initialText);

  ColorProvider()
      : assert(_initial != null),
        super(_initial);

  void changeColors({
    @required Color colorValue,
    @required String colorString,
  }) {
    colorValue = colorValue ?? _initialColor;

    // Color value will be something like Color(0xff...) so we're trimming here.
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

  const ColorDetails({@required this.colorTitle, @required this.color})
      : assert(colorTitle != null),
        assert(color != null);
}

final screenSize = StateProvider<ScreenSize>(
    (ref) => ScreenSize(2000, 1000)); // Initialize with some random values.

class ScreenSize {
  final int width;
  final int height;

  const ScreenSize(this.width, this.height)
      : assert(width != null),
        assert(height != null);
}
