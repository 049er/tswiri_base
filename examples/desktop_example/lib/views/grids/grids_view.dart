import 'package:flutter/material.dart';
import 'package:tswiri_base/colors/colors.dart';

class GridsView extends StatefulWidget {
  const GridsView({Key? key}) : super(key: key);

  @override
  State<GridsView> createState() => _GridsViewState();
}

class _GridsViewState extends State<GridsView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Text('Grids'),
        ],
      ),
    );
  }
}
