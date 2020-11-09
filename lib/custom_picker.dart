import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:com.mvp.solid_color_fill_walls/fixedValues.dart';

class CustomColorPicker extends StatefulWidget {
  @override
  _CustomColorPickerState createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  Color pickerColorAdv = Color(0xff443a49);
  Color currentColorAdv = Color(0xff443a49);
  Color selectedColor;
  final FixedValues fixedValues = FixedValues();

  void changeColor(Color color) {
    setState(() => pickerColorAdv = color);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          Container(
            padding: EdgeInsets.all(20),
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Material Colors with Shades',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialColorPicker(
                    shrinkWrap: true,
                    allowShades: true,
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    onColorChange: (Color color) {},
                    onMainColorChange: (Color color) => changeCurColor(color),
                    selectedColor: Colors.red),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () => showAdv(context),
                  child: Text('Advanced Color Picker'),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Selected:'),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: fixedValues.fixedCardRadius),
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: IgnorePointer(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: selectedColor,
                                  radius: 15,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(selectedColor != null
                                    ? selectedColor
                                        .toString()
                                        .split('0x')[1]
                                        .split(')')[0]
                                    : 'Not Selected'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void changeCurColor(Color color) {
    print(color);
  }

  void showAdv(BuildContext context) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: ColorPicker(
            pickerColor: pickerColorAdv,
            onColorChanged: changeColor,
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          FlatButton(
            child: const Text('Choose'),
            onPressed: () {
              setState(() {
                currentColorAdv = pickerColorAdv;
                selectedColor = pickerColorAdv;
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
