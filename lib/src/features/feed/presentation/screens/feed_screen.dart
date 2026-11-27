import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solid_color_fills/l10n/app_localizations.dart';
import 'package:solid_color_fills/src/core/widgets/minimal_search_bar.dart';
import 'package:solid_color_fills/src/core/widgets/search_empty_state.dart';
import 'package:solid_color_fills/src/features/collections/presentation/widgets/color_grid_card.dart';
import 'package:solid_color_fills/src/features/feed/presentation/controllers/feed_controller.dart';
import 'package:solid_color_fills/src/features/wallpaper/presentation/utils/wallpaper_navigation.dart';

/// Screen displaying a searchable infinite feed of randomly generated solid colors.
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
      if (!mounted || !_scrollController.hasClients) return;
      final controller = context.read<FeedController>();
      if (!controller.isSearching &&
          controller.hasMore &&
          _scrollController.position.maxScrollExtent < 100) {
        controller.loadMore(20);
      }
    });
  }

  void _resetScroll() {
    if (_scrollController.hasClients && _scrollController.offset > 0) {
      _scrollController.jumpTo(0);
    }
  }

  void _onScroll() {
    if (_isLoadingMore || !_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 400) return;
    final controller = context.read<FeedController>();
    if (controller.isSearching || !controller.hasMore) return;

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 6),
          child: Selector<FeedController, String>(
            selector: (_, c) => c.searchQuery,
            builder: (context, query, _) => MinimalSearchBar(
              initialQuery: query,
              hintText: l10n?.searchFeed ?? 'Search feed...',
              clearTooltip: l10n?.clearSearch ?? 'Clear search',
              onChanged: (value) {
                _resetScroll();
                context.read<FeedController>().setSearchQuery(value);
              },
              onClear: () {
                _resetScroll();
                context.read<FeedController>().clearSearch();
              },
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount =
                  adaptiveColorGridCrossAxisCount(constraints.maxWidth);

              return Consumer<FeedController>(
                builder: (context, controller, _) {
                  final items = controller.colors;

                  if (items.isEmpty && controller.isSearching) {
                    return RefreshIndicator(
                      onRefresh: () async => controller.refresh(),
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: SearchEmptyState(
                              message:
                                  l10n?.noMatchingColors ?? 'No matching colors',
                              actions: [
                                if (controller.hasMore)
                                  TextButton(
                                    onPressed: () => controller.loadMore(40),
                                    child: Text(l10n?.loadMore ?? 'Load more'),
                                  ),
                                TextButton(
                                  onPressed: () {
                                    _resetScroll();
                                    controller.clearSearch();
                                  },
                                  child:
                                      Text(l10n?.clearSearch ?? 'Clear search'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async => controller.refresh(),
                          child: GridView.builder(
                            controller: _scrollController,
                            addAutomaticKeepAlives: false,
                            padding: const EdgeInsets.fromLTRB(
                              15.0,
                              6.0,
                              15.0,
                              15.0,
                            ),
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: isPortrait ? 0.70 : 1.2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              final heroTag = 'feed_${identityHashCode(item)}';

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
                          ),
                        ),
                      ),
                      if (controller.isSearching && controller.hasMore)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                            ),
                            onPressed: () => controller.loadMore(40),
                            child: Text(l10n?.loadMore ?? 'Load more'),
                          ),
                        ),
                    ],
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
