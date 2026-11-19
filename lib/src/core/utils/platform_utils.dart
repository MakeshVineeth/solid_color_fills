import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:solid_color_fills/src/core/utils/logger.dart';

/// Platform and hardware integration utilities.
class PlatformUtils {
  const PlatformUtils._();

  /// Attempts to enable high refresh rate mode on supported Android displays.
  static Future<void> optimizeDisplayRefreshRate() async {
    if (!Platform.isAndroid) return;
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 23) {
        await FlutterDisplayMode.setHighRefreshRate();
        AppLogger.info('High display refresh rate enabled.');
      }
    } catch (e, stack) {
      AppLogger.error('Failed to configure display refresh rate', e, stack);
    }
  }

  /// Retrieves Android SDK integer version.
  static Future<int> getAndroidSdkVersion() async {
    if (!Platform.isAndroid) return 0;
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt;
    } catch (_) {
      return 0;
    }
  }
}
