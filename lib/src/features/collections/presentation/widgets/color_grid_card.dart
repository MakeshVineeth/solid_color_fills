import 'package:flutter/material.dart';
import 'package:solid_color_fills/src/core/constants/app_constants.dart';
import 'package:solid_color_fills/src/core/widgets/scale_bounce.dart';
import 'package:solid_color_fills/src/features/collections/domain/entities/solid_color_item.dart';

/// Card displaying an inset solid color swatch with its title and micro-bounce interaction.
/// Faithful to the original elevated card aesthetic with framed rounded corners.
class ColorGridCard extends StatelessWidget {
  final SolidColorItem item;
  final String heroTag;
  final VoidCallback onTap;

  const ColorGridCard({
    super.key,
    required this.item,
    required this.heroTag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleBounce(
      child: Hero(
        tag: heroTag,
        child: Card(
          shape: AppConstants.roundShape,
          elevation: 3.0,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppConstants.cardRadius,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 2.0),
                    child: ClipRRect(
                      borderRadius: AppConstants.cardRadius,
                      child: ColoredBox(color: item.color),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 6.0,
                  ),
                  child: Text(
                    item.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
