import 'package:flutter/material.dart';
import 'package:solid_color_fills/src/core/constants/app_constants.dart';

/// Wraps widgets to constrain their maximum width on tablets, foldables, and desktop/TV screens.
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth = AppConstants.compactBreakpoint,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
