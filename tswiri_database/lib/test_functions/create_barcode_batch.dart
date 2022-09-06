import 'package:tswiri_database/mobile_database.dart';

///Create a barcode batch.
///This will populate:
/// - BarcodeBatch
/// - CatalogedBarcode
List<CatalogedBarcode> createBarcodeBatch() {
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  int rangeStart = 1;
  int rangeEnd = 100;
  double size = 80.0;

  isar!.writeTxnSync((isar) {
    //Create barcode batch.
    int batchID = isar.barcodeBatchs.putSync(
      BarcodeBatch()
        ..imported = false
        ..rangeEnd = rangeEnd
        ..rangeStart = rangeStart
        ..height = size
        ..width = size
        ..timestamp = timestamp,
    );

    //Create Cataloged Barcodes.
    for (var i = rangeStart; i <= rangeEnd; i++) {
      isar.catalogedBarcodes.putSync(
        CatalogedBarcode()
          ..barcodeUID = '${i}_$timestamp'
          ..batchID = batchID
          ..width = size
          ..height = size,
      );
    }
  });

  return isar!.catalogedBarcodes.where().findAllSync();
}
