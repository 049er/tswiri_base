import 'dart:developer';

import 'package:flutter/widgets.dart';

import 'dart:ui' as ui;

import 'package:tswiri_database/tswiri_app_database/app_database.dart';

class ImagePainter extends CustomPainter {
  ImagePainter(
    this.mlObject,
    this.image,
    this.photoSize,
  );

  ui.Image image;
  MLObject mlObject;
  Size photoSize;

  @override
  void paint(Canvas canvas, Size size) {
    double photoAspectRatio = photoSize.height / photoSize.width;
    Rect boundingBox = mlObject.getBoundingBox();
    double boundingBoxWidth = boundingBox.width;
    double boundingBoxHeight = boundingBox.height;

    if (boundingBoxWidth > boundingBoxHeight) {
      //Width bigger
      boundingBoxHeight = boundingBoxHeight * photoAspectRatio;
    } else {
      //Height Bigger
      boundingBoxWidth = boundingBoxWidth * photoAspectRatio;
    }

    log('width: $boundingBoxWidth');
    log('height: $boundingBoxHeight');

    final dst = Offset.zero & size;
    final src = Rect.fromCenter(
      center: boundingBox.center,
      width: boundingBoxWidth,
      height: boundingBoxHeight,
    );

    canvas.drawImageRect(image, src, dst, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
