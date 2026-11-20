import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:solid_color_fills/src/core/utils/logger.dart';

/// Service responsible for rendering solid color into PNG byte buffers.
class CanvasImageService {
  static const int _maxDimension = 8192;

  const CanvasImageService();

  Future<Uint8List> generateSolidColorPng({
    required Color color,
    required int width,
    required int height,
  }) async {
    ui.Picture? picture;
    ui.Image? image;

    try {
      final safeWidth = (width > 0 ? width : 1080).clamp(1, _maxDimension);
      final safeHeight = (height > 0 ? height : 1920).clamp(1, _maxDimension);

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawColor(color, BlendMode.src);
      picture = recorder.endRecording();

      image = await picture.toImage(safeWidth, safeHeight);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw StateError('Failed to encode image to PNG byte data');
      }

      return byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );
    } catch (e, stack) {
      AppLogger.error('Failed to generate solid color PNG', e, stack);
      return Uint8List(0);
    } finally {
      image?.dispose();
      picture?.dispose();
    }
  }
}
