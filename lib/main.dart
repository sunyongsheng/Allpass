import 'package:flutter/material.dart';

import 'package:allpass/bottom_navigation.dart';
import 'package:allpass/utils/test_data.dart';

void main() {
  PasswordTestData(); // 初始化测试数据
  CardTestData();   // 初始化测试数据

  runApp(Allpass());
}

class Allpass extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Allpass',
      theme: ThemeData.light(),
      home: BottomNavigationWidget(),
    );
  }
}
