import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tswiri_base/colors/colors.dart';
import 'package:tswiri_base/models/containers/container_search_controller.dart';
import 'package:tswiri_base/settings/global_settings.dart';
import 'package:tswiri_base/widgets/general/search_text_field.dart';
import 'package:tswiri_database/export.dart';
import 'package:tswiri_database/functions/get_functions.dart';

class SelectContainerView extends StatefulWidget {
  const SelectContainerView({
    Key? key,
    required this.currentContainer,
    required this.parentContainer,
  }) : super(key: key);
  final CatalogedContainer currentContainer;
  final CatalogedContainer? parentContainer;

  @override
  State<SelectContainerView> createState() => _SelectContainerViewState();
}

class _SelectContainerViewState extends State<SelectContainerView> {
  final ContainerSearchController _searchController =
      ContainerSearchController();

  final TextEditingController _searchTextController = TextEditingController();

  late final CatalogedContainer _currentContainer = widget.currentContainer;
  late final CatalogedContainer? _parentContainer = widget.parentContainer;
  @override
  void initState() {
    _searchController.filterWithExclusions(
      currentContainer: _currentContainer,
      parentContainer: _parentContainer,
      enteredKeyWord: null,
      containerFilters: containerFilters,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: [
        _searchCard(),
        _infoCard(),
        _searchController.searchResults.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 150),
                  itemCount: _searchController.searchResults.length,
                  itemBuilder: (context, index) {
                    return _containerCard(
                        _searchController.searchResults[index]);
                  },
                ),
              )
            : Text(
                'none available',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
      ],
    );
  }

  Widget _searchCard() {
    return Card(
      color: background[400],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _searchTextController,
                    onChanged: (value) {
                      _searchController.filterWithExclusions(
                        currentContainer: _currentContainer,
                        parentContainer: _parentContainer,
                        enteredKeyWord: value,
                        containerFilters: containerFilters,
                      );
                      setState(() {});
                    },
                    onSubmitted: (value) {
                      _searchController.filterWithExclusions(
                        currentContainer: _currentContainer,
                        parentContainer: _parentContainer,
                        enteredKeyWord: value,
                        containerFilters: containerFilters,
                      );
                      setState(() {});
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.cancel,
                  ),
                ),
              ],
            ),

            // Padding(
            //   padding: const EdgeInsets.only(top: 8.0),
            //   child: FilterBar(
            //     filters: containerFilters,
            //     filterTypes: _searchController.containerTypes,
            //     filterChange: () {
            //       setState(() {
            //         setState(() {
            //           _searchController.filterWithExclusions(
            //             currentContainer: _currentContainer,
            //             parentContainer: _parentContainer,
            //             enteredKeyWord: _searchTextController.text,
            //             containerFilters: containerFilters,
            //           );
            //         });
            //       });
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.info),
            Text(
              _parentContainer == null ? 'Select parent' : 'Current Parent: ',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            _parentContainer == null
                ? const SizedBox.shrink()
                : Text(
                    _parentContainer!.name ?? _parentContainer!.containerUID,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _containerCard(CatalogedContainer catalogedContainer) {
    return GestureDetector(
      onTap: () async {
        Navigator.of(context).pop(catalogedContainer);
      },
      onSecondaryTap: () {
        log('Click', name: 'Secondary');
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    catalogedContainer.name ?? catalogedContainer.containerUID,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Icon(
                    getContainerTypeIcon(
                      catalogedContainer.containerTypeID,
                    ),
                  )
                ],
              ),
              const Divider(),
              Text(
                catalogedContainer.description ?? 'no description',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
