import 'dart:io';

import 'package:flutter/services.dart';
import 'package:tswiri_database/export.dart';

Map<String, String> photos = {
  'assets/test_photos/black_pen.jpg': '123456787',
  'assets/test_photos/rubix_cube.jpg': '123456789',
  'assets/test_photos/ruler_short.jpg': '123456790',
  'assets/test_photos/vape_nord_4.jpg': '123456791',
  'assets/test_photos/cable.jpg': '123456792',
  'assets/test_photos/ear_buds.jpg': '123456793',
  'assets/test_photos/mouse.jpg': '123456794',
  'assets/test_photos/phone.jpg': '123456795',
  'assets/test_photos/tooth_pick.jpg': '123456796',
  'assets/test_photos/vape_juice.jpg': '123456797',
};

Future<void> addTestPhotos() async {
  for (var i = 0; i < photos.length; i++) {
    await rootBundle.load(photos.keys.elementAt(i)).then((content) {
      File newPhoto = File(
          '/home/werner/.local/share/desktop_example/main_space/photos/${photos.values.elementAt(i)}.jpg');
      File newThumbnail = File(
          '/home/werner/.local/share/desktop_example/main_space/photos/${photos.values.elementAt(i)}_thumbnail.jpg');
      newThumbnail.writeAsBytesSync(content.buffer.asUint8List());
      newPhoto.writeAsBytesSync(content.buffer.asUint8List());
    });

    Photo photo = Photo()
      ..containerUID = isar!.catalogedContainers.getSync(1)!.containerUID
      ..extention = 'jpg'
      ..photoName = int.parse(photos.values.elementAt(i))
      ..thumbnailName = '${photos.values.elementAt(i)}_thumbnail'
      ..thumbnailExtention = 'jpg'
      ..photoSize = const Size(2080, 4624);

    isar!.writeTxnSync((isar) => isar.photos.putSync(photo));
  }
}
