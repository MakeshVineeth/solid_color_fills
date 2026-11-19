import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:solid_color_fills/src/core/constants/app_constants.dart';

/// Simple RGB slider dialog matching the original UI.
class SimpleRgbDialog extends StatefulWidget {
  final Color initialColor;

  const SimpleRgbDialog({
    super.key,
    required this.initialColor,
  });

  @override
  State<SimpleRgbDialog> createState() => _SimpleRgbDialogState();
}

class _SimpleRgbDialogState extends State<SimpleRgbDialog> {
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: AppConstants.roundShape,
      actionsPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: SlidePicker(
          pickerColor: _currentColor,
          enableAlpha: false,
          onColorChanged: (color) => _currentColor = color,
          indicatorBorderRadius: AppConstants.cardRadius,
        ),
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(
              Theme.of(context).textTheme.labelLarge?.color,
            ),
            shape: WidgetStateProperty.all(AppConstants.roundShape),
          ),
          onPressed: () => Navigator.of(context).pop(_currentColor),
          child: const Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'Select',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
