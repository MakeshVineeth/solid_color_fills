import 'package:flutter/material.dart';
import 'package:solid_color_fills/src/core/constants/color_palette.dart';
import 'package:solid_color_fills/src/features/collections/domain/entities/solid_color_item.dart';

/// Controller managing curated collections and search filtering.
class CollectionsController extends ChangeNotifier {
  static final List<SolidColorItem> _curatedColors =
      List<SolidColorItem>.unmodifiable([
    for (final entry in ColorPalette.curatedColors.entries)
      SolidColorItem(
        name: entry.key,
        color: entry.value,
      ),
  ]);

  List<SolidColorItem> _visibleColors = _curatedColors;
  String _searchQuery = '';

  List<SolidColorItem> get colors => _visibleColors;

  String get searchQuery => _searchQuery;

  void _updateVisibleColors() {
    final trimmed = _searchQuery.trim();
    if (trimmed.isEmpty) {
      _visibleColors = _curatedColors;
      return;
    }
    final query = trimmed.toLowerCase();
    _visibleColors = List<SolidColorItem>.unmodifiable(
      _curatedColors.where((item) => item.name.toLowerCase().contains(query)),
    );
  }

  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      _updateVisibleColors();
      notifyListeners();
    }
  }

  void clearSearch() {
    if (_searchQuery.isNotEmpty) {
      _searchQuery = '';
      _visibleColors = _curatedColors;
      notifyListeners();
    }
  }
}
