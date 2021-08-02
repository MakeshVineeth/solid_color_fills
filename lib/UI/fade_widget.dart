import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class FadeWidget extends StatefulWidget {
  final Widget child;

  const FadeWidget({@required this.child}) : assert(child != null);

  @override
  _FadeWidgetState createState() => _FadeWidgetState();
}

class _FadeWidgetState extends State<FadeWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();

    return FadeScaleTransition(
      animation: _animationController,
      child: widget.child,
    );
  }
}
