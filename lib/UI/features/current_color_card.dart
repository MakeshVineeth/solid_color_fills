import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:solid_color_fills/UI/animations/fade_scale_widget.dart';
import 'package:solid_color_fills/UI/animations/scaleBounce.dart';
import 'package:solid_color_fills/database/commons.dart';
import 'package:solid_color_fills/database/helperFunctions.dart';

class CurrentColorCard extends ConsumerWidget {
  final double elevation = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Click to set wallpaper with this color.',
      child: Hero(
        tag: 'picker_color_hero',
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
                  transition: const Duration(milliseconds: 500),
                ),
                child: IgnorePointer(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer(
                      builder: (context, ref, child) {
                        return CircleColor(
                          circleSize: 50,
                          color: ref.watch(commonProvider).color,
                          elevation: elevation,
                        );
                      },
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
