import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/settings_provider.dart';

class SettingsTabWidget extends StatelessWidget {
  const SettingsTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Column(
      children: [SwitchListTile(
        title: const Text('Dark Mode'),
        value: settingsProvider.isDarkMode,
        onChanged: (bool value) {
          settingsProvider.isDarkMode = value;
        },
      )]
    );
  }
}
