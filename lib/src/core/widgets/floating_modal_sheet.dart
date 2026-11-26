import 'package:flutter/material.dart';

/// Displays a floating rounded modal bottom sheet matching the original UI design.
Future<T?> showFloatingModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;

  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    elevation: 0,
    isScrollControlled: true,
    barrierColor: Colors.black54,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: isPortrait
            ? const EdgeInsets.all(25)
            : const EdgeInsets.symmetric(vertical: 25, horizontal: 100),
        child: Align(
          alignment: Alignment.bottomCenter,
          heightFactor: 1.0,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SizedBox(
              width: double.infinity,
              child: Material(
                color: isDark ? const Color(0xFF242424) : Colors.white,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                elevation: 8,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: builder(ctx),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
