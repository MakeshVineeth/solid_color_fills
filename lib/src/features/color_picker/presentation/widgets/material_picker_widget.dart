import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Pure-Flutter Material color picker with 19 primary tones and expandable shade selection.
/// Zero external package dependencies; matches the original MaterialPickerWidget behavior.
class MaterialPickerWidget extends StatefulWidget {
  final ValueChanged<Color> onColorChange;
  final ValueChanged<ColorSwatch<int>>? onMainColorChange;

  const MaterialPickerWidget({
    super.key,
    required this.onColorChange,
    this.onMainColorChange,
  });

  @override
  State<MaterialPickerWidget> createState() => _MaterialPickerWidgetState();
}

class _MaterialPickerWidgetState extends State<MaterialPickerWidget> {
  static const double _spacing = 9.0;

  static const List<ColorSwatch<int>> _materialSwatches = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  static const List<int> _shadeKeys = [
    50,
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900,
  ];

  late ColorSwatch<int> _mainColor;
  late Color _shadeColor;
  bool _isMainSelection = true;

  @override
  void initState() {
    super.initState();
    _mainColor = _materialSwatches[0];
    _shadeColor = _mainColor[500] ?? _mainColor;
  }

  List<Color> _shadesFor(ColorSwatch<int> swatch) {
    return [
      for (final key in _shadeKeys)
        if (swatch[key] != null) swatch[key]!,
    ];
  }

  void _onMainColorSelected(ColorSwatch<int> swatch) {
    final shades = _shadesFor(swatch);
    final nextShade = shades.contains(_shadeColor)
        ? _shadeColor
        : (swatch[500] ?? swatch[400] ?? swatch);

    setState(() {
      _mainColor = swatch;
      _shadeColor = nextShade;
      _isMainSelection = false;
    });
    widget.onMainColorChange?.call(swatch);
  }

  void _onShadeSelected(Color shade) {
    setState(() => _shadeColor = shade);
    widget.onColorChange(shade);
  }

  void _onBack() {
    setState(() => _isMainSelection = true);
  }

  List<Widget> _buildPrimaryGridItems() {
    return [
      for (final swatch in _materialSwatches)
        _ColorCircle(
          color: swatch,
          isSelected: _mainColor == swatch,
          onTap: () => _onMainColorSelected(swatch),
        ),
    ];
  }

  List<Widget> _buildShadeGridItems() {
    return [
      IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: _onBack,
        padding: const EdgeInsets.only(right: 2.0),
      ),
      for (final shade in _shadesFor(_mainColor))
        _ColorCircle(
          color: shade,
          isSelected: _shadeColor == shade,
          onTap: () => _onShadeSelected(shade),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.sizeOf(context).height;
    final circleSize = (deviceHeight <= 600) ? 50.0 : 60.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final rawColumns =
            (constraints.maxWidth - 32.0 + _spacing) ~/
            (circleSize + _spacing);
        final crossAxisCount = math.max(2, rawColumns);
        final items = _isMainSelection
            ? _buildPrimaryGridItems()
            : _buildShadeGridItems();

        return GridView.count(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          crossAxisSpacing: _spacing,
          mainAxisSpacing: _spacing,
          crossAxisCount: crossAxisCount,
          children: items,
        );
      },
    );
  }
}

class _ColorCircle extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorCircle({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final checkColor = isSelected
        ? (ThemeData.estimateBrightnessForColor(color) == Brightness.light
            ? Colors.black
            : Colors.white)
        : null;

    return Material(
      elevation: 4.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: color,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: checkColor == null
            ? null
            : Center(
                child: Icon(Icons.check, color: checkColor),
              ),
      ),
    );
  }
}
