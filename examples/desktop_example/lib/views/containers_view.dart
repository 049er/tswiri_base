import 'package:flutter/material.dart';
import 'package:tswiri_base/colors/colors.dart';

class ContainersView extends StatefulWidget {
  const ContainersView({Key? key}) : super(key: key);

  @override
  State<ContainersView> createState() => _ContainersViewState();
}

class _ContainersViewState extends State<ContainersView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: background,
        child: Column(
          children: [
            const Text('Containers'),
          ],
        ),
      ),
    );
  }
}
