import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:allpass/params/params.dart';
import 'package:allpass/model/password_bean.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/encrypt_util.dart';
import 'package:allpass/utils/screen_util.dart';
import 'package:allpass/pages/password/view_and_edit_password_page.dart';

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

  String _password = "";

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

  Future<Null> _decryptPassword() async {
    _password =  await EncryptUtil.decrypt(_tempData.password);
  }

  @override
  void initState() {
    _decryptPassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "查看密码",
            style: AllpassTextUI.titleBarStyle,
          ),
          centerTitle: true,
          backgroundColor: AllpassColorUI.mainBackgroundColor,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          brightness: Brightness.light,
        ),
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Card(
                  margin: EdgeInsets.only(
                    top: AllpassScreenUtil.setHeight(50),
                      left: AllpassScreenUtil.setWidth(80),
                      right: AllpassScreenUtil.setWidth(80),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  color: AllpassColorUI.mainBackgroundColor,
                  elevation: 8,
                  child: SizedBox(
                      width: ScreenUtil.screenWidth * 0.8,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor:
                                    getRandomColor(_tempData.uniqueKey),
                                child: Text(
                                  _tempData.name.substring(0, 1),
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    _tempData.name,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(
                                        left: 5, right: 5, top: 3, bottom: 3),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.folder_open),
                                        Container(
                                          margin: EdgeInsets.only(left: 5),
                                          color: Colors.grey[250],
                                          child: Text(_tempData.folder),
                                        ),
                                      ],
                                    )),
                              ],
                            )
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                ),
                Card(
                    margin: EdgeInsets.only(
                        left: AllpassScreenUtil.setWidth(80),
                        right: AllpassScreenUtil.setWidth(80)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    color: AllpassColorUI.mainBackgroundColor,
                    elevation: 8,
                    child: SizedBox(
                      width: ScreenUtil.screenWidth * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: AllpassEdgeInsets.smallTBPadding,),
                          Container(
                            margin: EdgeInsets.only(
                              left: AllpassScreenUtil.setWidth(100),
                              right: AllpassScreenUtil.setWidth(100),
                              bottom: AllpassScreenUtil.setHeight(10)
                            ),
                            child: Text("用户名", style: AllpassTextUI.firstTitleStyleBlue,),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: AllpassScreenUtil.setWidth(100),
                                right: AllpassScreenUtil.setWidth(100),
                                bottom: AllpassScreenUtil.setHeight(50)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(_tempData.username,
                                    overflow: TextOverflow.ellipsis,
                                    style: AllpassTextUI.firstTitleStyleBlack,
                                  ),
                                ),
                                Padding(padding: AllpassEdgeInsets.smallLPadding,),
                                InkWell(
                                  child: Text("复制", style: AllpassTextUI.secondTitleStyleBlue,),
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: _tempData.username));
                                    Fluttertoast.showToast(msg: "已复制用户名");
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: AllpassScreenUtil.setWidth(100),
                              right: AllpassScreenUtil.setWidth(100),
                              bottom: AllpassScreenUtil.setHeight(10)
                            ),
                            child: Text("密码", style: AllpassTextUI.firstTitleStyleBlue,),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: AllpassScreenUtil.setWidth(100),
                                right: AllpassScreenUtil.setWidth(100),
                                bottom: AllpassScreenUtil.setHeight(30)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(_passwordVisible?_password:"*"*_password.length,
                                    overflow: TextOverflow.ellipsis,
                                    style: AllpassTextUI.firstTitleStyleBlack,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    InkWell(
                                      child: _passwordVisible
                                          ?Icon(Icons.visibility)
                                          :Icon(Icons.visibility_off),
                                      onTap: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                    Padding(padding: AllpassEdgeInsets.smallLPadding,),
                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(text: _password));
                                        Fluttertoast.showToast(msg: "已复制密码");
                                      },
                                      child: Text("复制", style: AllpassTextUI.secondTitleStyleBlue,),)
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: AllpassScreenUtil.setWidth(100),
                              right: AllpassScreenUtil.setWidth(100),
                              bottom: AllpassScreenUtil.setHeight(10)
                            ),
                            child: Text("链接", style: AllpassTextUI.firstTitleStyleBlue,),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: AllpassScreenUtil.setWidth(100),
                                right: AllpassScreenUtil.setWidth(100),
                                bottom: AllpassScreenUtil.setHeight(50)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      if (_tempData.url.startsWith("https")
                                          || _tempData.url.startsWith("http"))
                                        await launch(_tempData.url);
                                    },
                                    child: Text(_tempData.url,
                                      overflow: TextOverflow.ellipsis,
                                      style: AllpassTextUI.firstTitleStyleBlack,
                                    ),
                                  )
                                ),
                                Padding(padding: AllpassEdgeInsets.smallLPadding,),
                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: _tempData.url));
                                    Fluttertoast.showToast(msg: "已复制链接");
                                  },
                                  child: Text("复制", style: AllpassTextUI.secondTitleStyleBlue,),)
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ViewAndEditPasswordPage(_tempData, "编辑密码", false)
                    ));
                  },
                  child: Icon(Icons.edit),
                ),
              ],
            ),
          ),
        ));
  }

  List<Widget> _getTag() {
    List<Widget> labelChoices = List();
    _tempData.label.forEach((item) {
      labelChoices.add(ChoiceChip(
        label: Text(
          item,
          style: TextStyle(fontSize: 10),
        ),
        labelStyle: AllpassTextUI.secondTitleStyleBlack,
        selected: _tempData.label.contains(item),
        onSelected: (selected) {},
        selectedColor: AllpassColorUI.mainColor,
      ));
    });
    return labelChoices;
  }
}
