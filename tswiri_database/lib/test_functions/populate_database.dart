import 'package:tswiri_database/mobile_database.dart';
import 'package:tswiri_database/functions/create_functions.dart';
import 'package:tswiri_database/test_functions/create_containers.dart';
import 'package:tswiri_database/test_functions/create_grid.dart';

import 'create_barcode_batch.dart';

void populateDatabase() {
  //1. Clear the database.
  isar!.writeTxnSync((isar) => isar.clearSync());

  //1. Create ContainerTypes.
  createBasicContainerTypes();

  //2. Create a barcodeBatch.
  List<CatalogedBarcode> catalogedBarcodes = createBarcodeBatch();

  //3. Create containers.
  List<CatalogedContainer> containers =
      createContainersWithRelationships(catalogedBarcodes);

  //4. Create Grid.
  createGrid(containers);

  //TODO: Continue with this process.
}
