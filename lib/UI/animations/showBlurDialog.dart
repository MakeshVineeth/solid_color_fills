import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:solid_color_fills/fixedValues.dart';

class BlurredWindow extends StatefulWidget {
  final Widget child;

  const BlurredWindow({@required this.child}) : assert(child != null);

  @override
  _BlurredWindowState createState() => _BlurredWindowState();
}

class _BlurredWindowState extends State<BlurredWindow> {
  double _currentOpacity = 0;
  final Duration duration = const Duration(milliseconds: 1000);
  Widget _currentChild;
  final FixedValues _fixedValues = FixedValues();

  @override
  void initState() {
    super.initState();

    if (mounted)
      setState(() {
        _currentOpacity = 1;
        _currentChild = BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: _fixedValues.sigmaLevel, sigmaY: _fixedValues.sigmaLevel),
          child: widget.child,
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => AnimatedOpacity(
        key: UniqueKey(),
        opacity: _currentOpacity,
        duration: duration,
        child: GestureDetector(
          onTap: () => Navigator.of(context, rootNavigator: true).pop(),
          child: AnimatedContainer(
            key: UniqueKey(),
            duration: duration,
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                child: Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: Center(child: _currentChild))),
          ),
        ),
      ),
    );
  }
}

Future<void> showBlurDialog(
        {@required BuildContext context, @required Widget child}) =>
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (context) => BlurredWindow(
        child: child,
      ),
    );
