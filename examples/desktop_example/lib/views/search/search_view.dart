import 'package:flutter/material.dart';
import 'package:tswiri_base/colors/colors.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: background,
        child: Column(
          children: [
            const Text('Search'),
          ],
        ),
      ),
    );
  }
}
