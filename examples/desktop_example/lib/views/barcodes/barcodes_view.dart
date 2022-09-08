import 'package:desktop_example/views/barcodes/pdf_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tswiri_base/colors/colors.dart';
import 'package:tswiri_base/settings/desktop_settings.dart';
import 'package:tswiri_database/export.dart';

class BarcodesView extends StatefulWidget {
  const BarcodesView({Key? key}) : super(key: key);

  @override
  State<BarcodesView> createState() => _BarcodesViewState();
}

class _BarcodesViewState extends State<BarcodesView> {
  //Number of barcodes.
  final TextEditingController _numberController = TextEditingController();
  bool isEditingNumberOfBarcodes = false;
  int numberOfBarocdes = 1;

  //Barcode Size.
  final TextEditingController _sizeController = TextEditingController();
  final FocusNode _sizeFocusNode = FocusNode();

  late List<DropdownMenuItem<String>> menuItems = barcodeSizes.keys
      .map((e) => DropdownMenuItem<String>(
            value: e,
            child: Text(e),
          ))
      .toList();

  late double barcodeSize = 50;

  //Barcode Batches
  late List<BarcodeBatch> barcodeBatches =
      isar!.barcodeBatchs.where().findAllSync();

  final TextEditingController _batchHeightController = TextEditingController();
  final TextEditingController _batchWidthController = TextEditingController();

  final FocusNode _batchHeightNode = FocusNode();
  final FocusNode _batchWidthNode = FocusNode();

  bool isEditingSize = false;

  @override
  void initState() {
    _numberController.text = numberOfBarocdes.toString();
    _sizeController.text = '50';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _barcodeSetup(),
          _batchHistory(),
        ],
      ),
    );
  }

  Widget _barcodeSetup() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Generate Barcodes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Text(
                  'Number of barcodes: ',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _numberController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        numberOfBarocdes =
                            int.tryParse(value) ?? numberOfBarocdes;
                      },
                      onSubmitted: (value) {
                        numberOfBarocdes =
                            int.tryParse(value) ?? numberOfBarocdes;
                        _numberController.text = numberOfBarocdes.toString();
                        _sizeFocusNode.requestFocus();
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Side Length: ',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      focusNode: _sizeFocusNode,
                      controller: _sizeController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        setState(() {
                          barcodeSize = double.tryParse(value) ?? barcodeSize;
                        });
                      },
                    ),
                  ),
                ),
                Text(
                  ' x ',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _sizeController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        setState(() {
                          barcodeSize = double.tryParse(value) ?? barcodeSize;
                        });
                      },
                    ),
                  ),
                ),
                Text(
                  'mm',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    _generateBarcodeBatch();
                  },
                  child: Text(
                    'Generate',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _batchHistory() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'History',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(
            indent: 15,
            endIndent: 15,
          ),
          _batchList(),
        ],
      ),
    );
  }

  Widget _batchList() {
    return Column(
      children: barcodeBatches.map((e) => _batch(e)).toList(),
    );
  }

  Widget _batch(BarcodeBatch batch) {
    return Card(
      color: background[300],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy-MM-dd - HH:m')
                      .format(
                          DateTime.fromMillisecondsSinceEpoch(batch.timestamp))
                      .toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'ID: ${batch.id}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const Divider(
              thickness: 0.2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Number of barcodes: ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  isar!.catalogedBarcodes
                      .filter()
                      .batchIDEqualTo(batch.id)
                      .findAllSync()
                      .length
                      .toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const Divider(
              thickness: 0.2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Height:',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Builder(builder: (context) {
                  if (isEditingSize == true) {
                    _batchHeightController.text = batch.height.toString();
                    return Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _batchHeightController,
                            focusNode: _batchHeightNode,
                            keyboardType: TextInputType.number,
                            onSubmitted: (value) {
                              double newSize =
                                  double.tryParse(value) ?? batch.height;

                              if (newSize != batch.height) {
                                batch.height = newSize;

                                isar!.writeTxnSync((isar) => isar.barcodeBatchs
                                    .putSync(batch, replaceOnConflict: true));

                                List<CatalogedBarcode> relatedBarcodes = isar!
                                    .catalogedBarcodes
                                    .filter()
                                    .batchIDEqualTo(batch.id)
                                    .findAllSync();

                                isar!.writeTxnSync((isar) {
                                  for (CatalogedBarcode barcode
                                      in relatedBarcodes) {
                                    barcode.height = newSize;
                                    isar.catalogedBarcodes.putSync(barcode,
                                        replaceOnConflict: true);
                                  }
                                });

                                _updateBarcodeBatches();
                              }

                              setState(() {
                                isEditingSize = false;
                              });
                            },
                          ),
                        ),
                        Text(
                          'mm',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      ],
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isEditingSize = true;
                        _batchHeightNode.requestFocus();
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          batch.height.toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '(tap to edit)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
            const Divider(
              thickness: 0.2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Width:',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Builder(builder: (context) {
                  if (isEditingSize == true) {
                    _batchWidthController.text = batch.width.toString();
                    return Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _batchWidthController,
                            focusNode: _batchWidthNode,
                            keyboardType: TextInputType.number,
                            onSubmitted: (value) {
                              double newSize =
                                  double.tryParse(value) ?? batch.width;

                              if (newSize != batch.width) {
                                batch.width = newSize;

                                isar!.writeTxnSync((isar) => isar.barcodeBatchs
                                    .putSync(batch, replaceOnConflict: true));

                                List<CatalogedBarcode> relatedBarcodes = isar!
                                    .catalogedBarcodes
                                    .filter()
                                    .batchIDEqualTo(batch.id)
                                    .findAllSync();

                                isar!.writeTxnSync((isar) {
                                  for (CatalogedBarcode barcode
                                      in relatedBarcodes) {
                                    barcode.width = newSize;
                                    isar.catalogedBarcodes.putSync(barcode,
                                        replaceOnConflict: true);
                                  }
                                });

                                _updateBarcodeBatches();
                              }

                              setState(() {
                                isEditingSize = false;
                              });
                            },
                          ),
                        ),
                        Text(
                          'mm',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      ],
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isEditingSize = true;
                        _batchWidthNode.requestFocus();
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          batch.width.toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '(tap to edit)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
            const Divider(
              thickness: 0.2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  child: ElevatedButton(
                    onPressed: () async {
                      bool? approved = await showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete Barcode Batch'),
                          content: const Text(
                              'Are you sure you want delete all the barcodes related to this batch ?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('OK'),
                            ),
                          ],
                          actionsAlignment: MainAxisAlignment.spaceBetween,
                        ),
                      );

                      if (approved != null && approved == true) {
                        bool canDelete = true;
                        isar!.catalogedBarcodes
                            .filter()
                            .batchIDEqualTo(batch.id)
                            .findAllSync()
                            .forEach((element) {
                          CatalogedContainer? catalogedContainer = isar!
                              .catalogedContainers
                              .filter()
                              .barcodeUIDMatches(element.barcodeUID)
                              .findFirstSync();
                          if (catalogedContainer != null) {
                            canDelete = false;
                          }
                        });

                        if (canDelete == true) {
                          isar!.writeTxnSync((isar) {
                            isar.barcodeBatchs.deleteSync(batch.id);
                            isar.catalogedBarcodes
                                .filter()
                                .batchIDEqualTo(batch.id)
                                .deleteAllSync();
                          });
                        } else if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'A barcode from this batch is in use.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }

                      _updateBarcodeBatches();
                    },
                    child: Text(
                      'Delete',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                Visibility(
                  visible: !batch.imported,
                  child: ElevatedButton(
                    onPressed: () {
                      _createPDF(batch);
                    },
                    child: Text(
                      'Generate',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateBarcodeBatch() async {
    //Time of creation
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    //Generate BarcodeProperties
    int startUID = 1;

    if (barcodeBatches.isNotEmpty) {
      startUID = barcodeBatches.last.rangeEnd + 1;
    }

    int endUID = startUID + numberOfBarocdes - 1;

    BarcodeBatch newBarcodeBatch = BarcodeBatch()
      ..width = barcodeSize
      ..height = barcodeSize
      ..timestamp = timestamp
      ..rangeStart = startUID
      ..rangeEnd = endUID
      ..imported = false;

    //Write to database.
    isar!.writeTxnSync((isar) {
      int batchID = isar.barcodeBatchs.putSync(newBarcodeBatch);

      for (var i = startUID; i <= endUID; i++) {
        String barcodeUID = '${i}_$timestamp';
        isar.catalogedBarcodes.putSync(CatalogedBarcode()
          ..barcodeUID = barcodeUID
          ..width = barcodeSize
          ..height = barcodeSize
          ..batchID = batchID);
      }
    });

    _updateBarcodeBatches();

    _createPDF(newBarcodeBatch);
  }

  void _createPDF(BarcodeBatch barcodeBatch) async {
    List<String> barcodeUIDs = [];

    for (var i = barcodeBatch.rangeStart; i <= barcodeBatch.rangeEnd; i++) {
      barcodeUIDs.add('${i}_${barcodeBatch.timestamp}');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfView(
          barcodeUIDs: barcodeUIDs,
          size: barcodeBatch.width,
          start: barcodeBatch.rangeStart,
          end: barcodeBatch.rangeEnd,
        ),
      ),
    );
  }

  void _updateBarcodeBatches() {
    setState(() {
      barcodeBatches =
          barcodeBatches = isar!.barcodeBatchs.where().findAllSync();
    });
  }
}
