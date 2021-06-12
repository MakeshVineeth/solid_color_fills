import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solid_color_fills/UI/alertMsg.dart';
import 'package:solid_color_fills/UI/database/commons.dart';
import 'package:solid_color_fills/UI/database/main_image_functions.dart';
import 'package:solid_color_fills/UI/wall_image.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:solid_color_fills/fixedValues.dart';
import 'package:system_properties/system_properties.dart';

class WallChooser extends ConsumerWidget {
  final SnackBar snackBarSuccess =
      SnackBar(content: Text('Yay! Wallpaper Successfully Set.'));
  final SnackBar snackBarError =
      SnackBar(content: Text('Oops, An Error has Occurred!'));
  final FixedValues fixedValues = FixedValues();

  final Map<String, int> buttons = {
    'Set As Home Screen': WallpaperManager.HOME_SCREEN,
    'Set As Lock Screen': WallpaperManager.LOCK_SCREEN,
    'Set As Both': WallpaperManager.BOTH_SCREENS,
    'Open in Gallery': 4,
  };

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final object = context.read(commonProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Wallpaper Confirmation')),
      body: LayoutBuilder(
        builder: (context, constraints) => ListView(
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          cacheExtent: 2000,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      colorWall(constraints: constraints),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Color Info: ' + object.colorTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? constraints.maxWidth / 2
                            : constraints.maxWidth / 3,
                        child: Column(
                          children: List.generate(
                              buttons.length,
                              (index) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => setImage(
                                            context,
                                            buttons.entries
                                                .elementAt(index)
                                                .value),
                                        child: IgnorePointer(
                                          child: Text(
                                            buttons.entries
                                                .elementAt(index)
                                                .key,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  )),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Note: Use the Open in Gallery option if you\'re having troubles changing the lock screen wallpaper.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget colorWall({@required BoxConstraints constraints}) {
    return Card(
      shape: fixedValues.roundShape,
      elevation: 3,
      child: InkWell(
        onTap: () {},
        borderRadius: fixedValues.fixedCardRadius,
        child: IgnorePointer(child: WallImage(constraints: constraints)),
      ),
    );
  }

  void setImage(BuildContext context, int location) async {
    try {
      // Checks for MIUI device and displays Not Supported Message.
      String miuiCheck = await SystemProperties.getSystemProperties(
              "ro.miui.ui.version.name") ??
          null;
      miuiCheck = miuiCheck.trim();

      if (miuiCheck != null &&
          miuiCheck.isNotEmpty &&
          (location == WallpaperManager.BOTH_SCREENS ||
              location == WallpaperManager.LOCK_SCREEN)) {
        await showDialog(
          context: context,
          builder: (context) => AlertMsg(
              title: 'MIUI Detected',
              msg:
                  'Due to MIUI Restrictions, Lockscreen Wallpaper cannot be changed by third-party apps, Please try \'Set as Home Screen\' instead.'),
        );
        return;
      }

      bool val =
          await context.read(imageSetter).state.setNow(location: location);

      if (location == 4) return;

      if (val)
        ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
      else
        ScaffoldMessenger.of(context).showSnackBar(snackBarError);

      HapticFeedback.vibrate();
    } catch (_) {}
  }
}
