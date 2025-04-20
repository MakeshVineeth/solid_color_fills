import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solid_color_fills/UI/animations/show_blur_dialog.dart';
import 'package:solid_color_fills/UI/features/material_picker_widget.dart';
import 'package:solid_color_fills/UI/features/current_color_card.dart';
import 'package:solid_color_fills/UI/features/advanced_color_picker.dart';
import 'package:solid_color_fills/UI/features/simple_rgb.dart';
import 'package:solid_color_fills/fixed_values.dart';
import 'package:solid_color_fills/database/commons.dart';

class CustomColorPicker extends ConsumerWidget {
  const CustomColorPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: <Widget>[
          ListView(
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            children: [
              Container(
                padding: EdgeInsets.all(20),
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Select a Tone',
                      style: FixedValues.buttonText(),
                    ),
                    SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: SizedBox(
                        height: constraints.maxHeight / 1.5,
                        child: MaterialPickerWidget(
                          key: ValueKey(1),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Consumer(
            builder: (context, ref, child) {
              Color color = ref.watch(commonProvider).color;

              if (color != Colors.transparent) {
                return Positioned(
                  right: 10,
                  bottom: 10,
                  child: CurrentColorCard(),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
