import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:flutter_fadein/flutter_fadein.dart' as fade;
import 'package:solid_color_fill_walls/fixedValues.dart';

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
      SnackBar(content: Text('Wallpaper Successfully set!'));
  final SnackBar snackBarError =
      SnackBar(content: Text('Oops, An Error has occurred!'));
  final FixedValues fixedValues = FixedValues();

  @override
  void initState() {
    super.initState();
    loadImage(this.widget.mapEntry.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: fixedValues.fixedCardRadius),
                  elevation: 3,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2,
                    child: ClipRRect(
                      borderRadius: fixedValues.fixedCardRadius,
                      child: displayCanvas(),
                    ),
                  ),
                ),
                Text(
                  'Color Info: ${this.widget.mapEntry.key}',
                  style: fixedValues.colorTitleStyle,
                ),
                ElevatedButton(
                  onPressed: () =>
                      setImage(context, WallpaperManager.HOME_SCREEN),
                  child: Text('Set As Home Screen'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      setImage(context, WallpaperManager.LOCK_SCREEN),
                  child: Text('Set As Lock Screen'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      setImage(context, WallpaperManager.BOTH_SCREENS),
                  child: Text('Set As Both'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget displayCanvas() {
    if (pngBytes != null)
      return fade.FadeIn(
        duration: const Duration(milliseconds: 500),
        child: Image.memory(pngBytes),
      );
    else
      return fade.FadeIn(child: Text('Loading...'));
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
        if (result.contains('success'))
          ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
        else
          ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
      }).catchError((err) {
        ScaffoldMessenger.of(context).showSnackBar(snackBarError);
      });
  }
}
