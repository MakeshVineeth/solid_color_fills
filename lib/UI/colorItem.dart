import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class ColorItem extends StatelessWidget {
  final MapEntry mapEntry;

  ColorItem({@required this.mapEntry});

  final BorderRadius fixedCardRadius = BorderRadius.circular(20.0);
  final colorTitleStyle = TextStyle(
    fontWeight: FontWeight.w600,
  );

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: fixedCardRadius),
      child: InkWell(
        borderRadius: fixedCardRadius,

        // temp
        onTap: () async {
          RenderRepaintBoundary boundary =
              globalKey.currentContext.findRenderObject();
          ui.Image image = await boundary.toImage();
          ByteData byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);
          Uint8List pngBytes = byteData.buffer.asUint8List();
          print(pngBytes);
          Directory tempDir = await getTemporaryDirectory();
          print(tempDir.path);
          File file = File('${tempDir.path}//polomv.png');
          file.writeAsBytes(pngBytes);
        },
        child: IgnorePointer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: RepaintBoundary(
                  key: globalKey,
                  child: Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: mapEntry.value,
                      borderRadius: fixedCardRadius,
                    ),
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
}
