import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeUtil {
  ThemeUtil._();

  static bool isInDarkTheme(BuildContext context) {
    var themeMode = context.read<ThemeProvider>().themeMode;
    return themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
  }
}
