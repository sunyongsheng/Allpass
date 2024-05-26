import 'dart:math';
import 'package:flutter/material.dart';
import 'package:allpass/util/screen_util.dart';

/// 保存所有Allpass用到的文本样式
class AllpassTextUI {
  AllpassTextUI._();

  static final TextStyle titleBarStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.02,
  );

  static final TextStyle firstTitleStyle =
      TextStyle(fontSize: 16);
  static final TextStyle secondTitleStyle =
      TextStyle(fontSize: 14);

  static final TextStyle smallTextStyle =
      TextStyle(fontSize: 12);
  static final TextStyle hintTextStyle =
      TextStyle(fontSize: 16, color: Colors.grey[800]);
}

/// 保存所有Allpass用到的颜色
class AllpassColorUI {
  AllpassColorUI._();
  static final List<Color> allColor = List.of([
    Color.fromRGBO(8, 200, 224, 1),
    Color.fromRGBO(72, 120, 240, 1),
    Colors.amber,
    Colors.deepOrangeAccent,
    Colors.teal,
    Color.fromRGBO(52, 184, 105, 1),
    Color.fromRGBO(255, 86, 85, 1),
    Color.fromRGBO(121, 75, 115, 1),
  ]);

  static final List<Gradient> allGradients = [
    LinearGradient(
      colors: [Color(0xFFa3bded), Color(0xFF6991c7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF74ebd5), Color(0xFF9face6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFe0c3fc), Color(0xFF8ec5fc)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF0ba360), Color(0xFF3cba92)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF6a85b6), Color(0xFFbac8e0)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF13547a), Color(0xFF80d0c7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFff758c), Color(0xFFff7eb3)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFc79081), Color(0xFFdfa579)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFdcb0ed), Color(0xFF99c99c)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF96deda), Color(0xFF50c9c3)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];
}

/// 缩进样式
class AllpassEdgeInsets {
  AllpassEdgeInsets._();

  static EdgeInsets listInset = EdgeInsets.only(
    left: AllpassScreenUtil.setWidth(30),
    right: AllpassScreenUtil.setWidth(30),
  );

  static EdgeInsets widgetItemInset = EdgeInsets.symmetric(
    horizontal: AllpassScreenUtil.setHeight(42),
  );

  static EdgeInsets dividerInset = EdgeInsets.only(
    left: AllpassScreenUtil.setWidth(70),
    right: AllpassScreenUtil.setWidth(70),
  );

  static EdgeInsets forViewCardInset = EdgeInsets.only(
    left: AllpassScreenUtil.setWidth(70),
    right: AllpassScreenUtil.setWidth(70),
    top: AllpassScreenUtil.setHeight(25),
    bottom: AllpassScreenUtil.setHeight(25),
  );

  static EdgeInsets forCardInset = EdgeInsets.only(
      left: AllpassScreenUtil.setWidth(30),
      right: AllpassScreenUtil.setWidth(30),
      top: AllpassScreenUtil.setHeight(15),
      bottom: AllpassScreenUtil.setHeight(25));

  static EdgeInsets settingCardInset = EdgeInsets.symmetric(
      vertical: AllpassScreenUtil.setHeight(20),
      horizontal: AllpassScreenUtil.setWidth(50)
  );
  static EdgeInsets forSearchButtonInset = EdgeInsets.only(
      left: AllpassScreenUtil.setWidth(50),
      right: AllpassScreenUtil.setWidth(50),
      bottom: AllpassScreenUtil.setHeight(15));

  static EdgeInsets smallTBPadding = EdgeInsets.only(
    top: AllpassScreenUtil.setHeight(25),
    bottom: AllpassScreenUtil.setHeight(25),
  );

  static EdgeInsets smallLPadding = EdgeInsets.only(
    left: AllpassScreenUtil.setWidth(50),
  );

  static EdgeInsets smallRPadding = EdgeInsets.only(
    right: AllpassScreenUtil.setWidth(50),
  );

  static EdgeInsets smallTopInsets = EdgeInsets.only(
    top: AllpassScreenUtil.setHeight(15)
  );

  static EdgeInsets bottom10Inset = EdgeInsets.only(
      left: AllpassScreenUtil.setWidth(100),
      right: AllpassScreenUtil.setWidth(100),
      bottom: AllpassScreenUtil.setHeight(10));

  static EdgeInsets bottom30Inset = EdgeInsets.only(
      left: AllpassScreenUtil.setWidth(100),
      right: AllpassScreenUtil.setWidth(100),
      bottom: AllpassScreenUtil.setHeight(30));

  static EdgeInsets bottom50Inset = EdgeInsets.only(
      left: AllpassScreenUtil.setWidth(100),
      right: AllpassScreenUtil.setWidth(100),
      bottom: AllpassScreenUtil.setHeight(50));
}

/// 其他样式
class AllpassUI {
  AllpassUI._();
  static const Radius smallRadius = const Radius.circular(8.0);
  static const BorderRadius smallBorderRadius = const BorderRadius.all(smallRadius);
}

Color getRandomColor({int? seed}) {
  if (seed == null) seed = Object().hashCode;
  Random random = Random(seed);
  int i = random.nextInt(AllpassColorUI.allColor.length - 1);
  return AllpassColorUI.allColor[i];
}

var index = 0;
Gradient getNextGradient() {
  if (index == AllpassColorUI.allGradients.length) {
    index = 0;
  }
  var gradient = AllpassColorUI.allGradients[index];
  index++;
  return gradient;
}

Color getCenterColor(List<Color> colors) {
  var start = colors.first;
  var end = colors.last;
  var red = (start.red + end.red) / 2;
  var blue = (start.blue + end.blue) / 2;
  var green = (start.green + end.green) / 2;
  return Color.fromARGB(255, red.toInt(), green.toInt(), blue.toInt());
}
