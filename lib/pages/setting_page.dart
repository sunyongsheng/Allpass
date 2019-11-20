import 'package:allpass/params/changed.dart';
import 'package:flutter/material.dart';

import 'package:allpass/utils/allpass_ui.dart';

/// 设置页面
class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _SettingPage();
}

class _SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<_SettingPage> {
  var _value = "默认";
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
      Navigator.of(context).pop();
      return Future<bool>.value(false);
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text("设置", style: AllpassTextUI.mainTitleStyle,),
        centerTitle: true,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(child:Column(
        children: <Widget>[
          Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                DropdownButton(
                  value: _value,
                  onChanged: (newValue) {
                    setState(() {
                      _value = newValue;
                    });
                  },
                  items: FolderAndLabelList.folderList
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  style: AllpassTextUI.firstTitleStyleBlack,
                  elevation: 8,
                  iconSize: 30,
                ),
              ],
            ),
          ),
        ],
      ),),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
    )
    );
  }
}