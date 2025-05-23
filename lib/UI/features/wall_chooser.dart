import 'package:wallpaper_manager_plus/wallpaper_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solid_color_fills/UI/features/wall_image.dart';
import 'package:solid_color_fills/database/commons.dart';
import 'package:solid_color_fills/database/main_image_functions.dart';
import 'package:solid_color_fills/fixed_values.dart';
import '../../database/helper_functions.dart';

class WallChooser extends ConsumerWidget {
  final FixedValues fixedValues = FixedValues();
  final String heroTag;

  WallChooser({super.key, required this.heroTag});

  final Map<String, int> buttons = {
    'Set As Home Screen': WallpaperManagerPlus.homeScreen,
    'Set As Lock Screen': WallpaperManagerPlus.lockScreen,
    'Set As Both': WallpaperManagerPlus.bothScreens,
    'Open in Gallery': 4,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final object = ref.read(commonProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Wallpaper Confirmation')),
      body: LayoutBuilder(
        builder:
            (context, constraints) => ListView(
              physics: AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              cacheExtent: 2000,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Hero(
                            tag: heroTag,
                            child: colorWall(constraints: constraints),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Color Info: ${object.colorTitle}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            width:
                                MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                    ? constraints.maxWidth / 2
                                    : constraints.maxWidth / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: List.generate(
                                buttons.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 3,
                                  ),
                                  child: ElevatedButton(
                                    onPressed:
                                        () => setImage(
                                          context,
                                          buttons.entries
                                              .elementAt(index)
                                              .value,
                                          ref,
                                        ),
                                    child: IgnorePointer(
                                      child: Text(
                                        buttons.entries.elementAt(index).key,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Note: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.labelLarge!.color,
                              ),
                              children: const <TextSpan>[
                                TextSpan(
                                  text:
                                      'Use the Open in Gallery option if you\'re having troubles changing the lock screen wallpaper.',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget colorWall({required BoxConstraints constraints}) => Card(
    shape: fixedValues.roundShape,
    elevation: 3,
    child: InkWell(
      onTap: () {},
      borderRadius: fixedValues.fixedCardRadius,
      child: IgnorePointer(child: WallImage(constraints: constraints)),
    ),
  );

  Future<void> setImage(
    BuildContext context,
    int location,
    WidgetRef ref,
  ) async {
    try {
      ScaffoldMessenger.of(
        context,
      ).hideCurrentSnackBar(); // Hide existing snack bars if present.

      final SetImage setImageClass = ref.watch(imageSetter);
      setImageClass.setNow(location: location).then((val) {
        // If location is 4, means to open the gallery, no need to display message.
        if (location == 4) return;

        String outputMessage;

        if (val) {
          outputMessage =
              'Yay! Wallpaper set for ${wallpaperLocationText(location)}';
          askForReview(action: true);
        } else {
          outputMessage = 'Oops, An error has occurred!';
        }

        final SnackBar snackBar = SnackBar(
          content: Text(
            outputMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  context.mounted
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          elevation: 6.0,
          shape: fixedValues.roundShape,
          backgroundColor:
              context.mounted ? Theme.of(context).primaryColor : Colors.black,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } catch (_) {}
  }
}
