import 'dart:ui';
import 'package:flutter/material.dart';

/// Displays an animated dialog with smooth backdrop blur and scale-fade entrance animation.
Future<T?> showAnimatedDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (buildContext, animation, secondaryAnimation) =>
        builder(buildContext),
    transitionBuilder: (context, animation, secondaryAnimation, child) =>
        _AnimatedDialogTransition(
      animation: animation,
      child: child,
    ),
  );
}

class _AnimatedDialogTransition extends StatefulWidget {
  final Animation<double> animation;
  final Widget child;

  const _AnimatedDialogTransition({
    required this.animation,
    required this.child,
  });

  @override
  State<_AnimatedDialogTransition> createState() =>
      _AnimatedDialogTransitionState();
}

class _AnimatedDialogTransitionState extends State<_AnimatedDialogTransition> {
  late CurvedAnimation _curved;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _curved = CurvedAnimation(
      parent: widget.animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _scale = Tween<double>(begin: 0.92, end: 1.0).animate(_curved);
  }

  @override
  void didUpdateWidget(_AnimatedDialogTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animation != oldWidget.animation) {
      _curved.dispose();
      _initAnimations();
    }
  }

  @override
  void dispose() {
    _curved.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: widget.animation,
          builder: (context, _) {
            final sigma = 5.0 * widget.animation.value;
            if (sigma < 0.05) {
              return const SizedBox.shrink();
            }
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
              child: const SizedBox.expand(),
            );
          },
        ),
        FadeTransition(
          opacity: _curved,
          child: ScaleTransition(
            scale: _scale,
            child: RepaintBoundary(child: widget.child),
          ),
        ),
      ],
    );
  }
}
