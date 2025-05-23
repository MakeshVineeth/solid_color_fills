import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solid_color_fills/UI/animations/fade_scale_widget.dart';
import 'package:solid_color_fills/UI/animations/scale_bounce.dart';
import 'package:solid_color_fills/database/commons.dart';
import 'package:solid_color_fills/database/helper_functions.dart';

class CurrentColorCard extends ConsumerWidget {
  final double elevation = 5;

  const CurrentColorCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color color = ref.read(commonProvider).color;
    String heroTag = 'picker_color_hero_$color';

    return Tooltip(
      message: 'Click to set wallpaper with this color.',
      child: FadeScale(
        child: ScaleBounce(
          child: Card(
            elevation: elevation,
            shape: CircleBorder(),
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () => openWallChooser(
                context: context,
                ref: ref,
                heroTag: heroTag,
              ),
              child: IgnorePointer(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer(
                    builder: (context, ref, child) => Hero(
                      tag: heroTag,
                      child: CircleColor(
                        circleSize: 50,
                        color: color,
                        elevation: elevation,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
