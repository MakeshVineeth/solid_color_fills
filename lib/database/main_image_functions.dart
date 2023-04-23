import 'dart:io';
import 'dart:ui' as ui;

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solid_color_fills/database/commons.dart';

final imageProvision = FutureProvider<Uint8List>((ref) async {
  Uint8List integerList = Uint8List(0);
  Color color = ref.watch(commonProvider).color;
  final screen = ref.watch(screenSize.notifier).state;

  try {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas c = Canvas(recorder);
    c.drawColor(color, BlendMode.src); // etc
    ui.Picture p = recorder.endRecording();

    int width = screen.width;
    int height = screen.height;
    ui.Image image = await p.toImage(width, height);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    integerList = byteData!.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
  } catch (_) {}

  return integerList;
});

final imageSetter = StateProvider<SetImage>((ref) {
  Uint8List pngBytes = ref.watch(imageProvision).asData!.value;
  return SetImage(pngBytes);
});

class SetImage {
  Uint8List? pngBytes;

  SetImage(this.pngBytes);

  Future<bool> setNow({required int location}) async {
    // Returns true if success.
    try {
      if (pngBytes == null) return false;

      String tempPath = (await getTemporaryDirectory()).path;
      String filePath = tempPath + '/temp.png';
      File file = File(filePath);
      if (await file.exists()) await file.delete();

      File fileWritten = await file.writeAsBytes(pngBytes!, flush: true);
      bool fileExists = await fileWritten.exists();
      if (!fileExists) return false;

      if (location != 4) {
        bool result = await AsyncWallpaper.setWallpaperFromFile(
            filePath: filePath, wallpaperLocation: location);
        await fileWritten.delete();
        return result;
      }

      OpenResult openResult = await OpenFilex.open(filePath);
      if (openResult.type != ResultType.done) return false;
      return true;
    } catch (_) {
      return false;
    }
  }
}
