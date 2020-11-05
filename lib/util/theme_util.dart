import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:allpass/core/param/config.dart';

class ThemeUtil {
  static bool isInDarkTheme(BuildContext context) {
    return Config.themeMode == "dark"
        || (Config.themeMode == "system" && MediaQuery.platformBrightnessOf(context) == Brightness.dark);
  }
}