import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class WallChooser extends StatefulWidget {
  @override
  _WallChooserState createState() => _WallChooserState();
}

class _WallChooserState extends State<WallChooser> {
  Uint8List pngBytes;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color'),
      ),
      body: Center(
        child: Container(
          width: 500,
          height: 500,
          child: displayCanvas(),
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

  void loadImage() async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas c = new Canvas(recorder);
    c.drawColor(Colors.red, BlendMode.src); // etc
    ui.Picture p = recorder.endRecording();
    ui.Image image = await p.toImage(500, 500);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    setState(() {
      pngBytes = byteData.buffer.asUint8List();
    });
  }

  void writeImageToTemp() async {
    Directory tempDir = await getTemporaryDirectory();
    File file = File('${tempDir.path}//temp.png');
    file.writeAsBytes(pngBytes);
  }
}
