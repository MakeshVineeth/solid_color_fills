import 'dart:async';

import 'package:flutter/material.dart';
import 'package:solid_color_fills/src/core/storage/preferences_service.dart';
import 'package:solid_color_fills/src/core/utils/platform_utils.dart';
import 'package:solid_color_fills/src/features/home/presentation/screens/home_screen.dart';
import 'package:solid_color_fills/src/features/onboarding/presentation/screens/onboarding_screen.dart';

/// Routes user to either Onboarding or HomeScreen based on first launch flag.
class WrapperScreen extends StatefulWidget {
  final PreferencesService preferencesService;
  final bool? initialShowOnboarding;
  final int? initialTabIndex;

  const WrapperScreen({
    super.key,
    required this.preferencesService,
    this.initialShowOnboarding,
    this.initialTabIndex,
  });

  @override
  State<WrapperScreen> createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<WrapperScreen> {
  late bool _isLoading;
  late bool _showOnboarding;

  @override
  void initState() {
    super.initState();
    if (widget.initialShowOnboarding != null) {
      _showOnboarding = widget.initialShowOnboarding!;
      _isLoading = false;
    } else {
      _showOnboarding = true;
      _isLoading = true;
      unawaited(_checkFirstLaunch());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(PlatformUtils.optimizeDisplayRefreshRate());
    });
  }

  Future<void> _checkFirstLaunch() async {
    final firstLaunch = await widget.preferencesService.isFirstLaunch();
    if (mounted) {
      setState(() {
        _showOnboarding = firstLaunch;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: _showOnboarding
            ? OnboardingScreen(
                preferencesService: widget.preferencesService,
                onCompleted: () => setState(() => _showOnboarding = false),
              )
            : HomeScreen(
                preferencesService: widget.preferencesService,
                initialTabIndex: widget.initialTabIndex,
              ),
      ),
    );
  }
}
