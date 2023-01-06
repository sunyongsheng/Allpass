import 'package:allpass/core/error/app_error.dart';
import 'package:flutter/material.dart';

class ThemeModes {
  static ThemeMode parse(String name) {
    if (name == ThemeMode.light.name) {
      return ThemeMode.light;
    } else if (name == ThemeMode.dark.name) {
      return ThemeMode.dark;
    } else if (name == ThemeMode.system.name) {
      return ThemeMode.system;
    }

    throw UnsupportedArgumentException("Unsupported name=$name");
  }
}

class ThemeModeItem {
  final ThemeMode mode;
  final String desc;
  final IconData icon;
  final Color iconColor;

  ThemeModeItem(this.mode, this.desc, this.icon, this.iconColor);
}

var themeModes = [
  ThemeModeItem(ThemeMode.system, "跟随系统", Icons.auto_awesome, Color.fromARGB(255, 253, 173, 175)),
  ThemeModeItem(ThemeMode.light, "浅色", Icons.wb_sunny_outlined, Color.fromARGB(255, 236, 201, 173)),
  ThemeModeItem(ThemeMode.dark, "深色", Icons.nightlight_outlined, Color.fromARGB(255, 60, 235, 229))
];

enum PrimaryColor {
  blue,
  red,
  teal,
  deepPurple,
  orange,
  pink,
  blueGrey
}

class PrimaryColorItem {
  final PrimaryColor primaryColor;
  final String desc;
  final Color color;

  PrimaryColorItem(this.primaryColor, this.desc, this.color);
}

var primaryColors = [
  PrimaryColorItem(PrimaryColor.blue, "蓝色", Colors.blue),
  PrimaryColorItem(PrimaryColor.red, "红色", Colors.red),
  PrimaryColorItem(PrimaryColor.teal, "青色", Colors.teal),
  PrimaryColorItem(PrimaryColor.deepPurple, "深紫", Colors.deepPurple),
  PrimaryColorItem(PrimaryColor.orange, "橙色", Colors.orange),
  PrimaryColorItem(PrimaryColor.pink, "粉色", Colors.pink),
  PrimaryColorItem(PrimaryColor.blueGrey, "蓝灰", Colors.blueGrey),
];