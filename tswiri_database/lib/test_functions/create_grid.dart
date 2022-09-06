import 'package:tswiri_database/mobile_database.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void createGrid(List<CatalogedContainer> containers) {
  //1. Get the shelf container.
  CatalogedContainer shelfContainer =
      containers.firstWhere((element) => element.containerTypeID == 1);

  int timestamp = DateTime.now().millisecondsSinceEpoch;
  int x = 0;
  int y = 0;

  isar!.writeTxnSync(
    (isar) {
      int gridUID = isar.catalogedGrids.putSync(
        CatalogedGrid()
          ..barcodeUID = shelfContainer.barcodeUID!
          ..parentBarcodeUID = null,
      );

      for (var element in containers) {
        if (element.containerTypeID == 1) {
          isar.catalogedCoordinates.putSync(
            CatalogedCoordinate()
              ..barcodeUID = element.barcodeUID!
              ..coordinate = vm.Vector3(0, 0, 0)
              ..gridUID = gridUID
              ..rotation = vm.Vector3(0, 0, 0)
              ..timestamp = timestamp + x,
          );
        } else {
          isar.catalogedCoordinates.putSync(
            CatalogedCoordinate()
              ..barcodeUID = element.barcodeUID!
              ..coordinate = vm.Vector3(x * 100, y * 100, 0)
              ..gridUID = gridUID
              ..rotation = vm.Vector3(0, 0, 0)
              ..timestamp = timestamp + x,
          );

          if (x % 4 == 0) {
            y++;
          }
        }

        x++;
      }
    },
  );
}
