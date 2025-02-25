import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode {
    return _isDarkMode;
  }
  set isDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
    saveSettings();
  }

  SettingsProvider() {
    // Load settings from storage(key-value pair)
    getSettings();

  }

  void getSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  void saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }
}