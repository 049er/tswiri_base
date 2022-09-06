import 'package:tswiri_database/mobile_database.dart';

List<CatalogedContainer> createContainersWithRelationships(
  List<CatalogedBarcode> catalogedBarcodes,
) {
  int timestamp = 1662456261516;
  isar!.writeTxnSync((isar) {
    //Create a shelf (parent).
    isar.catalogedContainers.putSync(
      CatalogedContainer()
        ..barcodeUID = catalogedBarcodes[0].barcodeUID
        ..containerTypeID = 1
        ..containerUID = 'shelf_1662456261516'
        ..description = 'a shelf'
        ..name = 'Shelf 1',
    );

    //Create boxes (children).
    for (var i = 1; i <= 5; i++) {
      timestamp++;
      isar.catalogedContainers.putSync(
        CatalogedContainer()
          ..barcodeUID = catalogedBarcodes[i].barcodeUID
          ..containerTypeID = 2
          ..containerUID = 'box_$timestamp'
          ..description = 'a box'
          ..name = 'Box $i',
      );

      isar.containerRelationships.putSync(
        ContainerRelationship()
          ..containerUID = 'box_$timestamp'
          ..parentUID = 'shelf_1662456261516',
      );
    }
  });

  return isar!.catalogedContainers.where().findAllSync();
}
