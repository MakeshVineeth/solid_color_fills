import 'dart:ui';

/// Represents a curated or custom solid color entry.
/// Uses pure dart:ui for Color representation without importing Flutter material UI.
class SolidColorItem {
  final String name;
  final Color color;
  final String category;

  const SolidColorItem({
    required this.name,
    required this.color,
    this.category = 'General',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SolidColorItem &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          color.value == other.color.value;

  @override
  int get hashCode => name.hashCode ^ color.value.hashCode;
}
