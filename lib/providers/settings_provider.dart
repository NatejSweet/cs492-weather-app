import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _darkMode = false;
  Color _lightThemeSeedColor = Colors.yellow;
  Color _darkThemeSeedColor = Colors.blue;
  SharedPreferences? prefs;

  bool get darkMode => _darkMode;
  Color get lightThemeSeedColor => _lightThemeSeedColor;
  Color get darkThemeSeedColor => _darkThemeSeedColor;

  void toggleMode() {
    _darkMode = !_darkMode;
    if (prefs != null) {
      prefs!.setBool('darkMode', _darkMode);
    }

    notifyListeners();
  }

  void setSeedColor(Color color) {
    if (_darkMode) {
      _darkThemeSeedColor = color;
      if (prefs != null) {
        prefs!.setInt('darkThemeSeedColor', color.value);
      }
    } else {
      _lightThemeSeedColor = color;
      if (prefs != null) {
        prefs!.setInt('lightThemeSeedColor', color.value);
      }
    }

    notifyListeners();
  }

  SettingsProvider() {
    initPreferences();
  }

  void initPreferences() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      _darkMode = prefs!.getBool('darkMode') ?? false;
      _lightThemeSeedColor = Color(prefs!.getInt('lightThemeSeedColor') ?? Colors.yellow.value);
      _darkThemeSeedColor = Color(prefs!.getInt('darkThemeSeedColor') ?? Colors.blue.value);
    }
    notifyListeners();
  }
}