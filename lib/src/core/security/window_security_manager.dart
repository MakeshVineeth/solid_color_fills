import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';
import 'package:solid_color_fills/src/core/utils/logger.dart';

/// Provides FLAG_SECURE support for sensitive screen protection (OWASP M7).
class WindowSecurityManager {
  const WindowSecurityManager._();

  static Future<void> enableSecureMode() async {
    try {
      await FlutterWindowManagerPlus.addFlags(FlutterWindowManagerPlus.FLAG_SECURE);
      AppLogger.info('FLAG_SECURE enabled.');
    } catch (e, stack) {
      AppLogger.error('Failed to enable FLAG_SECURE', e, stack);
    }
  }

  static Future<void> disableSecureMode() async {
    try {
      await FlutterWindowManagerPlus.clearFlags(FlutterWindowManagerPlus.FLAG_SECURE);
      AppLogger.info('FLAG_SECURE cleared.');
    } catch (e, stack) {
      AppLogger.error('Failed to clear FLAG_SECURE', e, stack);
    }
  }
}
