import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solid_color_fills/l10n/app_localizations.dart';
import 'package:solid_color_fills/src/core/widgets/minimal_search_bar.dart';
import 'package:solid_color_fills/src/core/widgets/search_empty_state.dart';
import 'package:solid_color_fills/src/features/collections/presentation/controllers/collections_controller.dart';
import 'package:solid_color_fills/src/features/collections/presentation/widgets/color_grid_card.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/utils/wallpaper_navigation.dart';

/// Collections screen displaying curated solid colors in a searchable adaptive grid.
class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _resetScroll() {
    if (_scrollController.hasClients && _scrollController.offset > 0) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 6),
          child: Selector<CollectionsController, String>(
            selector: (_, c) => c.searchQuery,
            builder: (context, query, _) => MinimalSearchBar(
              initialQuery: query,
              hintText: l10n?.searchCollections ?? 'Search collections...',
              clearTooltip: l10n?.clearSearch ?? 'Clear search',
              onChanged: (value) {
                _resetScroll();
                context.read<CollectionsController>().setSearchQuery(value);
              },
              onClear: () {
                _resetScroll();
                context.read<CollectionsController>().clearSearch();
              },
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount =
                  adaptiveColorGridCrossAxisCount(constraints.maxWidth);

              return Consumer<CollectionsController>(
                builder: (context, controller, _) {
                  final items = controller.colors;

                  if (items.isEmpty) {
                    return Center(
                      child: SingleChildScrollView(
                        child: SearchEmptyState(
                          message:
                              l10n?.noMatchingColors ?? 'No matching colors',
                          actions: [
                            TextButton(
                              onPressed: () {
                                _resetScroll();
                                controller.clearSearch();
                              },
                              child: Text(l10n?.clearSearch ?? 'Clear search'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    controller: _scrollController,
                    addAutomaticKeepAlives: false,
                    padding: const EdgeInsets.fromLTRB(15.0, 6.0, 15.0, 15.0),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
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
                      final heroTag = 'collection_${item.name}';

                      return ColorGridCard(
                        item: item,
                        heroTag: heroTag,
                        onTap: () => openWallpaperConfirmation(
                          context,
                          item: item,
                          heroTag: heroTag,
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
