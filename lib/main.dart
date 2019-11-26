import 'package:flutter/material.dart';

import 'package:allpass/bottom_navigation.dart';
import 'package:allpass/params/params.dart';

void main() {
  Params.paramsInit();
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
