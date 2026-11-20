/// Sanitizes and validates user color hex inputs (OWASP M4).
class InputValidator {
  const InputValidator._();

  static final RegExp _hexColorRegex =
      RegExp(r'^#?([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$');

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

  /// Sanitizes text input to prevent overflow or unexpected characters.
  static String sanitizeText(String input, {int maxLength = 50}) {
    final trimmed = input.trim();
    if (trimmed.length > maxLength) {
      return trimmed.substring(0, maxLength);
    }
    return trimmed;
  }
}
