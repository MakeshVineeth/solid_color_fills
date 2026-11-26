import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:solid_color_fills/src/core/utils/color_utils.dart';
import 'package:solid_color_fills/src/features/wallpaper/data/services/canvas_image_service.dart';
import 'package:solid_color_fills/src/features/wallpaper/domain/entities/wallpaper_target.dart';
import 'package:solid_color_fills/src/features/wallpaper/domain/repositories/wallpaper_repository.dart';

/// Presentation state controller for wallpaper preview and application.
class WallpaperController extends ChangeNotifier {
  final WallpaperRepository _repository;
  final CanvasImageService _canvasImageService;

  Color _selectedColor = Colors.blue;
  String _colorTitle = 'Blue';
  Uint8List? _cachedImageBytes;
  int? _cachedWidth;
  int? _cachedHeight;
  bool _isLoading = false;
  bool? _lastOperationSuccess;
  String? _errorMessage;

  WallpaperController({
    required WallpaperRepository repository,
    CanvasImageService canvasImageService = const CanvasImageService(),
  })  : _repository = repository,
        _canvasImageService = canvasImageService;

  Color get selectedColor => _selectedColor;
  String get colorTitle => _colorTitle;
  Uint8List? get cachedImageBytes => _cachedImageBytes;
  bool get isLoading => _isLoading;
  bool? get lastOperationSuccess => _lastOperationSuccess;
  String? get errorMessage => _errorMessage;

  void setColor({required Color color, String? title}) {
    _selectedColor = color;
    _colorTitle = title ?? ColorUtils.toHex(color);
    _cachedImageBytes = null;
    _cachedWidth = null;
    _cachedHeight = null;
    _lastOperationSuccess = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Releases cached encoded PNG bytes without notifying listeners.
  void clearCache() {
    _cachedImageBytes = null;
    _cachedWidth = null;
    _cachedHeight = null;
  }

  Future<Uint8List> prepareImageBytes({
    required int width,
    required int height,
  }) async {
    if (_cachedImageBytes != null &&
        _cachedImageBytes!.isNotEmpty &&
        _cachedWidth == width &&
        _cachedHeight == height) {
      return _cachedImageBytes!;
    }
    final bytes = await _canvasImageService.generateSolidColorPng(
      color: _selectedColor,
      width: width,
      height: height,
    );
    _cachedImageBytes = bytes;
    _cachedWidth = width;
    _cachedHeight = height;
    return bytes;
  }

  @override
  void dispose() {
    clearCache();
    super.dispose();
  }

  Future<bool> applyWallpaper({
    required WallpaperTarget target,
    required int width,
    required int height,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _lastOperationSuccess = null;
    notifyListeners();

    try {
      final bytes = await prepareImageBytes(width: width, height: height);
      if (bytes.isEmpty) {
        _errorMessage = 'Failed to generate image buffer';
        _lastOperationSuccess = false;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      bool success;
      if (target == WallpaperTarget.gallery) {
        success = await _repository.openInGallery(
          imageBytes: bytes,
          colorTitle: _colorTitle,
        );
      } else {
        success = await _repository.setWallpaper(
          imageBytes: bytes,
          colorTitle: _colorTitle,
          target: target,
        );
      }

      _lastOperationSuccess = success;
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      _lastOperationSuccess = false;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
