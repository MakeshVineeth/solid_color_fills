import 'dart:io';
import 'dart:typed_data';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solid_color_fills/src/core/utils/logger.dart';
import 'package:solid_color_fills/src/features/wallpaper/domain/entities/wallpaper_target.dart';
import 'package:solid_color_fills/src/features/wallpaper/domain/repositories/wallpaper_repository.dart';
import 'package:wallpaper_manager_plus/wallpaper_manager_plus.dart';

/// Concrete implementation of [WallpaperRepository].
class WallpaperRepositoryImpl implements WallpaperRepository {
  static const int _maxFilenameLength = 40;
  static final RegExp _invalidFilenameChars = RegExp(r'[^a-zA-Z0-9_\-]');

  final WallpaperManagerPlus _wallpaperManager;
  Directory? _cachedTempDir;

  WallpaperRepositoryImpl({WallpaperManagerPlus? wallpaperManager})
      : _wallpaperManager = wallpaperManager ?? WallpaperManagerPlus();

  Future<Directory> _getTempDir() async {
    return _cachedTempDir ??= await getTemporaryDirectory();
  }

  String _sanitizeFilename(String colorTitle) {
    final cleaned = colorTitle.replaceAll(_invalidFilenameChars, '_');
    if (cleaned.isEmpty) {
      return 'solid';
    }
    return cleaned.length > _maxFilenameLength
        ? cleaned.substring(0, _maxFilenameLength)
        : cleaned;
  }

  Future<void> _sweepStaleTempWallpapers(Directory tempDir) async {
    try {
      await for (final entity in tempDir.list()) {
        if (entity is File) {
          final name = entity.uri.pathSegments.last;
          if (name.startsWith('wallpaper_') && name.endsWith('.png')) {
            await entity.delete();
          }
        }
      }
    } catch (_) {}
  }

  @override
  Future<bool> setWallpaper({
    required Uint8List imageBytes,
    required String colorTitle,
    required WallpaperTarget target,
  }) async {
    if (imageBytes.isEmpty || target == WallpaperTarget.gallery) {
      return false;
    }

    File? tempFile;
    try {
      final sanitizedTitle = _sanitizeFilename(colorTitle);
      final tempDir = await _getTempDir();
      final filePath = '${tempDir.path}/wallpaper_$sanitizedTitle.png';

      tempFile = File(filePath);
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      await tempFile.writeAsBytes(imageBytes, flush: true);

      final int locationFlag;
      switch (target) {
        case WallpaperTarget.homeScreen:
          locationFlag = WallpaperManagerPlus.homeScreen;
          break;
        case WallpaperTarget.lockScreen:
          locationFlag = WallpaperManagerPlus.lockScreen;
          break;
        case WallpaperTarget.bothScreens:
          locationFlag = WallpaperManagerPlus.bothScreens;
          break;
        case WallpaperTarget.gallery:
          return false;
      }

      final result = await _wallpaperManager.setWallpaper(tempFile, locationFlag);
      AppLogger.info('Wallpaper set result: $result for target ${target.label}');
      return result != null;
    } catch (e, stack) {
      AppLogger.error('Error applying wallpaper', e, stack);
      return false;
    } finally {
      if (tempFile != null && await tempFile.exists()) {
        try {
          await tempFile.delete();
        } catch (_) {}
      }
    }
  }

  @override
  Future<bool> openInGallery({
    required Uint8List imageBytes,
    required String colorTitle,
  }) async {
    if (imageBytes.isEmpty) return false;

    try {
      final sanitizedTitle = _sanitizeFilename(colorTitle);
      final tempDir = await _getTempDir();
      await _sweepStaleTempWallpapers(tempDir);

      final filePath = '${tempDir.path}/wallpaper_$sanitizedTitle.png';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes, flush: true);

      final openResult = await OpenFilex.open(filePath);
      AppLogger.info('OpenFilex result: ${openResult.type}');
      return openResult.type == ResultType.done;
    } catch (e, stack) {
      AppLogger.error('Error opening image in gallery', e, stack);
      return false;
    }
  }
}
