import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:solid_color_fills/src/core/utils/logger.dart';

/// Service managing dynamic Android App Shortcuts (Quick Actions).
class QuickActionsService {
  final QuickActions _quickActions;
  final ValueChanged<int>? onShortcutSelected;
  bool _isDisposed = false;

  QuickActionsService({
    QuickActions quickActions = const QuickActions(),
    this.onShortcutSelected,
  }) : _quickActions = quickActions;

  static const String actionCollection = 'action_collection';
  static const String actionColors = 'action_colors';
  static const String actionFeed = 'action_feed';

  void initialize() {
    if (!Platform.isAndroid && !Platform.isIOS) return;

    try {
      _quickActions.initialize((shortcutType) {
        if (_isDisposed) return;
        AppLogger.info('Quick action triggered: $shortcutType');
        switch (shortcutType) {
          case actionCollection:
          case 'action_collections':
            onShortcutSelected?.call(0);
            break;
          case actionColors:
          case 'action_color_picker':
            onShortcutSelected?.call(1);
            break;
          case actionFeed:
            onShortcutSelected?.call(2);
            break;
        }
      });

      _quickActions.setShortcutItems(const [
        ShortcutItem(
          type: actionCollection,
          localizedTitle: 'Collections',
          localizedSubtitle: 'Curated list of colors',
          icon: 'icon_collection',
        ),
        ShortcutItem(
          type: actionColors,
          localizedTitle: 'Color Picker',
          localizedSubtitle: 'Custom Color Pickers',
          icon: 'icon_colors',
        ),
        ShortcutItem(
          type: actionFeed,
          localizedTitle: 'Feed',
          localizedSubtitle: 'Unlimited Color Feed',
          icon: 'icon_feed',
        ),
      ]);
    } catch (e, stack) {
      AppLogger.error('Failed to initialize quick actions', e, stack);
    }
  }

  void dispose() {
    _isDisposed = true;
  }
}
