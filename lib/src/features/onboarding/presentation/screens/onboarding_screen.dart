import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solid_color_fills/src/core/constants/app_constants.dart';
import 'package:solid_color_fills/src/core/storage/preferences_service.dart';
import 'package:solid_color_fills/src/core/widgets/responsive_wrapper.dart';

/// Clean, responsive onboarding tutorial faithful to original IntroScreen.
class OnboardingScreen extends StatefulWidget {
  final PreferencesService preferencesService;
  final VoidCallback onCompleted;

  const OnboardingScreen({
    super.key,
    required this.preferencesService,
    required this.onCompleted,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_TutorialPageData> _pages = const [
    _TutorialPageData(
      title: 'Welcome to Solid Color Fills',
      description: 'Click Next to proceed to the Tutorial or you can skip it now.',
      imagePath: 'assets/logo.png',
      isLogo: true,
    ),
    _TutorialPageData(
      title: 'Cherry-Picked Colors.',
      description:
          'You can choose from a variety of cherry-picked colors available on Collections Tab.',
      imagePath: 'assets/Tut_1.png',
    ),
    _TutorialPageData(
      title: 'Set as Wallpaper',
      description:
          'Click on any Color to open the Wall Chooser, where you can set the Color as your Lockscreen or Homescreen Wallpaper',
      imagePath: 'assets/Tut_2.png',
    ),
    _TutorialPageData(
      title: 'Select a Material Tone',
      description:
          'Not satisfied with the default collections? You can choose your own tone from the Material Color Picker available in Color Picker Tab.',
      imagePath: 'assets/Tut_3.png',
    ),
    _TutorialPageData(
      title: 'Advanced Color Picker',
      description:
          'Feeling little bored? You can play around with the Advanced Color Picker included in the app.',
      imagePath: 'assets/Tut_4.png',
    ),
  ];

  Future<void> _finishOnboarding() async {
    await widget.preferencesService.setFirstLaunchCompleted();
    widget.onCompleted();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentIndex == _pages.length - 1;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconBrightness = isDark ? Brightness.light : Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: isDark ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness: iconBrightness,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: iconBrightness,
      ),
      child: Scaffold(
      body: SafeArea(
        child: ResponsiveWrapper(
          maxWidth: 600,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextButton(
                    onPressed: _finishOnboarding,
                    child: const Text(
                      'Skip',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (idx) => setState(() => _currentIndex = idx),
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Center(
                              child: page.isLogo
                                  ? Image.asset(
                                      page.imagePath,
                                      height: 120,
                                      fit: BoxFit.contain,
                                    )
                                  : Container(
                                      constraints: const BoxConstraints(maxHeight: 280),
                                      decoration: BoxDecoration(
                                        borderRadius: AppConstants.cardRadius,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.12),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        page.imagePath,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              page.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.5,
                                height: 1.4,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withValues(alpha: 0.75),
                              ),
                            ),
                          ),
                          const Spacer(flex: 1),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Dot indicators
                    Row(
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: AppConstants.shortAnimationDuration,
                          margin: const EdgeInsets.only(right: 6),
                          height: 8,
                          width: _currentIndex == index ? 22 : 8,
                          decoration: BoxDecoration(
                            color: _currentIndex == index
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    // Next / Done button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: AppConstants.roundShape,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        elevation: 2.0,
                      ),
                      onPressed: () {
                        if (isLastPage) {
                          _finishOnboarding();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.decelerate,
                          );
                        }
                      },
                      child: Text(
                        isLastPage ? 'Done' : 'Next',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

class _TutorialPageData {
  final String title;
  final String description;
  final String imagePath;
  final bool isLogo;

  const _TutorialPageData({
    required this.title,
    required this.description,
    required this.imagePath,
    this.isLogo = false,
  });
}
