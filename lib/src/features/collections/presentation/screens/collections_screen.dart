import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solid_color_fills/src/core/constants/app_constants.dart';
import 'package:solid_color_fills/src/features/collections/presentation/controllers/collections_controller.dart';
import 'package:solid_color_fills/src/features/collections/presentation/widgets/color_grid_card.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/controllers/color_picker_controller.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/controllers/wallpaper_controller.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/screens/wallpaper_confirmation_screen.dart';

/// Collections screen displaying curated solid colors in an adaptive grid.
/// Faithful to original layout with no extraneous search bars.
class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  int _calculateCrossAxisCount(double width) {
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

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _calculateCrossAxisCount(constraints.maxWidth);

        return Consumer<CollectionsController>(
          builder: (context, controller, child) {
            final items = controller.colors;

            return GridView.builder(
              addAutomaticKeepAlives: false,
              padding: const EdgeInsets.all(15.0),
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: isPortrait ? 0.70 : 1.2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final heroTag = 'collection_${item.name}_$index';

                return ColorGridCard(
                  item: item,
                  heroTag: heroTag,
                  onTap: () {
                    context.read<WallpaperController>().setColor(
                          color: item.color,
                          title: item.name,
                        );
                    context.read<ColorPickerController>().setColor(
                          item.color,
                          title: item.name,
                        );
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => WallpaperConfirmationScreen(
                          heroTag: heroTag,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
