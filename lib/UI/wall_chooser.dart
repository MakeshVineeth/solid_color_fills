import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:solid_color_fill/UI/database/commons.dart';
import 'package:solid_color_fill/UI/wall_image.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:solid_color_fill/fixedValues.dart';

class WallChooser extends ConsumerWidget {
  final SnackBar snackBarSuccess =
      SnackBar(content: Text('Yay! Wallpaper Successfully Set!'));
  final SnackBar snackBarError =
      SnackBar(content: Text('Oops, An Error has Occurred!'));
  final FixedValues fixedValues = FixedValues();

  final Map buttons = {
    'Set As Home Screen': WallpaperManager.HOME_SCREEN,
    'Set As Lock Screen': WallpaperManager.LOCK_SCREEN,
    'Set As Both': WallpaperManager.BOTH_SCREENS,
  };

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final object = watch(commonProvider.state);
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallpaper Confirmation'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: fixedValues.fixedCardRadius),
                        elevation: 3,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: fixedValues.fixedCardRadius,
                          child: IgnorePointer(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              height: constraints.maxHeight / 1.5,
                              child: ClipRRect(
                                  borderRadius: fixedValues.fixedCardRadius,
                                  child: WallImage()),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Color Info:',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () {},
                              child: IgnorePointer(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    object.colorTitle,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                      color: object.color,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: constraints.maxWidth / 2,
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
                                        child: Text(buttons.entries
                                            .elementAt(index)
                                            .key),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  )),
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

  void setImage(BuildContext context, int location) async {
    String tempPath = (await getTemporaryDirectory()).path;
    String filePath = tempPath + '/temp.png';
    File file = File(filePath);
    Uint8List pngBytes;
    if (pngBytes != null)
      file.writeAsBytes(pngBytes).then((value) async {
        String result =
            await WallpaperManager.setWallpaperFromFile(filePath, location);
        if (result.contains('set'))
          ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
        else
          ScaffoldMessenger.of(context).showSnackBar(snackBarError);

        file.delete();
      }).catchError((err) {
        ScaffoldMessenger.of(context).showSnackBar(snackBarError);
      });
  }
}
