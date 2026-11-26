import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solid_color_fills/src/core/widgets/animated_dialog.dart';
import 'package:solid_color_fills/src/core/widgets/responsive_wrapper.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/controllers/color_picker_controller.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/dialogs/advanced_color_picker_dialog.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/dialogs/simple_rgb_dialog.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/widgets/current_color_card.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/widgets/material_picker_widget.dart';

/// Screen offering Material tone selection, Simple RGB dialog, and Advanced Color Picker dialog.
/// 100% faithful to the original layout: Stack with floating CurrentColorCard at bottom-right.
class ColorPickerScreen extends StatelessWidget {
  const ColorPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      maxWidth: 720,
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  constraints:
                      BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Select a Tone',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: SizedBox(
                          height: constraints.maxHeight / 1.5,
                          child: MaterialPickerWidget(
                            key: const ValueKey(1),
                            onColorChange: (c) => context
                                .read<ColorPickerController>()
                                .setColor(c, title: 'Custom Color'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: constraints.maxWidth > 500
                            ? 320
                            : MediaQuery.sizeOf(context).width / 1.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final controller =
                                    context.read<ColorPickerController>();
                                final picked =
                                    await showAnimatedDialog<Color>(
                                  context: context,
                                  builder: (_) => SimpleRgbDialog(
                                    initialColor: controller.color,
                                  ),
                                );
                                if (picked != null) {
                                  controller.setColor(
                                    picked,
                                    title: 'Custom Color',
                                  );
                                }
                              },
                              child: const Text('Simple RGB'),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () async {
                                final controller =
                                    context.read<ColorPickerController>();
                                final picked =
                                    await showAnimatedDialog<Color>(
                                  context: context,
                                  builder: (_) => AdvancedColorPickerDialog(
                                    initialColor: controller.color,
                                  ),
                                );
                                if (picked != null) {
                                  controller.setColor(
                                    picked,
                                    title: 'Custom Color',
                                  );
                                }
                              },
                              child: const Text('Advanced Color Picker'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Floating circular current-color FAB at bottom-right
            Selector<ColorPickerController, bool>(
              selector: (_, controller) => controller.isColorSelected,
              builder: (context, isSelected, child) {
                if (!isSelected) {
                  return const SizedBox.shrink();
                }
                return const Positioned(
                  right: 10,
                  bottom: 10,
                  child: CurrentColorCard(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
