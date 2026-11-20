import 'package:flutter/material.dart';
import 'package:solid_color_fills/src/core/constants/color_palette.dart';
import 'package:solid_color_fills/src/features/collections/domain/entities/solid_color_item.dart';

/// Controller managing curated collections and search filtering.
class CollectionsController extends ChangeNotifier {
  final List<SolidColorItem> _allColors = [];
  String _searchQuery = '';

  CollectionsController() {
    _loadCuratedColors();
  }

  void _loadCuratedColors() {
    for (final entry in ColorPalette.curatedColors.entries) {
      _allColors.add(SolidColorItem(
        name: entry.key,
        color: entry.value,
      ));
    }
  }

  List<SolidColorItem> get colors {
    if (_searchQuery.trim().isEmpty) {
      return List.unmodifiable(_allColors);
    }
    final query = _searchQuery.toLowerCase().trim();
    return List.unmodifiable(
      _allColors.where((item) => item.name.toLowerCase().contains(query)),
    );
  }

  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  void clearSearch() {
    if (_searchQuery.isNotEmpty) {
      _searchQuery = '';
      notifyListeners();
    }
  }
}
