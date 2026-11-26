import 'dart:async';

import 'package:flutter/material.dart';

/// Smooth fading indexed stack with lazy tab activation on first visit.
class FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const FadeIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  State<FadeIndexedStack> createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late List<bool> _activated;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 1.0,
    );
    _activated = List<bool>.generate(
      widget.children.length,
      (i) => i == widget.index,
    );
  }

  @override
  void didUpdateWidget(FadeIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children.length != _activated.length) {
      final oldActivated = _activated;
      _activated = List<bool>.generate(
        widget.children.length,
        (i) => (i < oldActivated.length && oldActivated[i]) || i == widget.index,
      );
    } else if (widget.index >= 0 && widget.index < _activated.length) {
      _activated[widget.index] = true;
    }

    if (widget.index != oldWidget.index) {
      unawaited(_controller.forward(from: 0.0));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: IndexedStack(
        index: widget.index,
        children: [
          for (var i = 0; i < widget.children.length; i++)
            _activated[i] ? widget.children[i] : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
