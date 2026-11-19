import 'dart:typed_data';
import 'package:solid_color_fills/src/features/wallpaper/domain/entities/wallpaper_target.dart';

/// Contract for wallpaper manipulation and export operations (DIP, LSP).
/// Pure Dart interface without Flutter UI dependencies.
abstract class WallpaperRepository {
  /// Applies a solid color image to the specified wallpaper target.
  Future<bool> setWallpaper({
    required Uint8List imageBytes,
    required String colorTitle,
    required WallpaperTarget target,
  });

  /// Opens the rendered image file in the system gallery or photo viewer.
  Future<bool> openInGallery({
    required Uint8List imageBytes,
    required String colorTitle,
  });
}
