import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:solid_color_fills/UI/material_picker_widget.dart';
import 'package:solid_color_fills/UI/current_color_card.dart';
import 'package:solid_color_fills/UI/advanced_color_picker.dart';
import 'package:solid_color_fills/UI/styleMethods.dart';

class CustomColorPicker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
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
                SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    height: constraints.maxHeight / 1.5,
                    child: MaterialPickerWidget(),
                  ),
                ),
                SizedBox(height: 20),
                bottomWidget(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showAdv(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AdvancedColorPicker(),
      );

  Widget bottomWidget(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width / 1.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => showAdv(context),
              child: Text('Advanced Color Picker'),
            ),
            SizedBox(height: 10),
            CurrentColorCard(),
          ],
        ),
      );
}
