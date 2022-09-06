import 'package:flutter/material.dart';
import 'package:tswiri_base/colors/colors.dart';

class DevicesView extends StatefulWidget {
  const DevicesView({Key? key}) : super(key: key);

  @override
  State<DevicesView> createState() => _DevicesViewState();
}

class _DevicesViewState extends State<DevicesView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: background,
        child: Column(
          children: [
            const Text('Devices'),
          ],
        ),
      ),
    );
  }
}
