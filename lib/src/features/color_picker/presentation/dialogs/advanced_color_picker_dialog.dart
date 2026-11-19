import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:solid_color_fills/src/core/constants/app_constants.dart';

/// Advanced color picker dialog matching original UI layout and Play Store screenshots.
class AdvancedColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  const AdvancedColorPickerDialog({
    super.key,
    required this.initialColor,
  });

  @override
  State<AdvancedColorPickerDialog> createState() =>
      _AdvancedColorPickerDialogState();
}

class _AdvancedColorPickerDialogState extends State<AdvancedColorPickerDialog> {
  final TextEditingController _textEditingController = TextEditingController();
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _copyHex() {
    final colorCode = _textEditingController.text;
    if (colorCode.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: colorCode));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: AppConstants.roundShape,
      actionsPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      title: const Text('Pick a color'),
      content: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ColorPicker(
                pickerColor: _currentColor,
                enableAlpha: false,
                hexInputController: _textEditingController,
                onColorChanged: (color) => _currentColor = color,
                displayThumbColor: true,
                pickerAreaHeightPercent: 0.8,
                pickerAreaBorderRadius: AppConstants.cardRadius,
                portraitOnly: MediaQuery.of(context).size.width < 720,
              ),
              const SizedBox(height: 5),
              TextField(
                decoration: InputDecoration(
                  counterText: '',
                  prefixIcon: const Icon(Icons.tag_rounded),
                  suffixIcon: IconButton(
                    onPressed: _copyHex,
                    icon: const Icon(Icons.content_paste_outlined),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: AppConstants.cardRadius,
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]')),
                ],
                scrollPhysics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                controller: _textEditingController,
                textCapitalization: TextCapitalization.characters,
                maxLength: 6,
              ),
            ],
          ),
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
