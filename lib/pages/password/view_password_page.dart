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
import 'package:allpass/pages/password/edit_password_page.dart';
import 'package:allpass/widgets/confirm_dialog.dart';


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
  PasswordBean _bean;

  bool _passwordVisible = false;

  String _password = "";

  _ViewPasswordPage(PasswordBean data) {
    _bean = PasswordBean(
        username: data.username,
        password: data.password,
        url: data.url,
        key: data.uniqueKey,
        name: data.name,
        folder: data.folder,
        label: data.label,
        notes: data.notes,
        fav: data.fav);

    // 如果文件夹未知，添加
    if (!Params.folderList.contains(_bean.folder)) {
      Params.folderList.add(_bean.folder);
    }
    // 检查标签未知，添加
    for (var label in _bean.label) {
      if (!Params.labelList.contains(label)) {
        Params.labelList.add(label);
      }
    }
  }

  Future<Null> _decryptPassword() async {
    _password =  await EncryptUtil.decrypt(_bean.password);
  }

  @override
  void initState() {
    _decryptPassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_bean.isChanged) {
          Navigator.pop<PasswordBean>(context, _bean);
        } else {
          Navigator.pop<PasswordBean>(context, null);
        }
        return Future<bool>.value(false);
      },
      child: Scaffold(
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
                                getRandomColor(_bean.uniqueKey),
                                child: Text(
                                  _bean.name.substring(0, 1),
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
                                    _bean.name,
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
                                          child: Text(_bean.folder),
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
                                  child: Text(_bean.username,
                                    overflow: TextOverflow.ellipsis,
                                    style: AllpassTextUI.firstTitleStyleBlack,
                                  ),
                                ),
                                Padding(padding: AllpassEdgeInsets.smallLPadding,),
                                InkWell(
                                  child: Text("复制", style: AllpassTextUI.secondTitleStyleBlue,),
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: _bean.username));
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
                                        if (_bean.url.startsWith("https")
                                            || _bean.url.startsWith("http"))
                                          await launch(_bean.url);
                                      },
                                      child: Text(_bean.url,
                                        overflow: TextOverflow.ellipsis,
                                        style: AllpassTextUI.firstTitleStyleBlack,
                                      ),
                                    )
                                ),
                                Padding(padding: AllpassEdgeInsets.smallLPadding,),
                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: _bean.url));
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton(
                      heroTag: "edit",
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => EditPasswordPage(_bean, "编辑密码")
                        )).then((bean) {
                          if (bean.isChanged) {
                            setState(() {
                              _bean = bean;
                            });
                          }
                        });
                      },
                      child: Icon(Icons.edit),
                    ),
                    Padding(padding: AllpassEdgeInsets.smallLPadding,),
                    FloatingActionButton(
                      heroTag: "delete",
                      backgroundColor: Colors.redAccent,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => ConfirmDialog("你将删除此密码，确认吗？")).then((delete) {
                          if (delete) {
                            // 如果想删除，则先将isChanged属性改为false
                            // 否则如果先修改再删除会导致password页不删除
                            _bean.isChanged = false;
                            Navigator.pop<PasswordBean>(context, _bean);
                          }
                        });
                      },
                      child: Icon(Icons.delete),
                    ),
                  ],
                )
              ],
            ),
          ),
        )));
  }

  List<Widget> _getTag() {
    List<Widget> labelChoices = List();
    _bean.label.forEach((item) {
      labelChoices.add(ChoiceChip(
        label: Text(
          item,
          style: TextStyle(fontSize: 10),
        ),
        labelStyle: AllpassTextUI.secondTitleStyleBlack,
        selected: _bean.label.contains(item),
        onSelected: (selected) {},
        selectedColor: AllpassColorUI.mainColor,
      ));
    });
    return labelChoices;
  }
}
