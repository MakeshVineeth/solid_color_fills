import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:solid_color_fill/UI/database/commons.dart';

final imageProvision = FutureProvider<Uint8List>((ref) async {
  Uint8List uint8list;
  Color color = ref.watch(commonProvider.state).color;

  if (color != null) {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas c = new Canvas(recorder);
    c.drawColor(color, BlendMode.src); // etc
    ui.Picture p = recorder.endRecording();

    int width = 2000; //context.size.width.round();
    int height = 2000; // context.size.height.round();
    ui.Image image = await p.toImage(width, height);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    uint8list = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
  }

  return uint8list;
});
