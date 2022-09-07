import 'package:desktop_example/views/containers/container/container_view.dart';
import 'package:flutter/material.dart';
import 'package:tswiri_base/colors/colors.dart';
import 'package:tswiri_base/models/search/search_controller.dart';
import 'package:tswiri_base/models/search/search_result_models.dart';
import 'package:tswiri_base/settings/global_settings.dart';
import 'package:tswiri_base/widgets/general/search_text_field.dart';
import 'package:tswiri_base/widgets/search/search_widgets.dart';
import 'package:tswiri_database/export.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final SearchController _searchController =
      SearchController(filters: searchFilters);

  final TextEditingController _searchTextController = TextEditingController();

  @override
  void initState() {
    _searchController.search();
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
                child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
              ),
              itemCount: _searchController.searchResults.length,
              itemBuilder: (context, index) {
                return _searchResultCard(
                  _searchController.searchResults[index],
                );
              },
            )),
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
                      setState(() {
                        _searchController.search(enteredKeyword: value);
                      });
                    },
                    onSubmitted: (value) {
                      setState(() {
                        _searchController.search(enteredKeyword: value);
                      });
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
              child: SearchFilterBar(
                filters: searchFilters,
                filterTypes: filterTypes.entries.map((e) => e.key).toList(),
                filterChange: () {
                  setState(() {
                    _searchController.search(
                        enteredKeyword: _searchTextController.text);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchResultCard(Result result) {
    CatalogedContainer catalogedContainer = isar!.catalogedContainers
        .filter()
        .containerUIDMatches(result.containerUID)
        .findFirstSync()!;

    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ContainerView(
              catalogedContainer: catalogedContainer,
            ),
          ),
        );
      },
      child: Builder(builder: (context) {
        switch (result.runtimeType) {
          case NameResult: //Name Result.
            return NameResultCard(nameResult: result as NameResult);

          case DescriptionResult: //Description Result.
            return DescriptionResultCard(
                descriptionResult: result as DescriptionResult);

          case ContainerTagResult: //ContainerTag Result.

            return ContainerTagResultCard(
                containerTagResult: result as ContainerTagResult);

          case PhotoLabelResult:
            return PhotoLabelResultCard(
                photoLabelResult: result as PhotoLabelResult);

          case ObjectLabelResult:
            return ObjectLabelResultCard(result: result as ObjectLabelResult);

          case MLPhotoLabelResult:
            return MLPhotoLabelResultCard(
                mlphotoLabelResult: result as MLPhotoLabelResult);

          case MLObjectLabelResult:
            return MLObjectLabelResultCard(
                result: result as MLObjectLabelResult);

          case MLTextResult:
            return MLTextElementResultCard(result: result as MLTextResult);

          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }
}
