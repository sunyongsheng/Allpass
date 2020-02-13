import 'package:flutter/material.dart';
import 'package:allpass/application.dart';
import 'package:allpass/params/config.dart';
import 'package:allpass/utils/allpass_ui.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData currTheme;

  init() {
    changeTheme(Application.sp.getString("theme")??"blue");
  }

  void changeTheme(String themeName) {
    switch (themeName) {
      case "blue":
        currTheme = AllpassTheme.blueTheme;
        break;
      case "red":
        currTheme = AllpassTheme.redTheme;
        break;
    }
    Config.theme = themeName;
    Application.sp.setString("theme", themeName);
    notifyListeners();
  }
}