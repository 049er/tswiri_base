import 'package:flutter/material.dart';
import 'package:tswiri_base/colors/colors.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: background,
        child: Column(
          children: [
            const Text('Settings'),
          ],
        ),
      ),
    );
  }
}
