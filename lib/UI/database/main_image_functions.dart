import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solid_color_fills/UI/database/commons.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:wallpaper_manager/wallpaper_manager.dart';

final imageProvision = FutureProvider<Uint8List>((ref) async {
  Uint8List uint8list;
  Color color = ref.watch(commonProvider.state).color;
  final screen = ref.watch(screenSize).state;

  if (color != null) {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas c = new Canvas(recorder);
    c.drawColor(color, BlendMode.src); // etc
    ui.Picture p = recorder.endRecording();

    int width = screen.width; //context.size.width.round();
    int height = screen.height; // context.size.height.round();
    ui.Image image = await p.toImage(width, height);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    uint8list = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
  }

  return uint8list;
});

final imageSetter = StateProvider<SetImage>((ref) {
  Uint8List pngBytes = ref.watch(imageProvision).data.value;
  return SetImage(pngBytes);
});

class SetImage {
  Uint8List pngBytes;
  SetImage(this.pngBytes);

  Future<bool> setNow(int location) async {
    bool isDone = false;
    String tempPath = (await getTemporaryDirectory()).path;
    String filePath = tempPath + '/temp.png';
    File file = File(filePath);

    if (pngBytes != null) {
      await file.writeAsBytes(pngBytes);
      String result =
          await WallpaperManager.setWallpaperFromFile(filePath, location);

      if (result.contains('set'))
        isDone = true;
      else
        isDone = false;

      file.delete();
    }

    return isDone;
  }
}
