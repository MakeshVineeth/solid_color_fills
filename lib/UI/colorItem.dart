import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';

class ColorItem extends StatelessWidget {
  final MapEntry mapEntry;

  ColorItem({@required this.mapEntry});

  final BorderRadius fixedCardRadius = BorderRadius.circular(20.0);
  final colorTitleStyle = TextStyle(
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: fixedCardRadius),
      child: InkWell(
        borderRadius: fixedCardRadius,
        // temp
        onTap: () => writeImage(),
        child: IgnorePointer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: mapEntry.value,
                    borderRadius: fixedCardRadius,
                  ),
                ),
              ),
              Text(
                mapEntry.key,
                style: colorTitleStyle,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void writeImage() async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas c = new Canvas(recorder);
    c.drawColor(Colors.red, BlendMode.src); // etc
    ui.Picture p = recorder.endRecording();
    ui.Image image = await p.toImage(500, 500);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);
    Directory tempDir = await getTemporaryDirectory();
    File file = File('${tempDir.path}//temp.png');
    file.writeAsBytes(pngBytes);
  }
}
