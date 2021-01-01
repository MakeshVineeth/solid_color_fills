import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:solid_color_fill/UI/database/main_image_functions.dart';
import 'package:solid_color_fill/fixedValues.dart';
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
          child: Image.memory(imageObject?.data?.value ?? kTransparentImage)),
      secondChild: containerCustom(
          child: Center(child: const CircularProgressIndicator())),
    );
  }

  Widget containerCustom({@required Widget child}) {
    return Container(
      padding: EdgeInsets.all(8),
      height: constraints.maxHeight / 1.5,
      child: ClipRRect(
        borderRadius: fixedValues.fixedCardRadius,
        child: child,
      ),
    );
  }
}
