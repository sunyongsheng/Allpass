import 'package:allpass/core/param/config.dart';
import 'package:allpass/setting/theme/theme_mode.dart';
import 'package:allpass/setting/theme/theme_resource.dart';
import 'package:flutter/material.dart';

class AppTheme {
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;

  AppTheme(this.lightTheme, this.darkTheme, this.themeMode);
}

class ThemeProvider with ChangeNotifier {
  late AllpassTheme _allpassTheme;

  late ThemeData _lightTheme;
  late ThemeData _darkTheme;
  late ThemeMode _themeMode;

  AppTheme get appTheme => AppTheme(_lightTheme, _darkTheme, _themeMode);

  /// 特殊的背景颜色
  /// 少部分页面背景颜色为浅白色
  late Color specialBackgroundColor;
  late Color offstageColor;

  init() {
    _allpassTheme = AllpassTheme();
    _themeMode = Config.themeMode;
    _lightTheme = _convertTheme(Config.primaryColor, false);
    _darkTheme = _convertTheme(Config.primaryColor, true);
  }

  void changeThemeMode(ThemeMode targetMode, Brightness platformBrightness) {
    _themeMode = targetMode;
    Config.setThemeMode(targetMode);
    setExtraColor(platformBrightness);
  }

  void changePrimaryColor(PrimaryColor color, Brightness platformBrightness) {
    _lightTheme = _convertTheme(color, false);
    _darkTheme = _convertTheme(color, true);
    Config.setPrimaryColor(color);
    setExtraColor(platformBrightness);
  }

  ThemeData _convertTheme(PrimaryColor color, bool dark) {
    return switch (color) {
      PrimaryColor.blue => _allpassTheme.blueTheme(dark),
      PrimaryColor.red => _allpassTheme.redTheme(dark),
      PrimaryColor.teal => _allpassTheme.tealTheme(dark),
      PrimaryColor.deepPurple => _allpassTheme.deepPurpleTheme(dark),
      PrimaryColor.orange => _allpassTheme.orangeTheme(dark),
      PrimaryColor.pink => _allpassTheme.pinkTheme(dark),
      PrimaryColor.blueGrey => _allpassTheme.blueGreyTheme(dark),
    };
  }

  void setExtraColor(Brightness platformBrightness) {
    if (_themeMode == ThemeMode.system) {
      _setExtraColorAuto(platformBrightness);
    } else if (_themeMode == ThemeMode.dark) {
      _setExtraColorDarkMode();
    } else {
      _setExtraColorLightMode();
    }
    notifyListeners();
  }

  void _setExtraColorLightMode() {
    specialBackgroundColor = Color.fromRGBO(245, 246, 250, 1);
    offstageColor = Colors.black87;
  }

  void _setExtraColorDarkMode() {
    specialBackgroundColor = Colors.black;
    offstageColor = Colors.grey[600]!;
  }

  void _setExtraColorAuto(Brightness platformBrightness) {
    if (platformBrightness == Brightness.dark) {
      _setExtraColorDarkMode();
    } else {
      _setExtraColorLightMode();
    }
  }
}
