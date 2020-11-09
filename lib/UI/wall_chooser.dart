import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class WallChooser extends StatefulWidget {
  final MapEntry mapEntry;
  final Size size;

  const WallChooser({@required this.mapEntry, @required this.size});

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

      int width = widget.size.width.round();
      int height = widget.size.height.round();
      ui.Image image = await p.toImage(width, height);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      setState(() {
        pngBytes = byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      });
    }
  }

  void writeImageToTemp(BuildContext context) async {
    String tempPath = (await getTemporaryDirectory()).path;
    String filePath = tempPath + '/temp.png';
    File file = File(filePath);

    if (pngBytes != null)
      file.writeAsBytes(pngBytes).then((value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Saved: $filePath')));
      }).catchError((err) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $err')));
      });
  }
}
