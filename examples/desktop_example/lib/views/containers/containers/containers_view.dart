import 'dart:developer';

import 'package:desktop_example/views/containers/container/container_view.dart';
import 'package:flutter/material.dart';
import 'package:tswiri_base/colors/colors.dart';
import 'package:tswiri_base/models/containers/container_search_controller.dart';
import 'package:tswiri_base/settings/global_settings.dart';
import 'package:tswiri_base/widgets/general/search_text_field.dart';
import 'package:tswiri_database/export.dart';
import 'package:tswiri_database/functions/get_functions.dart';

class ContainersView extends StatefulWidget {
  const ContainersView({Key? key}) : super(key: key);

  @override
  State<ContainersView> createState() => _ContainersViewState();
}

class _ContainersViewState extends State<ContainersView> {
  final ContainerSearchController _searchController =
      ContainerSearchController();

  final TextEditingController _searchTextController = TextEditingController();

  List<CatalogedContainer> selectedContainers = [];

  @override
  void initState() {
    _searchController.filterContainerEntries(
      enteredKeyWord: null,
      containerFilters: containerFilters,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: background,
        child: Column(
          children: [
            _searchCard(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 150),
                itemCount: _searchController.searchResults.length,
                itemBuilder: (context, index) {
                  return _containerCard(_searchController.searchResults[index]);
                },
              ),
            ),
          ],
        ),
      ),
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
                      _searchController.filterContainerEntries(
                        enteredKeyWord: value,
                        containerFilters: containerFilters,
                      );
                      setState(() {});
                    },
                    onSubmitted: (value) {
                      _searchController.filterContainerEntries(
                        enteredKeyWord: value,
                        containerFilters: containerFilters,
                      );
                      setState(() {});
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: FilterBar(
                filters: containerFilters,
                filterTypes: _searchController.filterTypes(),
                filterChange: () {
                  setState(() {
                    setState(() {
                      _searchController.filterContainerEntries(
                        enteredKeyWord: _searchTextController.text,
                        containerFilters: containerFilters,
                      );
                      selectedContainers.clear();
                    });
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _containerCard(CatalogedContainer catalogedContainer) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ContainerView(
              catalogedContainer: catalogedContainer,
            ),
          ),
        );

        _searchController.filterContainerEntries(
            enteredKeyWord: _searchTextController.text,
            containerFilters: containerFilters);
        setState(() {});
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
