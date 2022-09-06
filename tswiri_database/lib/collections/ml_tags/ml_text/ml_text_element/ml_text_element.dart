import 'dart:math';
import 'dart:ui';

import 'package:isar/isar.dart';
import 'package:tswiri_database/converters/corner_point_converter.dart';
part 'ml_text_element.g.dart';

//TODO: finish comments.
@Collection()
@Name("MLTextElement")
class MLTextElement {
  int id = Isar.autoIncrement;

  ///PhotoID.
  @Name("photoID")
  late int photoID;

  ///lineID.
  @Name("lineID")
  late int lineID;

  ///LineIndex.
  @Name("lineIndex")
  late int lineIndex;

  ///DetectedElementTextID.
  @Name("detectedElementTextID")
  late int detectedElementTextID;

  ///CornerPoints.
  @Name("cornerPoints")
  @CornerPointConverter()
  late List<Point<int>> cornerPoints;

  ///UserFeedback.
  @Name("userFeedback")
  late bool? userFeedback;

  @override
  String toString() {
    return 'ID: $id, LineID: $lineID, LineIndex: $lineIndex, DetectedElementTextID: $detectedElementTextID, CornerPoints: $cornerPoints';
  }

  Rect getBoundingBox() {
    return Rect.fromPoints(
        Offset(cornerPoints[0].x.toDouble(), cornerPoints[0].y.toDouble()),
        Offset(cornerPoints[2].x.toDouble(), cornerPoints[2].y.toDouble()));
  }
}
