import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:com.mvp.solid_color_fill_walls/fixedValues.dart';
import 'package:com.mvp.solid_color_fill_walls/UI/material_picker_widget.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:com.mvp.solid_color_fill_walls/helperFunctions.dart';

class CustomColorPicker extends StatefulWidget {
  @override
  _CustomColorPickerState createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  Color pickerColorAdv = Color(0xff443a49);
  Color currentColorAdv = Color(0xff443a49);
  Color selectedColor;
  final FixedValues fixedValues = FixedValues();
  final HelperFunctions helperFunctions = HelperFunctions();

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
                  'Please choose a Shade.',
                  style: buttonText(),
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialPickerWidget(
                  function: changeCurColor,
                ),
                SizedBox(
                  height: 10,
                ),
                bottomWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void changeCurColor(Color color) {
    setState(() {
      selectedColor = color;
    });
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

  TextStyle buttonText() {
    return TextStyle(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      fontSize: 15,
    );
  }

  String neatColorStr() {
    return selectedColor != null
        ? selectedColor.toString().split('0x')[1].split(')')[0]
        : 'Not Selected';
  }

  Widget bottomWidget() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () => showAdv(context),
            child: Text('Advanced Color Picker'),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: fixedValues.fixedCardRadius),
            child: InkWell(
              borderRadius: fixedValues.fixedCardRadius,
              onTap: () => helperFunctions.openWallChooser(
                context: context,
                color: selectedColor,
                colorTitle: neatColorStr(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: IgnorePointer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleColor(
                        circleSize: 35,
                        color: selectedColor ?? Colors.transparent,
                      ),
                      Text(
                        neatColorStr(),
                        style: buttonText(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
