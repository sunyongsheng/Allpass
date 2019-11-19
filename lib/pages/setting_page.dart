import 'package:flutter/material.dart';

import 'package:allpass/utils/allpass_ui.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _SettingPage();
}

class _SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<_SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置", style: AllpassTextUI.mainTitleStyle,),
        centerTitle: true,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        elevation: 0,
      ),
      body: Text("设置"),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
    );
  }
}