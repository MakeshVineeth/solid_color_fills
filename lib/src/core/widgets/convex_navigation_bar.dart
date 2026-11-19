import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Descriptor for a single tab inside [ConvexNavigationBar].
class ConvexTabItem {
  final IconData icon;
  final String title;

  const ConvexTabItem({
    required this.icon,
    required this.title,
  });
}

/// Pure-Flutter convex bottom navigation bar with a floating active circular bump.
/// Matches the original visual style without legacy Dart 2 package dependencies.
class ConvexNavigationBar extends StatefulWidget {
  final List<ConvexTabItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color backgroundColor;
  final Color color;
  final Color activeColor;
  final double elevation;
  final double height;
  final Curve curve;

  const ConvexNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.backgroundColor,
    required this.color,
    required this.activeColor,
    this.elevation = 3.0,
    this.height = 60.0,
    this.curve = Curves.linear,
  });

  @override
  State<ConvexNavigationBar> createState() => _ConvexNavigationBarState();
}

class _ConvexNavigationBarState extends State<ConvexNavigationBar>
    with SingleTickerProviderStateMixin {
  static const double _convexSize = 80.0;
  static const double _curveTop = -25.0;
  static const double _activeCircleSize = 60.0;

  late final AnimationController _controller;
  late Animation<double> _percentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _percentAnimation = AlwaysStoppedAnimation<double>(
      _tabCenterPercent(widget.currentIndex),
    );
  }

  double _tabCenterPercent(int index) {
    if (widget.items.isEmpty) {
      return 0.5;
    }
    return (2 * index + 1) / (2 * widget.items.length);
  }

  @override
  void didUpdateWidget(ConvexNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex ||
        widget.items.length != oldWidget.items.length) {
      final begin = _percentAnimation.value;
      final end = _tabCenterPercent(widget.currentIndex);
      _percentAnimation = Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(parent: _controller, curve: widget.curve),
      );
      unawaited(_controller.forward(from: 0));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = math.max(MediaQuery.of(context).padding.bottom, 0.0);
    final totalHeight = widget.height + bottomPadding;
    final textDirection = Directionality.of(context);
    final count = widget.items.length;
    final baseDx = count > 1 ? widget.currentIndex / (count - 1) : 0.0;
    final dx = textDirection == TextDirection.rtl ? 1.0 - baseDx : baseDx;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: totalHeight,
          width: double.infinity,
          child: CustomPaint(
            painter: _ConvexBarPainter(
              top: _curveTop,
              width: _convexSize,
              height: _convexSize,
              color: widget.backgroundColor,
              shadowColor: Colors.black38,
              sigma: widget.elevation,
              leftPercent: _percentAnimation,
              textDirection: textDirection,
            ),
          ),
        ),
        Container(
          height: totalHeight,
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Row(
            children: [
              for (var i = 0; i < count; i++)
                if (i == widget.currentIndex)
                  const Expanded(child: SizedBox.shrink())
                else
                  _InactiveTabSlot(
                    item: widget.items[i],
                    color: widget.color,
                    onTap: () => widget.onTap(i),
                  ),
            ],
          ),
        ),
        Positioned.fill(
          top: _curveTop,
          bottom: bottomPadding,
          child: FractionallySizedBox(
            widthFactor: count > 0 ? 1 / count : 1.0,
            alignment: FractionalOffset(dx, 0),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => widget.onTap(widget.currentIndex),
              child: Center(
                child: TweenAnimationBuilder<double>(
                  key: ValueKey(widget.currentIndex),
                  tween: Tween<double>(begin: 0.85, end: 1.0),
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) =>
                      Transform.scale(scale: scale, child: child),
                  child: Container(
                    width: _activeCircleSize,
                    height: _activeCircleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.activeColor,
                    ),
                    child: Icon(
                      widget.items[widget.currentIndex].icon,
                      size: 28,
                      color: widget.backgroundColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InactiveTabSlot extends StatelessWidget {
  final ConvexTabItem item;
  final Color color;
  final VoidCallback onTap;

  const _InactiveTabSlot({
    required this.item,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 24, color: color),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: color, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConvexBarPainter extends CustomPainter {
  final double top;
  final double width;
  final double height;
  final Animation<double> leftPercent;
  final TextDirection textDirection;
  final double sigma;
  final Paint _paint;
  final Paint _shadowPaint;

  _ConvexBarPainter({
    required this.top,
    required this.width,
    required this.height,
    required Color color,
    required Color shadowColor,
    required this.sigma,
    required this.leftPercent,
    required this.textDirection,
  })  : _paint = Paint()..color = color,
        _shadowPaint = Paint()
          ..color = shadowColor
          ..maskFilter =
              sigma > 0 ? MaskFilter.blur(BlurStyle.outer, sigma) : null,
        super(repaint: leftPercent);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) {
      return;
    }
    final host = Rect.fromLTWH(0, 0, size.width, size.height);
    final percent = textDirection == TextDirection.rtl
        ? (1.0 - leftPercent.value)
        : leftPercent.value;
    final guest = Rect.fromLTWH(
      size.width * percent - width / 2.0,
      top,
      width,
      height,
    );
    final path = _buildConvexPath(host, guest);
    if (sigma > 0) {
      canvas.drawPath(path, _shadowPaint);
    }
    canvas.drawPath(path, _paint);
  }

  Path _buildConvexPath(Rect host, Rect guest) {
    if (!host.overlaps(guest)) {
      return Path()..addRect(host);
    }

    final notchRadius = guest.width / 2.0;
    const s1 = 15.0;
    const s2 = 1.0;

    final r = notchRadius;
    final a = -1.0 * r - s2;
    final b = host.top - guest.center.dy;
    final denom = a * a + b * b;
    final discriminant = b * b * r * r * (denom - r * r);
    if (denom == 0 || discriminant < 0) {
      return Path()..addRect(host);
    }

    final n2 = math.sqrt(discriminant);
    final p2xA = ((a * r * r) - n2) / denom;
    final p2xB = ((a * r * r) + n2) / denom;
    final p2yA = -math.sqrt(math.max(0.0, r * r - p2xA * p2xA));
    final p2yB = -math.sqrt(math.max(0.0, r * r - p2xB * p2xB));

    final cmp = b < 0 ? -1.0 : 1.0;
    final chosenP2 =
        cmp * p2yA > cmp * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);

    final p = [
      Offset(a - s1, b) + guest.center,
      Offset(a, b) + guest.center,
      chosenP2 + guest.center,
      Offset(-chosenP2.dx, chosenP2.dy) + guest.center,
      Offset(-a, b) + guest.center,
      Offset(-(a - s1), b) + guest.center,
    ];

    return Path()
      ..moveTo(host.left, host.top)
      ..lineTo(p[0].dx, p[0].dy)
      ..quadraticBezierTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy)
      ..arcToPoint(
        p[3],
        radius: Radius.circular(notchRadius),
        clockwise: true,
      )
      ..quadraticBezierTo(p[4].dx, p[4].dy, p[5].dx, p[5].dy)
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }

  @override
  bool shouldRepaint(_ConvexBarPainter oldDelegate) {
    return oldDelegate.leftPercent.value != leftPercent.value ||
        oldDelegate._paint.color != _paint.color ||
        oldDelegate.textDirection != textDirection ||
        oldDelegate.sigma != sigma;
  }
}
