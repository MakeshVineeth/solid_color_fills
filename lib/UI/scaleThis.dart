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
  final dur = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: dur,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCirc,
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
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
