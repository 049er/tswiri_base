import 'package:desktop_example/views/containers/select_container/select_container_view.dart';
import 'package:flutter/material.dart';
import 'package:tswiri_base/colors/colors.dart';
import 'package:tswiri_base/widgets/general/custom_text_field.dart';
import 'package:tswiri_database/export.dart';

class ContainerView extends StatefulWidget {
  const ContainerView({
    Key? key,
    required this.catalogedContainer,
  }) : super(key: key);
  final CatalogedContainer catalogedContainer;

  @override
  State<ContainerView> createState() => _ContainerViewState();
}

class _ContainerViewState extends State<ContainerView> {
  late final CatalogedContainer _catalogedContainer = widget.catalogedContainer;

  late final ContainerRelationship? _parentRelationship = isar!
      .containerRelationships
      .filter()
      .containerUIDMatches(_catalogedContainer.containerUID)
      .findFirstSync();

  late CatalogedContainer? _parentContainer = _parentRelationship != null
      ? isar!.catalogedContainers
          .filter()
          .containerUIDMatches(_parentRelationship!.parentUID!)
          .findFirstSync()
      : null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: background[400],
      title: Text(
        _catalogedContainer.name ?? _catalogedContainer.containerUID,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      automaticallyImplyLeading: false,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _nameTextField(),
          _descriptionTextField(),
          _parentCard(),
          // _tagsCard(),
          // _photosCard(),
          // _containerChildren(),
          // _gridCard(),
        ],
      ),
    );
  }

  Widget _nameTextField() {
    return CustomTextField(
      label: 'name',
      initialValue: _catalogedContainer.name,
      onSubmitted: (value) {
        isar!.writeTxnSync((isar) {
          _catalogedContainer.name = value;
          isar.catalogedContainers
              .putSync(_catalogedContainer, replaceOnConflict: true);
        });

        setState(() {
          _catalogedContainer.name = value;
        });
      },
    );
  }

  Widget _descriptionTextField() {
    return CustomTextField(
      label: 'Description',
      initialValue: _catalogedContainer.description,
      onSubmitted: (value) {
        isar!.writeTxnSync((isar) {
          _catalogedContainer.description = value;
          isar.catalogedContainers
              .putSync(_catalogedContainer, replaceOnConflict: true);
        });

        setState(() {
          _catalogedContainer.description = value;
        });
      },
    );
  }

  Widget _parentCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Parent: ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              _parentContainer?.name ??
                  _parentContainer?.containerUID ??
                  'no parent',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            ElevatedButton(
              onPressed: () async {
                //TODO: Change parent.
                //TODO: make sure to exlude current container and all decendants.

                CatalogedContainer? selectedParent =
                    await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SelectContainerView(
                      currentContainer: _catalogedContainer,
                      parentContainer: _parentContainer,
                    ),
                  ),
                );

                if (selectedParent != null) {
                  isar!.writeTxnSync((isar) {
                    isar.containerRelationships
                        .filter()
                        .containerUIDMatches(_catalogedContainer.containerUID)
                        .deleteFirstSync();

                    isar.containerRelationships.putSync(ContainerRelationship()
                      ..containerUID = _catalogedContainer.containerUID
                      ..parentUID = selectedParent.containerUID);
                  });

                  setState(() {
                    _parentContainer = selectedParent;
                  });
                }
              },
              child: Text(_parentContainer != null ? 'Change' : 'Select'),
            ),
          ],
        ),
      ),
    );
  }
}
