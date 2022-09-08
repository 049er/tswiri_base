import 'package:desktop_example/views/containers/select_container/select_container_view.dart';
import 'package:flutter/material.dart';
import 'package:tswiri_base/colors/colors.dart';
import 'package:tswiri_base/settings/desktop_settings.dart';
import 'package:tswiri_base/widgets/general/custom_text_field.dart';
import 'package:tswiri_base/widgets/general/tag_text_predictor.dart';
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

  late List<ContainerTag> assignedTags = isar!.containerTags
      .filter()
      .containerUIDMatches(_catalogedContainer.containerUID)
      .findAllSync();

  late List<ContainerRelationship> containerRelationships = isar!
      .containerRelationships
      .filter()
      .parentUIDMatches(_catalogedContainer.containerUID)
      .findAllSync();

  late final ContainerType _containerType =
      isar!.containerTypes.getSync(_catalogedContainer.containerTypeID)!;

  late Color containerColor = _containerType.containerColor;

  bool isAddingTag = false;
  bool isEditingPhoto = false;
  Photo? _photo;

  final GlobalKey<TagTextPredictorState> _tagTextPredictorKey = GlobalKey();

  late bool? childrenExpanded = false;

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
      bottomSheet: isAddingTag ? _tagTextSearch() : const SizedBox.shrink(),
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
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        children: [
          _nameTextField(),
          _descriptionTextField(),
          _parentCard(),
          _tagsCard(),
          // _photosCard(),
          _containerChildren(),
          // _gridCard(),
        ],
      ),
    );
  }

  Widget _tagTextSearch() {
    return TagTextPredictor(
      key: _tagTextPredictorKey,
      excludedTags: assignedTags.map((e) => e.tagTextID).toList(),
      dismiss: () => setState(() {
        isAddingTag = false;
      }),
      onTagAdd: (tagTextID) {
        //Create New ContainerTag.
        ContainerTag newContainerTag = ContainerTag()
          ..containerUID = _catalogedContainer.containerUID
          ..tagTextID = tagTextID;

        //Write to isar.
        isar!.writeTxnSync(
            (isar) => isar.containerTags.putSync(newContainerTag));

        _updateAssignedTags();
      },
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
      child: ListTile(
        leading: const Icon(Icons.panorama_fisheye_outlined),
        title: Text(
          _parentContainer?.name ??
              _parentContainer?.containerUID ??
              'no parent',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          '(parent)',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: IconButton(
          onPressed: () async {
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
          icon: const Icon(Icons.change_circle),
        ),
      ),
    );
  }

  Widget _tagsCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.tag_sharp),
            title: Text(
              'Tags',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  isAddingTag = !isAddingTag;
                });
              },
              icon: isAddingTag
                  ? const Icon(
                      Icons.cancel,
                      color: tswiriOrange,
                    )
                  : const Icon(Icons.add),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 4,
              children: [
                for (var e in assignedTags) _containerTagChip(e),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _containerTagChip(ContainerTag containerTag) {
    return Chip(
      label: Text(
        isar!.tagTexts.getSync(containerTag.tagTextID)?.text ?? 'err',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      deleteIcon: const Icon(
        Icons.close_sharp,
        size: 20,
      ),
      onDeleted: () {
        isar!.writeTxnSync(
            (isar) => isar.containerTags.deleteSync(containerTag.id));

        _updateAssignedTags();

        ///Let the TagTextPredictor know this tag has been removed.
        _tagTextPredictorKey.currentState
            ?.updateAssignedTags(containerTag.tagTextID);
      },
    );
  }

  Widget _containerChildren() {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: childrenExpanded ?? false,
        onExpansionChanged: (value) {
          setState(() {
            childrenExpanded = value;
          });
        },
        leading: const Icon(Icons.account_tree_sharp),
        title: Text(
          'Children',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: background[300],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_catalogedContainer.name ??
                      _catalogedContainer.containerUID),
                ),
              ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    const VerticalDivider(),
                    Column(
                      children: [
                        for (ContainerRelationship e in containerRelationships)
                          _childContainerCard(e),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _childContainerCard(ContainerRelationship relationship) {
    //Container Entry
    CatalogedContainer catalogedContainer = isar!.catalogedContainers
        .filter()
        .containerUIDMatches(relationship.containerUID)
        .findFirstSync()!;

    return Row(
      children: [
        Container(
          width: 50,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: background[200]!,
              ),
            ),
          ),
        ),
        Card(
          color: background[300],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  catalogedContainer.name ?? catalogedContainer.containerUID,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ContainerView(
                          catalogedContainer: catalogedContainer,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_sharp),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///Updates children.
  void _updateChildrenContainers() {
    setState(() {
      containerRelationships = isar!.containerRelationships
          .filter()
          .parentUIDMatches(_catalogedContainer.containerUID)
          .findAllSync();
    });
  }

  ///Update the list of tags displayed.
  void _updateAssignedTags() {
    setState(() {
      assignedTags = isar!.containerTags
          .filter()
          .containerUIDMatches(_catalogedContainer.containerUID)
          .findAllSync();
    });
  }
}
