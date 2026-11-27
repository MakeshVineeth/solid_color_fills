import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:solid_color_fills/src/core/security/input_validator.dart';
import 'package:solid_color_fills/src/features/collections/domain/entities/solid_color_item.dart';
import 'package:solid_color_fills/src/features/feed/domain/services/random_color_generator.dart';

/// State controller managing infinite random color generation and title filtering.
class FeedController extends ChangeNotifier {
  static const int maxItems = 600;

  final RandomColorGenerator _generator;
  final List<SolidColorItem> _colors = [];
  late final List<SolidColorItem> _unmodifiableColors =
      UnmodifiableListView<SolidColorItem>(_colors);
  String _searchQuery = '';
  List<SolidColorItem>? _filteredColors;

  FeedController({RandomColorGenerator? generator})
      : _generator = generator ?? RandomColorGenerator() {
    loadMore(20);
  }

  List<SolidColorItem> get colors => _filteredColors ?? _unmodifiableColors;
  String get searchQuery => _searchQuery;
  bool get isSearching => _searchQuery.isNotEmpty;
  bool get hasMore => _colors.length < maxItems;

  void _rebuildFilter() {
    if (_searchQuery.isEmpty) {
      _filteredColors = null;
      return;
    }
    final query = _searchQuery.toLowerCase();
    _filteredColors = List<SolidColorItem>.unmodifiable(
      _colors.where((item) => item.name.toLowerCase().contains(query)),
    );
  }

  void setSearchQuery(String query) {
    final sanitized = InputValidator.sanitizeText(query);
    if (_searchQuery == sanitized) return;
    _searchQuery = sanitized;
    _rebuildFilter();
    notifyListeners();
  }

  void clearSearch() {
    if (_searchQuery.isEmpty) return;
    _searchQuery = '';
    _filteredColors = null;
    notifyListeners();
  }

  void loadMore([int count = 15]) {
    if (count <= 0 || !hasMore) return;
    final remaining = maxItems - _colors.length;
    final batchSize = count < remaining ? count : remaining;
    _colors.addAll(_generator.generateBatch(batchSize));
    if (isSearching) {
      _rebuildFilter();
    }
    notifyListeners();
  }

  void refresh() {
    _colors.clear();
    loadMore(20);
  }

  @override
  void dispose() {
    _colors.clear();
    _filteredColors = null;
    super.dispose();
  }
}
