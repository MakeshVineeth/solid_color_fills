import 'package:flutter/material.dart';

class ScaleThis extends StatefulWidget {
  final Widget child;

  ScaleThis({@required this.child});

  @override
  _ScaleThisState createState() => _ScaleThisState();
}

class _ScaleThisState extends State<ScaleThis> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();

    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
