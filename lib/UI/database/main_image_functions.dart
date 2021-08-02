import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solid_color_fills/UI/database/commons.dart';

final imageProvision = FutureProvider<Uint8List>((ref) async {
  Uint8List uint8list;
  Color color = ref.watch(commonProvider).color;
  final screen = ref.watch(screenSize).state;

  if (color != null) {
    try {
      ui.PictureRecorder recorder = ui.PictureRecorder();
      Canvas c = Canvas(recorder);
      c.drawColor(color, BlendMode.src); // etc
      ui.Picture p = recorder.endRecording();

      int width = screen.width;
      int height = screen.height;
      ui.Image image = await p.toImage(width, height);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      uint8list = byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    } catch (_) {}
  }

  return uint8list;
});

final imageSetter = StateProvider<SetImage>((ref) {
  Uint8List pngBytes = ref.watch(imageProvision).data?.value;
  return SetImage(pngBytes);
});

const MethodChannel _channel = const MethodChannel('setwallpaper');

class SetImage {
  Uint8List pngBytes;
  SetImage(this.pngBytes);

  Future<bool> setNow({@required int location}) async {
    // Returns true if success.
    try {
      if (pngBytes != null) {
        if (location == 4) {
          String tempPath = (await getTemporaryDirectory()).path;
          String filePath = tempPath + '/temp.png';
          File file = File(filePath);

          await file.writeAsBytes(pngBytes);

          if (await file.exists()) {
            OpenResult openResult = await OpenFile.open(filePath);
            if (openResult.type == ResultType.done)
              return true;
            else
              return false;
          } else
            return false;
        }

        // This native method is part of wallpaper plugin, see the plugin's source code.
        else {
          _channel.invokeMethod(
            'setWallpaper',
            {
              'data': pngBytes,
              'location': location,
            },
          );

          return true;
        }
      } else
        return false;
    } catch (_) {
      return false;
    }
  }
}
