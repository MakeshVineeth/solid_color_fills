import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solid_color_fills/UI/animations/fade_scale_widget.dart';
import 'package:solid_color_fills/database/commons.dart';
import 'package:solid_color_fills/fixedValues.dart';

class AdvancedColorPicker extends ConsumerStatefulWidget {
  @override
  _AdvancedColorPickerState createState() => _AdvancedColorPickerState();
}

class _AdvancedColorPickerState extends ConsumerState<AdvancedColorPicker> {
  final FixedValues fixedValues = FixedValues();
  final TextEditingController _textEditingController = TextEditingController();
  Color _color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return FadeScale(
      child: AlertDialog(
        shape: fixedValues.roundShape,
        actionsPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        title: const Text(
          'Pick a color',
        ),
        content: SingleChildScrollView(
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Column(
              children: [
                ColorPicker(
                  pickerColor: _color,
                  enableAlpha: false,
                  hexInputController: _textEditingController,
                  onColorChanged: (color) => _color = color,
                  displayThumbColor: true,
                  pickerAreaHeightPercent: 0.8,
                  pickerAreaBorderRadius: fixedValues.fixedCardRadius,
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    counterText: "",
                    prefixIcon: Icon(Icons.tag_rounded),
                    suffixIcon: IconButton(
                      onPressed: () {
                        String colorCode = _textEditingController.text;
                        if (colorCode.isNotEmpty)
                          Clipboard.setData(ClipboardData(text: colorCode));
                      },
                      icon: Icon(
                        Icons.content_paste_outlined,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: fixedValues.fixedCardRadius,
                    ),
                  ),
                  scrollPhysics: AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
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
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: const Text(
                'Select',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(
                  Theme.of(context).textTheme.labelLarge!.color),
              shape: WidgetStateProperty.all(fixedValues.roundShape),
            ),
            onPressed: () => onTapping(context),
          ),
        ],
      ),
    );
  }

  void onTapping(BuildContext context) {
    ref.read(commonProvider.notifier).changeColors(
          colorValue: _color,
          colorString: _color.toString(),
        );

    Navigator.of(context).pop();
  }
}
