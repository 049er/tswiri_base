import 'dart:math';
import 'package:isar/isar.dart';
import 'package:tswiri_database/converters/corner_point_converter.dart';
part 'ml_text_line.g.dart';

//TODO: finish comments.
@Collection()
@Name("MLTextLine")
class MLTextLine {
  ///LineID.
  int id = Isar.autoIncrement;

  ///BlockID.
  @Name("blockID")
  late int blockID;

  ///blockIndex.
  @Name("blockIndex")
  late int blockIndex;

  ///RecognizedLanguages.
  @Name("recognizedLanguages")
  late List<String> recognizedLanguages;

  ///CornerPoints.
  @Name("cornerPoints")
  @CornerPointConverter()
  late List<Point<int>> cornerPoints;

  @override
  String toString() {
    return 'ID: $id, BlockID: $blockID, BlockIndex: $blockIndex, Languages: $recognizedLanguages, CornerPoints: $cornerPoints';
  }
}
