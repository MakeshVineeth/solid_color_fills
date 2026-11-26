import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solid_color_fills/src/core/constants/app_constants.dart';
import 'package:solid_color_fills/src/features/collections/presentation/widgets/color_grid_card.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/controllers/color_picker_controller.dart';
import 'package:solid_color_fills/src/features/feed/presentation/controllers/feed_controller.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/controllers/wallpaper_controller.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/screens/wallpaper_confirmation_screen.dart';

/// Screen displaying an infinite feed of randomly generated solid colors.
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          _scrollController.hasClients &&
          _scrollController.position.maxScrollExtent < 100) {
        context.read<FeedController>().loadMore(20);
      }
    });
  }

  void _onScroll() {
    if (_isLoadingMore || !_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 400) return;
    final controller = context.read<FeedController>();
    if (!controller.hasMore) return;

    _isLoadingMore = true;
    controller.loadMore(15);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

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

        return Consumer<FeedController>(
          builder: (context, controller, child) {
            final items = controller.colors;

            return RefreshIndicator(
              onRefresh: () async => controller.refresh(),
              child: GridView.builder(
                controller: _scrollController,
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
                  final heroTag = 'feed_${item.name}_$index';

                  return ColorGridCard(
                    item: item,
                    heroTag: heroTag,
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
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
              ),
            );
          },
        );
      },
    );
  }
}
