import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

saveQrCode(GlobalKey? key) async {
  if (key == null) return null;

  RenderRepaintBoundary boundary =
      key.currentContext!.findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage();
  ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final pngBytes = byteData?.buffer.asUint8List();
  if (byteData != null) {
    final result = await ImageGallerySaver.saveImage(pngBytes!);
    print(result);
    _toastInfo('Successfully downloaded to gallery');
  }
}

_toastInfo(String info) {
  Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
}
