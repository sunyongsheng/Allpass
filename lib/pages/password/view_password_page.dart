import 'package:allpass/params/params.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:allpass/model/password_bean.dart';
import 'package:allpass/utils/allpass_ui.dart';

/// 查看密码页
class ViewPasswordPage extends StatefulWidget {
  final PasswordBean oldData;

  ViewPasswordPage(this.oldData);

  @override
  State<StatefulWidget> createState() {
    return _ViewPasswordPage(oldData);
  }

}

class _ViewPasswordPage extends State<ViewPasswordPage> {

  PasswordBean _oldData;
  PasswordBean _tempData;

  bool _passwordVisible = false;


  _ViewPasswordPage(PasswordBean data) {
    this._oldData = data;
    _tempData = PasswordBean(
        username: _oldData.username,
        password: _oldData.password,
        url: _oldData.url,
        key: _oldData.uniqueKey,
        name: _oldData.name,
        folder: _oldData.folder,
        label: _oldData.label,
        notes: _oldData.notes,
        fav: _oldData.fav);

    // 如果文件夹未知，添加
    if (!Params.folderList.contains(_tempData.folder)) {
      Params.folderList.add(_tempData.folder);
    }
    // 检查标签未知，添加
    for (var label in _tempData.label) {
      if (!Params.labelList.contains(label)) {
        Params.labelList.add(label);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("查看密码", style: AllpassTextUI.mainTitleStyle,),
        centerTitle: true,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        elevation: 0,
        brightness: Brightness.light,
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 150,
                width: 330,
                margin: EdgeInsets.only(bottom: 20, top: 10),
                child: Card(
                  color: AllpassColorUI.mainBackgroundColor,
                  elevation: 8,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: getRandomColor(_tempData.uniqueKey),
                            child: Text(_tempData.name.substring(0, 1), style: TextStyle(fontSize: 40, color: Colors.white),),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 0),
                              child: Text(_tempData.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            ),
                            Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 4.0,
                                runSpacing: 5.0,
                                children: _getTag()),
                          ],
                        )
                      ],
                    ),
                  )
                ),
              ),
              Container(
                height: 400,
                width: 330,
                margin: EdgeInsets.only(bottom: 0, top: 10),
                child: Card(
                  color: AllpassColorUI.mainBackgroundColor,
                  elevation: 8,
                  child: Column(
                    children: <Widget>[
                      Text(_tempData.name, style: AllpassTextUI.mainTitleStyle,),
                    ],
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.edit),
              ),
            ],
          ),
        ),
      )
    );
  }

  List<Widget> _getTag() {
    List<Widget> labelChoices = List();
    _tempData.label.forEach((item) {
      labelChoices.add(ChoiceChip(
        label: Text(item, style: TextStyle(fontSize: 10),),
        labelStyle: AllpassTextUI.secondTitleStyleBlack,
        selected: _tempData.label.contains(item),
        onSelected: (selected) {},
        selectedColor: AllpassColorUI.mainColor,
      ));
    });
    return labelChoices;
  }
}