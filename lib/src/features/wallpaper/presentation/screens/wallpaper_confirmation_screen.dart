import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:solid_color_fills/l10n/app_localizations.dart';
import 'package:solid_color_fills/src/core/constants/app_constants.dart';
import 'package:solid_color_fills/src/core/widgets/responsive_wrapper.dart';
import 'package:solid_color_fills/src/features/wallpaper/domain/entities/wallpaper_target.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/controllers/wallpaper_controller.dart';

/// Screen displaying the wallpaper preview with application action buttons.
/// Faithfully preserves the original elevated shadowed card preview aesthetic.
class WallpaperConfirmationScreen extends StatelessWidget {
  final String heroTag;

  const WallpaperConfirmationScreen({
    super.key,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlayBrightness = isDark ? Brightness.light : Brightness.dark;
    final mediaQuery = MediaQuery.of(context);
    final devicePixelRatio = mediaQuery.devicePixelRatio;
    var screenPixelWidth = (mediaQuery.size.width * devicePixelRatio).round();
    var screenPixelHeight = (mediaQuery.size.height * devicePixelRatio).round();

    // Normalize to portrait orientation for solid wallpaper generation
    if (screenPixelWidth > screenPixelHeight) {
      final temp = screenPixelHeight;
      screenPixelHeight = screenPixelWidth;
      screenPixelWidth = temp;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: isDark ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness: overlayBrightness,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: overlayBrightness,
      ),
      child: Scaffold(
      appBar: AppBar(
        title: Text(l10n?.wallpaperConfirmation ?? 'Wallpaper Confirmation'),
      ),
      body: SafeArea(
        child: ResponsiveWrapper(
          maxWidth: 600,
          child: Consumer<WallpaperController>(
            builder: (context, controller, child) {
              final color = controller.selectedColor;
              final title = controller.colorTitle;

              return LayoutBuilder(
                builder: (context, constraints) {
                  final isLandscape =
                      MediaQuery.of(context).orientation ==
                      Orientation.landscape;

                  final previewWidth =
                      isLandscape ? 300.0 : constraints.maxWidth / 1.8;
                  final previewHeight = isLandscape
                      ? constraints.maxHeight / 2
                      : constraints.maxHeight / 1.8;

                  final buttonWidth = isLandscape
                      ? constraints.maxWidth / 3
                      : constraints.maxWidth / 2;

                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Elevated Shadowed Card Preview
                            Hero(
                              tag: heroTag,
                              child: Card(
                                elevation: 3.0,
                                shape: AppConstants.roundShape,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: AppConstants.cardRadius,
                                    child: SizedBox(
                                      width: previewWidth,
                                      height: previewHeight,
                                      child: ColoredBox(color: color),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),

                            // Direct Color Info Title
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Color Info: $title',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),

                            // Action Buttons Column
                            if (controller.isLoading)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            else ...[
                              SizedBox(
                                width: buttonWidth,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 3,
                                      ),
                                      child: _ActionButton(
                                        label: 'Set As Home Screen',
                                        onPressed: () => _applyWallpaper(
                                          context,
                                          controller,
                                          WallpaperTarget.homeScreen,
                                          screenPixelWidth,
                                          screenPixelHeight,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 3,
                                      ),
                                      child: _ActionButton(
                                        label: 'Set As Lock Screen',
                                        onPressed: () => _applyWallpaper(
                                          context,
                                          controller,
                                          WallpaperTarget.lockScreen,
                                          screenPixelWidth,
                                          screenPixelHeight,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 3,
                                      ),
                                      child: _ActionButton(
                                        label: 'Set As Both',
                                        onPressed: () => _applyWallpaper(
                                          context,
                                          controller,
                                          WallpaperTarget.bothScreens,
                                          screenPixelWidth,
                                          screenPixelHeight,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 3,
                                      ),
                                      child: _ActionButton(
                                        label: 'Open in Gallery',
                                        onPressed: () => _applyWallpaper(
                                          context,
                                          controller,
                                          WallpaperTarget.gallery,
                                          screenPixelWidth,
                                          screenPixelHeight,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Original Helpful Lock Screen Note
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'Note: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.color,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text:
                                          'Use the Open in Gallery option if you\'re having troubles changing the lock screen wallpaper.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    ),
    );
  }

  Future<void> _applyWallpaper(
    BuildContext context,
    WallpaperController controller,
    WallpaperTarget target,
    int width,
    int height,
  ) async {
    final success = await controller.applyWallpaper(
      target: target,
      width: width,
      height: height,
    );

    if (!context.mounted) return;

    // Gallery opening does not display a completion SnackBar (matches master behavior)
    if (target == WallpaperTarget.gallery) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    final String targetText = switch (target) {
      WallpaperTarget.homeScreen => 'Home Screen.',
      WallpaperTarget.lockScreen => 'Lock Screen.',
      WallpaperTarget.bothScreens => 'Home Screen & Lock Screen.',
      _ => 'Wallpaper.',
    };

    final String outputMessage = success
        ? 'Yay! Wallpaper set for $targetText'
        : 'Oops, An error has occurred!';

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          outputMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        elevation: 6.0,
        shape: AppConstants.roundShape,
        backgroundColor:
            success ? Theme.of(context).primaryColor : Colors.red[700],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        textAlign: TextAlign.center,
      ),
    );
  }
}
