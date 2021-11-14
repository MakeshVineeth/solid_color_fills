import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solid_color_fills/UI/animations/showBlurDialog.dart';
import 'package:solid_color_fills/UI/features/material_picker_widget.dart';
import 'package:solid_color_fills/UI/features/current_color_card.dart';
import 'package:solid_color_fills/UI/features/advanced_color_picker.dart';
import 'package:solid_color_fills/UI/features/simple_rgb.dart';
import 'package:solid_color_fills/fixedValues.dart';

class CustomColorPicker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          Container(
            padding: EdgeInsets.all(20),
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select a Tone',
                  style: FixedValues.buttonText(),
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
                SizedBox(height: 8),
                Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () => showBlurDialog(
                          context: context,
                          child: SimpleRGB(),
                        ),
                        child: Text('Simple RGB'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => showBlurDialog(
                          context: context,
                          child: AdvancedColorPicker(),
                        ),
                        child: Text('Advanced Color Picker'),
                      ),
                      SizedBox(height: 15),
                      Center(
                        child: Text(
                          'Selected Color',
                          style: FixedValues.buttonText().copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      CurrentColorCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
