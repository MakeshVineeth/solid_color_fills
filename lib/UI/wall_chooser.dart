import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:com.mvp.solid_color_fill_walls/fixedValues.dart';

class WallChooser extends StatefulWidget {
  final MapEntry mapEntry;
  final double width;
  final double height;

  const WallChooser(
      {@required this.mapEntry, @required this.width, @required this.height});

  @override
  _WallChooserState createState() => _WallChooserState();
}

class _WallChooserState extends State<WallChooser> {
  Uint8List pngBytes;
  final SnackBar snackBarSuccess =
      SnackBar(content: Text('Yay! Wallpaper Successfully Set!'));
  final SnackBar snackBarError =
      SnackBar(content: Text('Oops, An Error has Occurred!'));
  final FixedValues fixedValues = FixedValues();

  @override
  void initState() {
    super.initState();
    loadImage(this.widget.mapEntry.value);
  }

  Map buttons = {
    'Set As Home Screen': WallpaperManager.HOME_SCREEN,
    'Set As Lock Screen': WallpaperManager.LOCK_SCREEN,
    'Set As Both': WallpaperManager.BOTH_SCREENS,
  };

  @override
  Widget build(BuildContext context) {
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
                                  child: displayCanvas()),
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
                                    '${widget.mapEntry.key}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                      color: widget.mapEntry.value,
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

  Widget displayCanvas() {
    if (pngBytes != null)
      return Image.memory(pngBytes);
    else
      return Text('Loading...');
  }

  void loadImage(Color color) async {
    if (color != null) {
      ui.PictureRecorder recorder = ui.PictureRecorder();
      Canvas c = new Canvas(recorder);
      c.drawColor(color, BlendMode.src); // etc
      ui.Picture p = recorder.endRecording();

      int width = widget.width.round();
      int height = widget.height.round();
      ui.Image image = await p.toImage(width, height);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      setState(() {
        pngBytes = byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      });
    }
  }

  void setImage(BuildContext context, int location) async {
    String tempPath = (await getTemporaryDirectory()).path;
    String filePath = tempPath + '/temp.png';
    File file = File(filePath);

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
