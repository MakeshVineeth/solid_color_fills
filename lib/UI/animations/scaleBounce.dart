import 'package:flutter/material.dart';

class ScaleBounce extends StatefulWidget {
  final Widget child;

  const ScaleBounce({@required this.child}) : assert(child != null);

  @override
  _ScaleBounceState createState() => _ScaleBounceState();
}

class _ScaleBounceState extends State<ScaleBounce>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  final dur = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: dur,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = dur;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
