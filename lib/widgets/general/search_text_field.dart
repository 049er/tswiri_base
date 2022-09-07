import 'package:flutter/material.dart';
import 'package:tswiri_base/functions/capitalize_first_character.dart';

import 'package:tswiri_base/colors/colors.dart';
import 'package:tswiri_base/settings/desktop_settings.dart';
import 'package:tswiri_base/widgets/general/sunbird_filter_chip.dart';
import 'package:tswiri_database/export.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({
    Key? key,
    required this.filters,
    required this.filterTypes,
    required this.filterChange,
    required this.onCancel,
    required this.onChanged,
    required this.onSubmitted,
  }) : super(key: key);

  ///Refernece to activeFilters;
  final List<String> filters;

  ///A list of filters to display.
  final List<String> filterTypes;

  ///On Filter change
  final void Function(String) filterChange;

  ///On Search Cancel.
  final void Function() onCancel;

  ///On value change.
  final void Function(String) onChanged;

  ///On search submitted
  final void Function(String) onSubmitted;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchNode = FocusNode();

  @override
  void initState() {
    _searchNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background[500],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              const SizedBox(
                width: kMinInteractiveDimension / 2,
              ),
              Flexible(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchNode,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                ),
              ),
              IconButton(
                onPressed: () {
                  widget.onCancel();
                  _searchController.clear();
                },
                icon: const Icon(
                  Icons.close_sharp,
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // spacing: 5,
                children: widget.filterTypes
                    .map(
                      (filterType) => CustomFilterChip(
                        label: filterType.capitalizeFirstCharacter(),
                        toolTip: '',
                        selected: widget.filters.contains(filterType),
                        onSelected: (value) {
                          _onSelected(value, filterType);
                          widget.filterChange(_searchController.text);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSelected(bool selected, String filter) {
    if (widget.filters.contains(filter)) {
      setState(() {
        widget.filters.removeWhere((element) => element == filter);
      });
    } else {
      setState(() {
        widget.filters.add(filter);
      });
    }
  }
}

class SearchFilterBar extends StatefulWidget {
  const SearchFilterBar({
    Key? key,
    required this.filters,
    required this.filterTypes,
    required this.filterChange,
  }) : super(key: key);

  ///Refernece to activeFilters;
  final List<String> filters;

  ///A list of filters to display.
  final List<String> filterTypes;

  ///On Filter change
  final void Function() filterChange;

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // spacing: 5,
          children: widget.filterTypes
              .map(
                (filterType) => CustomFilterChip(
                  label: filterType.capitalizeFirstCharacter(),
                  toolTip: '',
                  selected: widget.filters.contains(filterType),
                  onSelected: (value) {
                    _onSelected(value, filterType);
                    widget.filterChange();
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _onSelected(bool selected, String filter) {
    if (widget.filters.contains(filter)) {
      setState(() {
        widget.filters.removeWhere((element) => element == filter);
      });
    } else {
      setState(() {
        widget.filters.add(filter);
      });
    }
  }
}

class ContainerFilterBar extends StatefulWidget {
  const ContainerFilterBar({
    Key? key,
    required this.filters,
    required this.filterTypes,
    required this.filterChange,
  }) : super(key: key);

  ///Refernece to activeFilters;
  final List<String> filters;

  ///A list of filters to display.
  final List<String> filterTypes;

  ///On Filter change
  final void Function() filterChange;

  @override
  State<ContainerFilterBar> createState() => _ContainerFilterBarState();
}

class _ContainerFilterBarState extends State<ContainerFilterBar> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // spacing: 5,
          children: widget.filterTypes
              .map(
                (filterType) => CustomFilterChip(
                  label: filterType.capitalizeFirstCharacter(),
                  toolTip: '',
                  selected: widget.filters.contains(filterType),
                  color: colorModeEnabled
                      ? isar!.containerTypes
                          .filter()
                          .containerTypeNameMatches(filterType)
                          .findFirstSync()
                          ?.containerColor
                      : null,
                  onSelected: (value) {
                    _onSelected(value, filterType);
                    widget.filterChange();
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _onSelected(bool selected, String filter) {
    if (widget.filters.contains(filter)) {
      setState(() {
        widget.filters.removeWhere((element) => element == filter);
      });
    } else {
      setState(() {
        widget.filters.add(filter);
      });
    }
  }
}
