import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:solid_color_fills/src/core/utils/logger.dart';

/// Service responsible for encoding solid color wallpapers into PNG byte buffers.
/// Generates 24-bit RGB PNG streams off the main isolate with minimal heap memory.
class CanvasImageService {
  static const int _maxDimension = 4096;

  static const List<int> _pngSignature = <int>[
    137,
    80,
    78,
    71,
    13,
    10,
    26,
    10,
  ];
  static const List<int> _ihdrType = <int>[73, 72, 68, 82];
  static const List<int> _idatType = <int>[73, 68, 65, 84];
  static const List<int> _iendType = <int>[73, 69, 78, 68];

  static final Uint32List _crcTable = _buildCrcTable();

  const CanvasImageService();

  Future<Uint8List> generateSolidColorPng({
    required Color color,
    required int width,
    required int height,
  }) async {
    try {
      final safeWidth = (width > 0 ? width : 1080).clamp(1, _maxDimension);
      final safeHeight = (height > 0 ? height : 1920).clamp(1, _maxDimension);
      final r = (color.r * 255).round().clamp(0, 255);
      final g = (color.g * 255).round().clamp(0, 255);
      final b = (color.b * 255).round().clamp(0, 255);

      return await Isolate.run(
        () => _encodeSolidRgbPng(
          r: r,
          g: g,
          b: b,
          width: safeWidth,
          height: safeHeight,
        ),
      );
    } catch (e, stack) {
      AppLogger.error('Failed to generate solid color PNG', e, stack);
      return Uint8List(0);
    }
  }

  static Uint8List _encodeSolidRgbPng({
    required int r,
    required int g,
    required int b,
    required int width,
    required int height,
  }) {
    final ihdr = _buildIhdr(width, height);
    final idat = _encodeIdatPayload(
      r: r,
      g: g,
      b: b,
      width: width,
      height: height,
    );

    final out = BytesBuilder(copy: false)
      ..add(_pngSignature);
    _writeChunk(out, _ihdrType, ihdr);
    _writeChunk(out, _idatType, idat);
    _writeChunk(out, _iendType, Uint8List(0));
    return out.takeBytes();
  }

  static Uint8List _buildIhdr(int width, int height) {
    final ihdr = ByteData(13)
      ..setUint32(0, width)
      ..setUint32(4, height)
      ..setUint8(8, 8) // Bit depth: 8
      ..setUint8(9, 2) // Color type: 2 (Truecolor RGB)
      ..setUint8(10, 0) // Compression: 0 (Deflate)
      ..setUint8(11, 0) // Filter: 0
      ..setUint8(12, 0); // Interlace: 0 (None)
    return ihdr.buffer.asUint8List();
  }

  static Uint8List _encodeIdatPayload({
    required int r,
    required int g,
    required int b,
    required int width,
    required int height,
  }) {
    final rowLength = 1 + width * 3;
    final firstRow = Uint8List(rowLength);
    // Filter type 0 (None) on first scanline; subsequent rows stay 0x00 under Up filter.
    firstRow[0] = 0;
    for (var x = 1; x < rowLength; x += 3) {
      firstRow[x] = r;
      firstRow[x + 1] = g;
      firstRow[x + 2] = b;
    }

    final compressedBuilder = BytesBuilder(copy: false);
    final outSink = ByteConversionSink.withCallback(
      (bytes) => compressedBuilder.add(bytes),
    );
    final zlibSink = ZLibEncoder(level: 1).startChunkedConversion(outSink);

    zlibSink.add(firstRow);
    if (height > 1) {
      final repeatRow = Uint8List(rowLength)..[0] = 2; // PNG Filter type 2 (Up)
      for (var y = 1; y < height; y++) {
        zlibSink.add(repeatRow);
      }
    }
    zlibSink.close();
    return compressedBuilder.takeBytes();
  }

  static void _writeChunk(BytesBuilder out, List<int> type, Uint8List data) {
    _writeUint32BE(out, data.length);
    out
      ..add(type)
      ..add(data);
    _writeUint32BE(out, _crc32(type, data));
  }

  static void _writeUint32BE(BytesBuilder out, int value) {
    out
      ..addByte((value >> 24) & 0xFF)
      ..addByte((value >> 16) & 0xFF)
      ..addByte((value >> 8) & 0xFF)
      ..addByte(value & 0xFF);
  }

  static int _crc32(List<int> type, Uint8List data) {
    var crc = 0xFFFFFFFF;
    for (var i = 0; i < type.length; i++) {
      crc = _crcTable[(crc ^ type[i]) & 0xFF] ^ (crc >>> 8);
    }
    for (var i = 0; i < data.length; i++) {
      crc = _crcTable[(crc ^ data[i]) & 0xFF] ^ (crc >>> 8);
    }
    return (crc ^ 0xFFFFFFFF) & 0xFFFFFFFF;
  }

  static Uint32List _buildCrcTable() {
    final table = Uint32List(256);
    for (var n = 0; n < 256; n++) {
      var c = n;
      for (var k = 0; k < 8; k++) {
        c = (c & 1) != 0 ? 0xEDB88320 ^ (c >>> 1) : (c >>> 1);
      }
      table[n] = c;
    }
    return table;
  }
}
