import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solid_color_fills/UI/features/wall_chooser.dart';
import 'package:solid_color_fills/database/commons.dart';
import 'package:solid_color_fills/fixedValues.dart';

void openWallChooser({
  required WidgetRef ref,
  required BuildContext context,
  Duration transition = const Duration(milliseconds: 450),
  required String heroTag,
}) {
  Size size = View.of(context).physicalSize;

  if (size != Size.zero) {
    int height = size.height.ceil();
    int width = size.width.ceil();

    if (width > height) {
      int temp = height;
      height = width;
      width = temp;
    }

    final ScreenSize newSize = ScreenSize(width, height);
    final currentState = ref.read(screenSize.notifier);

    if (currentState.state.width != newSize.width) currentState.state = newSize;
  }

  final color = ref.read(commonProvider).color;

  if (color != Colors.transparent)
    Navigator.push(
      context,
      PageTransition(
        duration: transition,
        reverseDuration: transition,
        child: WallChooser(heroTag: heroTag),
        type: PageTransitionType.fade,
      ),
    ).then((_) => ScaffoldMessenger.of(context).hideCurrentSnackBar());
}

Future<void> askForReview({bool action = false}) async {
  try {
    const String reviewCountPrefs = 'review_count';
    const String dateStrPrefs = 'review_date';

    final prefs = await SharedPreferences.getInstance();
    int reviewAskedCount = prefs.getInt(reviewCountPrefs) ?? 0;

    if (reviewAskedCount > 1) return;

    String? dateStr = prefs.getString(dateStrPrefs);
    DateTime now = DateTime.now();

    DateTime dateCheck;
    // If dateStr is null, it means there is no shared preference yet which should mean first time.
    if (dateStr == null) {
      await prefs.setString(dateStrPrefs, now.toString());
      dateCheck = now;
    } else
      dateCheck = DateTime.tryParse(dateStr)!;

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

String wallpaperLocationText(int location) {
  String message;

  switch (location) {
    case AsyncWallpaper.HOME_SCREEN:
      message = 'Home Screen.';
      break;
    case AsyncWallpaper.LOCK_SCREEN:
      message = 'Lock Screen.';
      break;
    case AsyncWallpaper.BOTH_SCREENS:
      message = 'Home Screen & Lock Screen.';
      break;
    default:
      message = 'Nothing :(';
  }

  return message;
}

Future<void> setTabIndex(int index) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt(FixedValues.tabIndexPref, index);
}

Future<int> getTabIndex() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(FixedValues.tabIndexPref) ?? 0;
}
