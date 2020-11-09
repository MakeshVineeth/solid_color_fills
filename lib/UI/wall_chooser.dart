import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class WallChooser extends StatefulWidget {
  final MapEntry mapEntry;

  const WallChooser({@required this.mapEntry});

  @override
  _WallChooserState createState() => _WallChooserState();
}

class _WallChooserState extends State<WallChooser> {
  Uint8List pngBytes;

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
      body: Center(
        child: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            Container(
              child: Column(
                children: [
                  displayCanvas(),
                  Text(this.widget.mapEntry.key),
                  RaisedButton(
                    onPressed: () => writeImageToTemp(context),
                    child: Text('Set'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget displayCanvas() {
    if (pngBytes != null)
      return Image.memory(pngBytes);
    else
      return Text('');
  }

  void loadImage(Color color) async {
    if (color != null) {
      ui.PictureRecorder recorder = ui.PictureRecorder();
      Canvas c = new Canvas(recorder);
      c.drawColor(color, BlendMode.src); // etc
      ui.Picture p = recorder.endRecording();
      ui.Image image = await p.toImage(500, 500);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      setState(() {
        pngBytes = byteData.buffer.asUint8List();
      });
    }
  }

  void writeImageToTemp(BuildContext context) async {
    Directory tempDir = await getTemporaryDirectory();
    File file = File('${tempDir.path}//temp.png');
    file.writeAsBytes(pngBytes).then((err) {
      SnackBar snackBar = SnackBar(
        content: Text('Done: ${file.path}'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
