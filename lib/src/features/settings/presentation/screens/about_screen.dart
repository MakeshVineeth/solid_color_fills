import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:solid_color_fills/src/core/constants/app_constants.dart';
import 'package:solid_color_fills/src/core/constants/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';

/// Blurred AlertDialog showing app info, links, Privacy Policy, and license viewer.
/// Faithful to original AboutPage layout and Play Store screenshot.
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  static String? _cachedVersion;

  late String _versionInfo = _cachedVersion ?? '2.1.0';

  @override
  void initState() {
    super.initState();
    if (_cachedVersion == null) {
      unawaited(_loadPackageInfo());
    }
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (info.version.isNotEmpty) {
        _cachedVersion = info.version;
        if (mounted) {
          setState(() => _versionInfo = info.version);
        }
      }
    } catch (_) {}
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.scheme != 'https') {
      return;
    }
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(uri);
      }
    } catch (_) {
      try {
        await launchUrl(uri);
      } catch (_) {}
    }
  }

  Widget _buildAppIcon(BuildContext context) {
    final cacheWidth = (30 * MediaQuery.devicePixelRatioOf(context)).round();
    return Image.asset(
      AppConstants.logoAsset,
      width: 30,
      cacheWidth: cacheWidth,
      errorBuilder: (_, __, ___) => const Icon(Icons.wallpaper, size: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: AppConstants.roundShape,
      buttonPadding: const EdgeInsets.all(10.0),
      actions: [
        _DialogActionBtn(
          title: 'PRIVACY POLICY',
          onPressed: () => unawaited(_launchUrl(AppConstants.privacyPolicyUrl)),
        ),
        _DialogActionBtn(
          title: 'VIEW LICENSES',
          onPressed: () => showLicensePage(
            context: context,
            applicationName: AppConstants.appName,
            applicationVersion: _versionInfo,
            applicationLegalese: AppStrings.appLegalese,
            applicationIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildAppIcon(context),
            ),
          ),
        ),
      ],
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppIcon(context),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                      height: 1,
                    ),
                  ),
                  Text(_versionInfo),
                  const SizedBox(height: 20),
                  const Text(AppStrings.appLegalese),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _LinkButton(
                          title: 'Play Store',
                          icon: Icons.shop_outlined,
                          backgroundColor: const Color(0xFF078C30),
                          onPressed: () =>
                              unawaited(_launchUrl(AppConstants.playStoreUrl)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _LinkButton(
                          title: 'GitHub',
                          icon: Icons.code_outlined,
                          backgroundColor: const Color(0xFF24292E),
                          onPressed: () =>
                              unawaited(_launchUrl(AppConstants.githubRepoUrl)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const _LinkButton({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(backgroundColor),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        overlayColor: WidgetStateProperty.all(Colors.white10),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        ),
      ),
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          maxLines: 1,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _DialogActionBtn extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _DialogActionBtn({
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(AppConstants.roundShape),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          title,
          textAlign: TextAlign.end,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
