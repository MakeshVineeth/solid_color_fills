import 'package:in_app_review/in_app_review.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solid_color_fills/UI/database/commons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:solid_color_fills/UI/wall_chooser.dart';
import 'dart:ui';

void openWallChooser({
  @required WidgetRef ref,
  @required BuildContext context,
  Duration transition = const Duration(milliseconds: 450),
}) {
  Size size = window.physicalSize;

  if (size != Size.zero) {
    int height = size.height.ceil();
    int width = size.width.ceil();

    if (width > height) {
      int temp = height;
      height = width;
      width = temp;
    }

    final ScreenSize newSize = ScreenSize(width, height);
    final currentState = ref.read(screenSize);

    if (currentState.state.width != newSize.width) currentState.state = newSize;
  }

  final color = ref.read(commonProvider).color;

  if (color != null && color != Colors.transparent)
    Navigator.push(
      context,
      PageTransition(
        duration: transition,
        reverseDuration: transition,
        child: WallChooser(),
        type: PageTransitionType.fade,
      ),
    );
}

Future<void> askForReview({bool action = false}) async {
  try {
    const String reviewCountPrefs = 'review_count';
    const String dateStrPrefs = 'review_date';

    final prefs = await SharedPreferences.getInstance();
    int reviewAskedCount = prefs.getInt(reviewCountPrefs) ?? 0;

    if (reviewAskedCount > 1) return;

    String dateStr = prefs.getString(dateStrPrefs);
    DateTime now = DateTime.now();

    DateTime dateCheck;
    // If dateStr is null, it means there is no shared preference yet which should mean first time.
    if (dateStr == null) {
      await prefs.setString(dateStrPrefs, now.toString());
      dateCheck = now;
    } else
      dateCheck = DateTime.tryParse(dateStr);

    Duration difference = now.difference(dateCheck);

    if ((action && reviewAskedCount == 0) || difference.inHours >= 7) {
      final InAppReview inAppReview = InAppReview.instance;
      final bool isAvailable = await inAppReview.isAvailable();

      if (isAvailable) {
        Future.delayed(const Duration(seconds: 1), () async {
          await prefs.setInt(reviewCountPrefs, ++reviewAskedCount);
          await inAppReview.requestReview();
        });
      }
    }
  } catch (_) {}
}
