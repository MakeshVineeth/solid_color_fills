/// Sanitizes and validates user color hex and search text inputs (OWASP M4).
class InputValidator {
  const InputValidator._();

  static const int maxSearchLength = 50;

  static final RegExp _hexColorRegex =
      RegExp(r'^#?([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$');

  static final RegExp disallowedTextPattern =
      RegExp(r'[\x00-\x1F\x7F\u202A-\u202E\u2066-\u2069]');

  static final RegExp _multiWhitespace = RegExp(r'\s+');

  /// Validates whether a hex color string is in valid #RRGGBB or #AARRGGBB format.
  static bool isValidHexColor(String input) {
    final sanitized = input.trim();
    return _hexColorRegex.hasMatch(sanitized);
  }

  /// Normalizes a hex string to clean upper-case 6-character hex without '#' prefix.
  static String? normalizeHex(String input) {
    final trimmed = input.trim();
    if (!isValidHexColor(trimmed)) {
      return null;
    }
    final digits = trimmed.startsWith('#') ? trimmed.substring(1) : trimmed;
    if (digits.length == 8) {
      return digits.substring(2).toUpperCase();
    }
    return digits.toUpperCase();
  }

  /// Strips control/BiDi characters, collapses whitespace, and caps length.
  static String sanitizeText(String input, {int maxLength = maxSearchLength}) {
    final normalized = input
        .replaceAll(disallowedTextPattern, '')
        .replaceAll(_multiWhitespace, ' ')
        .trim();
    if (normalized.length > maxLength) {
      return normalized.substring(0, maxLength).trimRight();
    }
    return normalized;
  }
}
