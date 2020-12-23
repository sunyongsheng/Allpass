import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:allpass/core/param/constants.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/util/theme_util.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:allpass/common/page/detail_text_page.dart';
import 'package:allpass/password/page/edit_password_page.dart';
import 'package:allpass/common/widget/label_chip.dart';
import 'package:allpass/common/widget/confirm_dialog.dart';

/// 查看密码页
class ViewPasswordPage extends StatefulWidget {

  final int index;

  ViewPasswordPage(this.index);

  @override
  State<StatefulWidget> createState() {
    return _ViewPasswordPage();
  }
}

class _ViewPasswordPage extends State<ViewPasswordPage> {

  bool _passwordVisible = false;

  String _password = "";
  String _cache = "noCache";
  Color _mainColor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (ThemeUtil.isInDarkTheme(context)) {
          _mainColor = Provider.of<ThemeProvider>(context).darkTheme.primaryColor;
        } else {
          _mainColor = Provider.of<ThemeProvider>(context).lightTheme.primaryColor;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    PasswordProvider provider = Provider.of<PasswordProvider>(context);
    PasswordBean bean = provider.passwordList[widget.index];
    if (_cache != bean.password) {
      _password = EncryptUtil.decrypt(bean.password);
      _cache = bean.password;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "查看密码",
            style: AllpassTextUI.titleBarStyle,
          ),
          centerTitle: true,
          actions: <Widget>[
            bean.fav == 1
                ? Icon(Icons.favorite, color: Colors.redAccent,)
                : Icon(Icons.favorite_border),
            Padding(padding: AllpassEdgeInsets.smallLPadding,),
            Padding(padding: AllpassEdgeInsets.smallLPadding,)
          ],
        ),
        backgroundColor: Provider.of<ThemeProvider>(context).specialBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: AllpassEdgeInsets.forViewCardInset,
                child: Card(
                  elevation: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 23, horizontal: 0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: bean.color,
                          child: Text(
                            bean.name.substring(0, 1),
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: AllpassEdgeInsets.smallLPadding,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: AllpassScreenUtil.setWidth(450)
                                ),
                                child: Text(bean.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                                ),
                              )
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 0, right: 5, top: 3, bottom: 0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.folder_open),
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    color: Colors.grey[250],
                                    child: Container(
                                      child: Text(bean.folder,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      width: 50,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: AllpassEdgeInsets.forViewCardInset,
                child: Card(
                    elevation: 0,
                    child: SizedBox(
                      width: ScreenUtil.screenWidth * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: AllpassEdgeInsets.smallTBPadding,),
                          // 账号标题
                          Container(
                            margin: EdgeInsets.only(
                                left: AllpassScreenUtil.setWidth(100),
                                right: AllpassScreenUtil.setWidth(100),
                                bottom: AllpassScreenUtil.setHeight(10)),
                            child: Text("账号", style: TextStyle(fontSize: 16, color: _mainColor),
                            ),
                          ),
                          // 用户名主体
                          Container(
                            margin: EdgeInsets.only(
                                left: AllpassScreenUtil.setWidth(100),
                                right: AllpassScreenUtil.setWidth(100),
                                bottom: AllpassScreenUtil.setHeight(50)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(bean.username,
                                    overflow: TextOverflow.ellipsis,
                                    style: AllpassTextUI.firstTitleStyle,
                                  ),),
                                Padding(padding: AllpassEdgeInsets.smallLPadding,),
                                InkWell(
                                  child: Text("复制", style: TextStyle(fontSize: 14, color: _mainColor),),
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: bean.username));
                                    Fluttertoast.showToast(msg: "已复制账号");
                                  },
                                )
                              ],
                            ),
                          ),
                          // 密码标题
                          Container(
                            margin: EdgeInsets.only(
                                left: AllpassScreenUtil.setWidth(100),
                                right: AllpassScreenUtil.setWidth(100),
                                bottom: AllpassScreenUtil.setHeight(10)),
                            child: Text("密码", style: TextStyle(fontSize: 16, color: _mainColor),),
                          ),
                          // 密码主体
                          Container(
                            margin: EdgeInsets.only(
                                left: AllpassScreenUtil.setWidth(100),
                                right: AllpassScreenUtil.setWidth(100),
                                bottom: AllpassScreenUtil.setHeight(30)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(_passwordVisible
                                      ? _password
                                      : "*" * _password.length,
                                    overflow: TextOverflow.ellipsis,
                                    style: AllpassTextUI.firstTitleStyle,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    InkWell(
                                      child: _passwordVisible
                                          ? Icon(Icons.visibility)
                                          : Icon(Icons.visibility_off),
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
                                      child: Text("复制",
                                        style: TextStyle(fontSize: 14, color: _mainColor),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          // 链接标题
                          Container(
                            margin: EdgeInsets.only(
                                left: AllpassScreenUtil.setWidth(100),
                                right: AllpassScreenUtil.setWidth(100),
                                bottom: AllpassScreenUtil.setHeight(10)),
                            child: Text("链接",
                                style: TextStyle(fontSize: 16, color: _mainColor)
                            ),
                          ),
                          // 链接主体
                          Container(
                            margin: EdgeInsets.only(
                                left: AllpassScreenUtil.setWidth(100),
                                right: AllpassScreenUtil.setWidth(100),
                                bottom: AllpassScreenUtil.setHeight(50)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        if (bean.url.startsWith("https")
                                            || bean.url.startsWith("http"))
                                          await launch(bean.url);
                                      },
                                      child: Text(bean.url,
                                        overflow: TextOverflow.ellipsis,
                                        style: AllpassTextUI
                                            .firstTitleStyle,
                                      ),
                                      onLongPress: () => Fluttertoast.showToast(msg: bean.url),
                                    )),
                                Padding(padding: AllpassEdgeInsets.smallLPadding,),
                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: bean.url));
                                    Fluttertoast.showToast(msg: "已复制链接");
                                  },
                                  child: Text("复制",
                                    style: TextStyle(fontSize: 14, color: _mainColor),
                                  ),
                                )
                              ],
                            ),
                          ),
                          // 备注标题
                          Container(
                            margin: EdgeInsets.only(
                                left: AllpassScreenUtil.setWidth(100),
                                right: AllpassScreenUtil.setWidth(100),
                                bottom: AllpassScreenUtil.setHeight(10)),
                            child: Text("备注",
                              style: TextStyle(fontSize: 16, color: _mainColor),
                            ),
                          ),
                          // 备注主体
                          Container(
                            margin: EdgeInsets.only(
                                left: AllpassScreenUtil.setWidth(100),
                                right: AllpassScreenUtil.setWidth(100),
                                bottom: AllpassScreenUtil.setHeight(50)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if (bean.notes.length >= 1) {
                                          Navigator.push(context, CupertinoPageRoute(
                                            builder: (context) => DetailTextPage("备注", bean.notes, false),));
                                        }
                                      },
                                      child: Text(bean.notes.length<1?"无备注":bean.notes,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: bean.notes.length<1
                                            ?AllpassTextUI.hintTextStyle
                                            :AllpassTextUI.firstTitleStyle,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          // 标签标题
                          Container(
                            margin: EdgeInsets.only(
                                left: AllpassScreenUtil.setWidth(100),
                                right: AllpassScreenUtil.setWidth(100),
                                bottom: AllpassScreenUtil.setHeight(10)),
                            child: Text("标签",
                              style: TextStyle(fontSize: 16, color: _mainColor),
                            ),
                          ),
                          // 标签主体
                          Container(
                            margin: EdgeInsets.only(
                                left: AllpassScreenUtil.setWidth(100),
                                right: AllpassScreenUtil.setWidth(100),
                                bottom: AllpassScreenUtil.setHeight(50)),
                            child: Wrap(
                              children: _getTag(bean),
                              spacing: 5,
                            ),
                          )
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: AllpassEdgeInsets.smallTBPadding,
              ),
              // 最下面一行点击按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: "edit",
                    backgroundColor: Colors.blueAccent,
                    elevation: 0,
                    onPressed: () {
                      Navigator.push(context,
                          CupertinoPageRoute(
                              builder: (context) => EditPasswordPage(bean, DataOperation.update)));
                    },
                    child: Icon(Icons.edit),
                  ),
                  Padding(
                    padding: AllpassEdgeInsets.smallLPadding,
                  ),
                  FloatingActionButton(
                    heroTag: "oneKeyCopy",
                    elevation: 0,
                    backgroundColor: Colors.green,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text:
                      "账号：${bean.username}\n密码：$_password"
                      ));
                      Fluttertoast.showToast(msg: "已复制账号及密码");
                    },
                    child: Icon(Icons.content_copy),
                  ),
                  Padding(
                    padding: AllpassEdgeInsets.smallLPadding,
                  ),
                  FloatingActionButton(
                    heroTag: "delete",
                    elevation: 0,
                    backgroundColor: Colors.redAccent,
                    onPressed: () async {
                      bool delete = await showDialog(
                          context: context,
                          builder: (context) => ConfirmDialog("确认删除", "你将删除此密码，确认吗？"));
                      if (delete) {
                        await provider.deletePassword(bean);
                        Navigator.pop(context);
                      }
                    },
                    child: Icon(Icons.delete),
                  ),
                ],
              ),
              Padding(
                padding: AllpassEdgeInsets.smallTBPadding,
              )
            ],
          ),
        ));
  }

  List<Widget> _getTag(PasswordBean bean) {
    List<Widget> labelChoices = List();
    bean.label.forEach((item) {
      labelChoices.add(LabelChip(
          text: item,
          selected: true,
      ));
    });
    if (labelChoices.length == 0) {
      labelChoices.add(Text("无标签", style: AllpassTextUI.hintTextStyle,));
    }
    return labelChoices;
  }
}
