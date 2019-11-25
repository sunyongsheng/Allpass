import 'package:flutter/material.dart';

import 'package:allpass/bottom_navigation.dart';

void main() {
  runApp(Allpass());
}

class Allpass extends StatelessWidget {

  // TODO 标签中不允许 ~ 符号
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Allpass',
      theme: ThemeData.light(),
      home: BottomNavigationWidget(),
    );
  }
}
