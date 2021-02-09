import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:solid_color_fills/UI/database/main_image_functions.dart';
import 'package:solid_color_fills/fixedValues.dart';
import 'package:transparent_image/transparent_image.dart';

class WallImage extends ConsumerWidget {
  final FixedValues fixedValues = FixedValues();
  final BoxConstraints constraints;

  WallImage({@required this.constraints});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    AsyncValue<Uint8List> imageObject = watch(imageProvision);

    return AnimatedCrossFade(
        duration: const Duration(milliseconds: 800),
        crossFadeState: imageObject.when(
          data: (data) => CrossFadeState.showFirst,
          loading: () => CrossFadeState.showSecond,
          error: (obj, err) => CrossFadeState.showSecond,
        ),
        firstChild: containerCustom(
          context: context,
          child: Image.memory(
            imageObject?.data?.value ?? kTransparentImage,
            fit: BoxFit.fill,
          ),
        ),
        secondChild: containerCustom(
          context: context,
          child: Center(
            child: const CircularProgressIndicator(),
          ),
        ));
  }

  Widget containerCustom(
      {@required Widget child, @required BuildContext context}) {
    bool isHorizontal =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isHorizontal)
      return Container(
        padding: const EdgeInsets.all(8),
        width: 300,
        height: constraints.maxHeight / 2,
        child: ClipRRect(
          borderRadius: fixedValues.fixedCardRadius,
          child: child,
        ),
      );
    else
      return Container(
        padding: const EdgeInsets.all(8),
        width: constraints.maxWidth / 2,
        height: constraints.maxHeight / 2,
        child: ClipRRect(
          borderRadius: fixedValues.fixedCardRadius,
          child: child,
        ),
      );
  }
}
