import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solid_color_fills/src/core/widgets/scale_bounce.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/controllers/color_picker_controller.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/controllers/wallpaper_controller.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/screens/wallpaper_confirmation_screen.dart';

/// Floating circular active color button faithful to the original CurrentColorCard.
/// Shows a 50px circle swatch with elevation 5, ScaleBounce animation, and Hero transition.
class CurrentColorCard extends StatelessWidget {
  const CurrentColorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorPickerController>(
      builder: (context, controller, child) {
        final color = controller.color;
        final heroTag = 'picker_color_hero_${color.toARGB32()}';

        return Tooltip(
          message: 'Click to set wallpaper with this color.',
          child: ScaleBounce(
            child: Card(
              elevation: 5.0,
              shape: const CircleBorder(),
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  context.read<WallpaperController>().setColor(
                        color: color,
                        title: controller.colorTitle,
                      );
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => WallpaperConfirmationScreen(
                        heroTag: heroTag,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                    tag: heroTag,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
