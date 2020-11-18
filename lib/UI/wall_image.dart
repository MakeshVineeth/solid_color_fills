import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:solid_color_fill/UI/database/main_image_functions.dart';
import 'package:solid_color_fill/fixedValues.dart';

class WallImage extends ConsumerWidget {
  final FixedValues fixedValues = FixedValues();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    AsyncValue<Uint8List> imageObject = watch(imageProvision);

    return imageObject.when(
      loading: () => Center(child: const CircularProgressIndicator()),
      error: (err, stack) => Center(child: const CircularProgressIndicator()),
      data: (value) => FadeIn(
        child: Image.memory(
          value,
        ),
      ),
    );
  }
}
