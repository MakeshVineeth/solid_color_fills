import 'dart:async';

import 'package:flutter/material.dart';

/// Micro-interaction scale bounce effect on press with lazy animation allocation.
class ScaleBounce extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double scaleFactor;

  const ScaleBounce({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 120),
    this.scaleFactor = 0.96,
  });

  @override
  State<ScaleBounce> createState() => _ScaleBounceState();
}

class _ScaleBounceState extends State<ScaleBounce>
    with SingleTickerProviderStateMixin {
  static const Animation<double> _identityScale =
      AlwaysStoppedAnimation<double>(1.0);

  AnimationController? _controller;
  CurvedAnimation? _curvedAnimation;
  Animation<double>? _scaleAnimation;

  void _ensureController() {
    if (_controller != null) return;
    final controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    final curved = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
    _controller = controller;
    _curvedAnimation = curved;
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(curved);
    setState(() {});
  }

  @override
  void didUpdateWidget(ScaleBounce oldWidget) {
    super.didUpdateWidget(oldWidget);
    final controller = _controller;
    if (controller == null) return;

    if (widget.duration != oldWidget.duration) {
      controller.duration = widget.duration;
    }
    if (widget.scaleFactor != oldWidget.scaleFactor && _curvedAnimation != null) {
      _scaleAnimation = Tween<double>(
        begin: 1.0,
        end: widget.scaleFactor,
      ).animate(_curvedAnimation!);
    }
  }

  @override
  void dispose() {
    _curvedAnimation?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaleAnimation = _scaleAnimation;
    return Listener(
      onPointerDown: (_) {
        _ensureController();
        unawaited(_controller!.forward());
      },
      onPointerUp: (_) {
        final controller = _controller;
        if (controller != null) {
          unawaited(controller.reverse());
        }
      },
      onPointerCancel: (_) {
        final controller = _controller;
        if (controller != null) {
          unawaited(controller.reverse());
        }
      },
      child: ScaleTransition(
        scale: scaleAnimation ?? _identityScale,
        child: widget.child,
      ),
    );
  }
}
