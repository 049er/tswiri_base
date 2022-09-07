import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tswiri_base/colors/colors.dart';
import 'package:tswiri_base/settings/desktop_settings.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late SharedPreferences prefs;

  @override
  void initState() {
    loadSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _colorMode(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorMode() {
    return Card(
      child: ListTile(
        title: Text(
          'Color Mode',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          '(add color to the app)',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: Checkbox(
          value: colorModeEnabled,
          onChanged: (value) {
            setState(() {
              colorModeEnabled = value ?? false;
              prefs.setBool(colorModeEnabledPref, value ?? false);
            });
            log(colorModeEnabled.toString());
          },
        ),
      ),
    );
  }

  void loadSettings() async {
    loadDesktopSettings();
    prefs = await SharedPreferences.getInstance();
  }
}
