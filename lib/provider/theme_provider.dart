import 'package:flutter/material.dart';
import 'package:allpass/params/config.dart';
import 'package:allpass/ui/theme_resource.dart';

class ThemeProvider with ChangeNotifier {
  AllpassTheme _allpassTheme;

  ThemeData currTheme;
  Color backgroundColor1;
  Color backgroundColor2;

  init() {
    _allpassTheme = AllpassTheme();
    currTheme = getTheme(Config.theme);
  }

  void changeTheme(String themeName) {
    if (themeName == Config.theme) return;
    currTheme = getTheme(themeName);
    Config.setTheme(themeName);
    notifyListeners();
  }

  ThemeData getTheme(String themeName) {
    if (themeName == "dark") {
      backgroundColor1 = Colors.black;
      backgroundColor2 = Colors.grey[900];
    } else {
      backgroundColor1 = Colors.white;
      backgroundColor2 = Color.fromRGBO(245, 246, 250, 1);
    }
    switch (themeName) {
      case "blue":
        return _allpassTheme.blueTheme();
      case "red":
        return _allpassTheme.redTheme();
      case "teal":
        return _allpassTheme.tealTheme();
      case "deepPurple":
        return _allpassTheme.deepPurpleTheme();
      case "orange":
        return _allpassTheme.orangeTheme();
      case "pink":
        return _allpassTheme.pinkTheme();
      case "blueGrey":
        return _allpassTheme.blueGreyTheme();
      case "dark":
        return _allpassTheme.darkTheme();
      default:
        return _allpassTheme.blueTheme();
    }
  }
}