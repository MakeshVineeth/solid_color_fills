import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:solid_color_fill/UI/database/main_image_functions.dart';
import 'package:solid_color_fill/fixedValues.dart';

class WallImage extends ConsumerWidget {
  final FixedValues fixedValues = FixedValues();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    AsyncValue<Uint8List> imageObject = watch(imageProvision);

    return imageObject.when(
      loading: () => const Text('Loading...'),
      error: (err, stack) => const Text('Loading...'),
      data: (value) => Image.memory(value),
    );
  }
}
