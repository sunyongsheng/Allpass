import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_apps/device_apps.dart';

import 'package:allpass/core/param/constants.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:allpass/common/page/detail_text_page.dart';
import 'package:allpass/password/page/edit_password_page.dart';
import 'package:allpass/common/widget/label_chip.dart';
import 'package:allpass/common/widget/confirm_dialog.dart';

/// 查看密码页
class ViewPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ViewPasswordPage();
  }
}

class _ViewPasswordPage extends State<ViewPasswordPage> {

  bool passwordVisible = false;
  String password = "";
  String cache = "noCache";

  bool deleted = false;

  @override
  Widget build(BuildContext context) {
    if (deleted) return Container();

    PasswordProvider provider = context.watch();
    PasswordBean bean = provider.currPassword;
    Color mainColor = Theme.of(context).primaryColor;

    if (bean == PasswordBean.empty) {
      ToastUtil.show(msg: "出现了错误");
      Navigator.pop(context);
      return Container();
    }

    if (cache != bean.password) {
      password = EncryptUtil.decrypt(bean.password);
      cache = bean.password;
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
        backgroundColor: context.watch<ThemeProvider>().specialBackgroundColor,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: AllpassEdgeInsets.smallTBPadding,),
                        // 账号标题
                        _titleContainer(mainColor, "账号"),
                        // 用户名主体
                        Container(
                          margin: AllpassEdgeInsets.bottom50Inset,
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
                                child: Text("复制", style: TextStyle(fontSize: 14, color: mainColor),),
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: bean.username));
                                  ToastUtil.show(msg: "已复制账号");
                                },
                              )
                            ],
                          ),
                        ),
                        // 密码标题
                        _titleContainer(mainColor, "密码"),
                        // 密码主体
                        Container(
                          margin: AllpassEdgeInsets.bottom30Inset,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(passwordVisible
                                    ? password
                                    : "*" * password.length,
                                  overflow: TextOverflow.ellipsis,
                                  style: AllpassTextUI.firstTitleStyle,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  InkWell(
                                    child: passwordVisible
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                                    onTap: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                  ),
                                  Padding(padding: AllpassEdgeInsets.smallLPadding,),
                                  InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(text: password));
                                      ToastUtil.show(msg: "已复制密码");
                                    },
                                    child: Text("复制",
                                      style: TextStyle(fontSize: 14, color: mainColor),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        // 链接标题
                        _titleContainer(mainColor, "链接"),
                        // 链接主体
                        Container(
                          margin: AllpassEdgeInsets.bottom50Inset,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      if (bean.url.startsWith("https")
                                          || bean.url.startsWith("http"))
                                        await launchUrl(Uri.parse(bean.url));
                                    },
                                    child: Text(bean.url,
                                      overflow: TextOverflow.ellipsis,
                                      style: AllpassTextUI
                                          .firstTitleStyle,
                                    ),
                                    onLongPress: () => ToastUtil.show(msg: bean.url),
                                  )),
                              Padding(padding: AllpassEdgeInsets.smallLPadding,),
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: bean.url));
                                  ToastUtil.show(msg: "已复制链接");
                                },
                                child: Text("复制",
                                  style: TextStyle(fontSize: 14, color: mainColor),
                                ),
                              )
                            ],
                          ),
                        ),
                        // 所属App标题
                        _titleContainer(mainColor, "所属App"),
                        // 所属App主体
                        Container(
                          margin: AllpassEdgeInsets.bottom50Inset,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      if (bean.appId?.isNotEmpty ?? false) {
                                        var openable = await DeviceApps.openApp(bean.appId!);
                                        if (!openable) {
                                          ToastUtil.show(msg: "打开App失败，请确保App已安装");
                                        }
                                      }
                                    },
                                    child: Text(bean.appId?.isEmpty ?? true ? "无" : bean.appName!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: bean.appId?.isEmpty ?? true
                                          ? AllpassTextUI.hintTextStyle
                                          : AllpassTextUI.firstTitleStyle,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        // 备注标题
                        _titleContainer(mainColor, "备注"),
                        // 备注主体
                        Container(
                          margin: AllpassEdgeInsets.bottom50Inset,
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
                                      style: bean.notes.length < 1
                                          ? AllpassTextUI.hintTextStyle
                                          : AllpassTextUI.firstTitleStyle,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        // 标签标题
                        _titleContainer(mainColor, "标签"),
                        // 标签主体
                        Container(
                          margin: AllpassEdgeInsets.bottom50Inset,
                          child: Wrap(
                            children: _getTag(bean),
                            spacing: 5,
                          ),
                        )
                      ],
                    )
                ),
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
                      "账号：${bean.username}\n密码：$password"
                      ));
                      ToastUtil.show(msg: "已复制账号及密码");
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
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) => ConfirmDialog(
                          "确认删除",
                          "你将删除此密码，确认吗？",
                          danger: true,
                          onConfirm: () async {
                            deleted = true;
                            await provider.deletePassword(bean);
                            ToastUtil.show(msg: "删除成功");
                            Navigator.pop(context);
                          },
                        )
                    ),
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
    List<Widget> labelChoices = [];
    bean.label?.forEach((item) {
      labelChoices.add(LabelChip(
          text: item,
          selected: true,
          onSelected: (_) {},
      ));
    });
    if (labelChoices.length == 0) {
      labelChoices.add(Text("无标签", style: AllpassTextUI.hintTextStyle,));
    }
    return labelChoices;
  }

  Widget _titleContainer(Color mainColor, String title) {
    return Container(
      margin: AllpassEdgeInsets.bottom10Inset,
      child: Text(title,
        style: TextStyle(fontSize: 16, color: mainColor),
      ),
    );
  }
}
