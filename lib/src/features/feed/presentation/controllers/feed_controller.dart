import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:solid_color_fills/src/features/collections/domain/entities/solid_color_item.dart';
import 'package:solid_color_fills/src/features/feed/domain/services/random_color_generator.dart';

/// State controller managing infinite random color generation.
class FeedController extends ChangeNotifier {
  static const int maxItems = 600;

  final RandomColorGenerator _generator;
  final List<SolidColorItem> _colors = [];
  late final List<SolidColorItem> _unmodifiableColors =
      UnmodifiableListView<SolidColorItem>(_colors);

  FeedController({RandomColorGenerator? generator})
      : _generator = generator ?? RandomColorGenerator() {
    loadMore(20);
  }

  List<SolidColorItem> get colors => _unmodifiableColors;
  bool get hasMore => _colors.length < maxItems;

  void loadMore([int count = 15]) {
    if (count <= 0 || !hasMore) return;
    final remaining = maxItems - _colors.length;
    final batchSize = count < remaining ? count : remaining;
    _colors.addAll(_generator.generateBatch(batchSize));
    notifyListeners();
  }

  void refresh() {
    _colors.clear();
    loadMore(20);
  }

  @override
  void dispose() {
    _colors.clear();
    super.dispose();
  }
}
