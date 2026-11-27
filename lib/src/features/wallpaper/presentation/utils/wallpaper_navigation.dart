import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solid_color_fills/src/features/collections/domain/entities/solid_color_item.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/controllers/color_picker_controller.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/controllers/wallpaper_controller.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/screens/wallpaper_confirmation_screen.dart';

/// Unfocuses any active search field, updates active color state, and opens confirmation.
void openWallpaperConfirmation(
  BuildContext context, {
  required SolidColorItem item,
  required String heroTag,
}) {
  FocusManager.instance.primaryFocus?.unfocus();
  context.read<WallpaperController>().setColor(
        color: item.color,
        title: item.name,
      );
  context.read<ColorPickerController>().setColor(
        item.color,
        title: item.name,
      );
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => WallpaperConfirmationScreen(heroTag: heroTag),
    ),
  );
}
