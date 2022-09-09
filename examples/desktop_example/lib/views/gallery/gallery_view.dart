import 'dart:developer';
import 'dart:io';

import 'package:desktop_example/views/photo/photo_edit_view.dart';
import 'package:flutter/material.dart';
import 'package:tswiri_base/colors/colors.dart';
import 'package:tswiri_base/models/image/image_data.dart';
import 'package:tswiri_database/export.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({Key? key}) : super(key: key);

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  late List<Photo> _photos = isar!.photos.where().findAllSync();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            for (var photo in _photos) _photoCard(photo),
          ],
        ),
      ),
    );
  }

  Widget _photoCard(Photo photo) {
    return InkWell(
      onTap: () {},
      child: Card(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image.file(
                width: 150,
                height: 250,
                File(photo.getPhotoPath()),
                fit: BoxFit.cover,
              ),
              // Card(
              //   color: background[300]!.withAlpha(150),
              //   child: IconButton(
              //     onPressed: () {
              //       deletePhoto(photo);
              //       _updatePhotosDisplay();
              //     },
              //     icon: const Icon(Icons.delete),
              //     color: tswiriOrange,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
