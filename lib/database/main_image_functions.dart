import 'dart:io';
import 'dart:ui' as ui;
import 'package:wallpaper_manager_plus/wallpaper_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solid_color_fills/database/commons.dart';

final FutureProvider<Uint8List> imageProvision = FutureProvider<Uint8List>((
  ref,
) async {
  Uint8List integerList = Uint8List(0);
  final object = ref.watch(commonProvider);
  Color color = object.color;

  final screen = ref.watch(screenSize);

  try {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas c = Canvas(recorder);
    c.drawColor(color, BlendMode.src);
    ui.Picture p = recorder.endRecording();

    int width = screen.width;
    int height = screen.height;
    ui.Image image = await p.toImage(width, height);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    integerList = byteData!.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );
  } catch (_) {}

  return integerList;
});

final imageSetter = StateProvider<SetImage>((ref) {
  Uint8List pngBytes = ref.read(imageProvision).asData!.value;
  final object = ref.read(commonProvider);
  String colorTitle = object.colorTitle;
  return SetImage(pngBytes, colorTitle);
});

class SetImage {
  final Uint8List _pngBytes;
  final String _colorTitle;

  SetImage(this._pngBytes, this._colorTitle);

  Future<bool> setNow({required int location}) async {
    // Returns true if success.
    try {
      if (_pngBytes.isEmpty) return false;

      String tempPath = (await getTemporaryDirectory()).path;
      String filePath = '$tempPath/Temp_$_colorTitle.png';
      File file = File(filePath);
      if (await file.exists()) await file.delete();

      File fileWritten = await file.writeAsBytes(_pngBytes);
      bool fileExists = await fileWritten.exists();
      if (!fileExists) return false;

      switch (location) {
        case WallpaperManagerPlus.homeScreen:
        case WallpaperManagerPlus.lockScreen:
        case WallpaperManagerPlus.bothScreens:
          String? result = await WallpaperManagerPlus().setWallpaper(
            fileWritten,
            location,
          );

          await fileWritten.delete();
          return result != null;
        case 4:
          OpenResult openResult = await OpenFilex.open(filePath);
          return openResult.type == ResultType.done;
        default:
          return false;
      }
    } catch (_) {
      return false;
    }
  }
}
