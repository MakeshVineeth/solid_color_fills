import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:solid_color_fills/src/core/constants/app_constants.dart';

/// Computes responsive column count for color grid layouts.
int adaptiveColorGridCrossAxisCount(double width) {
  if (width < AppConstants.compactBreakpoint) {
    return 2;
  } else if (width < AppConstants.mediumBreakpoint) {
    return 3;
  } else if (width < AppConstants.expandedBreakpoint) {
    return 4;
  } else {
    return 6;
  }
}

/// Shared empty state view displayed when a color search yields no results.
class SearchEmptyState extends StatelessWidget {
  final String message;
  final List<Widget> actions;

  const SearchEmptyState({
    super.key,
    required this.message,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? Colors.white70 : const Color(0xFF5F6368);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FluentIcons.search_24_regular,
              size: 32,
              color: mutedColor,
            ),
            const SizedBox(height: 10),
            Text(message),
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                alignment: WrapAlignment.center,
                children: actions,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
