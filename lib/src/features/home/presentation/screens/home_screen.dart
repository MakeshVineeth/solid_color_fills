import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solid_color_fills/l10n/app_localizations.dart';
import 'package:solid_color_fills/src/core/constants/app_constants.dart';
import 'package:solid_color_fills/src/core/storage/preferences_service.dart';
import 'package:solid_color_fills/src/core/widgets/convex_navigation_bar.dart';
import 'package:solid_color_fills/src/core/widgets/fade_indexed_stack.dart';
import 'package:solid_color_fills/src/core/widgets/floating_modal_sheet.dart';
import 'package:solid_color_fills/src/features/collections/presentation/screens/collections_screen.dart';
import 'package:solid_color_fills/src/features/color_picker/presentation/screens/color_picker_screen.dart';
import 'package:solid_color_fills/src/features/feed/presentation/screens/feed_screen.dart';
import 'package:solid_color_fills/src/features/settings/presentation/dialogs/menu_bottom_sheet.dart';
import 'package:solid_color_fills/src/features/shortcuts/services/quick_actions_service.dart';

/// Main navigation shell housing the Collections, Color Picker, and Feed tabs.
/// Uses pure-Flutter ConvexNavigationBar faithful to the original design.
class HomeScreen extends StatefulWidget {
  final PreferencesService preferencesService;
  final int? initialTabIndex;

  const HomeScreen({
    super.key,
    required this.preferencesService,
    this.initialTabIndex,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  bool _hasUserSelectedTab = false;
  late final QuickActionsService _quickActionsService;

  final List<Widget> _screens = const [
    CollectionsScreen(),
    ColorPickerScreen(),
    FeedScreen(),
  ];

  @override
  void initState() {
    super.initState();
    final initialTab = widget.initialTabIndex;
    if (initialTab != null) {
      _currentIndex = initialTab.clamp(0, _screens.length - 1);
    } else {
      _currentIndex = 0;
      unawaited(_loadInitialTab());
    }
    _initServices();
  }

  Future<void> _loadInitialTab() async {
    final savedIndex = await widget.preferencesService.getTabIndex();
    if (mounted &&
        !_hasUserSelectedTab &&
        savedIndex >= 0 &&
        savedIndex < _screens.length) {
      setState(() => _currentIndex = savedIndex);
    }
  }

  void _initServices() {
    _quickActionsService = QuickActionsService(
      onShortcutSelected: (index) {
        if (mounted && index >= 0 && index < _screens.length) {
          _onTabChanged(index);
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _quickActionsService.initialize();
      }
    });
  }

  @override
  void dispose() {
    _quickActionsService.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    _hasUserSelectedTab = true;

    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
      unawaited(widget.preferencesService.setTabIndex(index));
    }
  }

  void _openSettingsMenu(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    unawaited(
      showFloatingModalBottomSheet<void>(
        context: context,
        builder: (_) => const MenuBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final bottomBarBg = isDark ? Colors.grey[900]! : Colors.white;
    final bottomBarElevation = isDark ? 10.0 : 3.0;
    final overlayBrightness = isDark ? Brightness.light : Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: bottomBarBg,
        systemNavigationBarIconBrightness: overlayBrightness,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: overlayBrightness,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n?.appTitle ?? AppConstants.appName),
          actions: [
            IconButton(
              icon: const Icon(FluentIcons.navigation_24_regular),
              tooltip: 'Settings & Options',
              onPressed: () => _openSettingsMenu(context),
            ),
          ],
        ),
        body: FadeIndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: ConvexNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: bottomBarBg,
          color: primaryColor,
          activeColor: primaryColor,
          elevation: bottomBarElevation,
          height:
              (MediaQuery.orientationOf(context) == Orientation.portrait)
                  ? 60
                  : 55,
          items: [
            ConvexTabItem(
              icon: FluentIcons.collections_24_regular,
              title: l10n?.collections ?? 'Collections',
            ),
            ConvexTabItem(
              icon: FluentIcons.color_24_regular,
              title: l10n?.colorPicker ?? 'Color Picker',
            ),
            ConvexTabItem(
              icon: Icons.all_inclusive_outlined,
              title: l10n?.feed ?? 'Feed',
            ),
          ],
          onTap: _onTabChanged,
        ),
      ),
    );
  }
}
