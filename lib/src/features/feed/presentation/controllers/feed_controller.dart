import 'package:flutter/material.dart';
import 'package:solid_color_fills/src/features/collections/domain/entities/solid_color_item.dart';
import 'package:solid_color_fills/src/features/feed/domain/services/random_color_generator.dart';

/// State controller managing infinite random color generation.
class FeedController extends ChangeNotifier {
  final RandomColorGenerator _generator;
  final List<SolidColorItem> _colors = [];

  FeedController({RandomColorGenerator? generator})
      : _generator = generator ?? RandomColorGenerator() {
    loadMore(20);
  }

  List<SolidColorItem> get colors => List.unmodifiable(_colors);

  void loadMore([int count = 15]) {
    _colors.addAll(_generator.generateBatch(count));
    notifyListeners();
  }

  void refresh() {
    _colors.clear();
    loadMore(20);
  }
}
