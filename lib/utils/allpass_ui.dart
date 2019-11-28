import 'dart:math';

import 'package:flutter/material.dart';

/// 保存所有Allpass用到的文本样式
class AllpassTextUI {
  AllpassTextUI._();

  static final TextStyle mainTitleStyle =
      TextStyle(fontSize: 17, color: Colors.black,);
  static final TextStyle firstTitleStyleBlue =
      TextStyle(fontSize: 16, color: Colors.blue);
  static final TextStyle secondTitleStyleBlue =
      TextStyle(fontSize: 14, color: Colors.blue);

  static final TextStyle firstTitleStyleBlack =
      TextStyle(fontSize: 16, color: Colors.black);
  static final TextStyle secondTitleStyleBlack =
      TextStyle(fontSize: 14, color: Colors.black);

  static final TextStyle smallTextStyleBlack =
      TextStyle(fontSize: 12, color: Colors.black);
  static final TextStyle hintTextStyle =
      TextStyle(fontSize: 14, color: Colors.black54);
}

/// 保存所有Allpass用到的颜色
class AllpassColorUI {
  AllpassColorUI._();

  static final Color mainColor = Colors.blue;
  static final Color mainBackgroundColor = Colors.white;
  static final List<Color> allColor = List.of([
    Color.fromARGB(255, 5, 118, 285),   // PPHub 蓝
    Colors.amber,
    Colors.deepOrangeAccent,
    Colors.teal,
    Color.fromARGB(255, 52, 184, 105),  // PPHub 绿
    Color.fromARGB(255, 255, 86, 85),   // 番茄todo 红
  ]);
}

Color getRandomColor(int seed) {
  Random random = Random(seed);
  int i = random.nextInt(AllpassColorUI.allColor.length - 1);
  return AllpassColorUI.allColor[i];
}
