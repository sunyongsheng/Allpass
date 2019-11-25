import 'package:flutter/material.dart';

import 'package:allpass/bottom_navigation.dart';
import 'package:allpass/params/params.dart';

void main() {
  Params.paramsInit();
  runApp(Allpass());
}

class Allpass extends StatelessWidget {

  // TODO 标签中不允许 ~ 符号，文件夹不允许英文逗号
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Allpass',
      theme: ThemeData.light(),
      home: BottomNavigationWidget(),
    );
  }
}
