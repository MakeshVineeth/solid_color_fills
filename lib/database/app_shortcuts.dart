import 'package:quick_actions/quick_actions.dart';
import 'package:solid_color_fills/fixed_values.dart';

class AppShortcuts {
  static final List<ShortcutItem> shortcutsList = [
    collectionQuickAction,
    colorsQuickAction,
    feedQuickAction,
  ];

  static final collectionQuickAction = const ShortcutItem(
    type: 'action_collection',
    localizedTitle: FixedValues.collectionScreenTitle,
    localizedSubtitle: 'Curated list of colors',
    icon: 'icon_collection',
  );

  static final colorsQuickAction = const ShortcutItem(
    type: 'action_colors',
    localizedTitle: FixedValues.colorPickersScreenTitle,
    localizedSubtitle: 'Custom Color Pickers',
    icon: 'icon_colors',
  );

  static final feedQuickAction = const ShortcutItem(
    type: 'action_feed',
    localizedTitle: FixedValues.feedScreenTitle,
    localizedSubtitle: 'Unlimited Color Feed',
    icon: 'icon_feed',
  );
}
