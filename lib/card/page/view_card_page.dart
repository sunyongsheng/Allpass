import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:allpass/core/param/constants.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/card/page/edit_card_page.dart';
import 'package:allpass/common/page/detail_text_page.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/util/theme_util.dart';
import 'package:allpass/common/widget/label_chip.dart';
import 'package:allpass/common/widget/confirm_dialog.dart';
import 'package:allpass/setting/theme/theme_provider.dart';

class ViewCardPage extends StatefulWidget {
  @override
  _ViewCardPage createState() => _ViewCardPage();
}

class _ViewCardPage extends State<ViewCardPage> {

  bool _cardIdVisible = false;
  bool _passwordVisible = false;
  String _password = "";
  String _cache = "noCache";

  Color _mainColor;

  bool deleted = false;

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
    if (deleted) return Container();

    CardProvider provider = Provider.of<CardProvider>(context);
    CardBean bean = provider.currCard;
    if (bean == CardBean.empty) {
      Fluttertoast.showToast(msg: "出现错误");
      Navigator.pop(context);
      return Container();
    }
    if (_cache != bean.password) {
      _password = EncryptUtil.decrypt(bean.password);
      _cache = bean.password;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "查看卡片",
            style: AllpassTextUI.titleBarStyle,
          ),
          centerTitle: true,
          actions: <Widget>[
            bean.fav == 1
                ? Icon(Icons.favorite, color: Colors.redAccent,)
                : Icon(Icons.favorite_border,),
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
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius),
                                color: bean.color,
                              ),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.transparent,
                                child: Text(
                                  bean.name.substring(0, 1),
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                              ),
                            )
                        ),
                        Padding(
                          padding: AllpassEdgeInsets.smallLPadding,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(left: 5),
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
                    )
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
                          Padding(
                            padding: AllpassEdgeInsets.smallTBPadding,),
                          // 拥有者姓名标题
                          _titleContainer("拥有者姓名"),
                          // 拥有者姓名主体
                          Container(
                            margin: AllpassEdgeInsets.bottom50Inset,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(bean.ownerName,
                                    overflow: TextOverflow.ellipsis,
                                    style: AllpassTextUI
                                        .firstTitleStyle,
                                  ),),
                                Padding(padding: AllpassEdgeInsets
                                    .smallLPadding,),
                                InkWell(
                                  child: Text("复制",
                                    style: TextStyle(fontSize: 14, color: _mainColor),),
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(
                                        text: bean.ownerName));
                                    Fluttertoast.showToast(msg: "已复制姓名");
                                  },
                                )
                              ],
                            ),
                          ),
                          // 卡号标题
                          _titleContainer("卡号"),
                          // 卡号主体
                          Container(
                            margin: AllpassEdgeInsets.bottom30Inset,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(_cardIdVisible
                                      ? bean.cardId
                                      : "*" * bean.cardId.length,
                                    overflow: TextOverflow.ellipsis,
                                    style: AllpassTextUI
                                        .firstTitleStyle,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    InkWell(
                                      child: _cardIdVisible
                                          ? Icon(Icons.visibility)
                                          : Icon(Icons.visibility_off),
                                      onTap: () {
                                        setState(() {
                                          _cardIdVisible = !_cardIdVisible;
                                        });
                                      },
                                    ),
                                    Padding(padding: AllpassEdgeInsets.smallLPadding,),
                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(
                                            ClipboardData(text: bean.cardId));
                                        Fluttertoast.showToast(
                                            msg: "已复制卡号");
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
                          // 密码标题
                          _titleContainer("密码"),
                          // 密码主体
                          Container(
                            margin: AllpassEdgeInsets.bottom30Inset,
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
                          // 绑定手机号标题
                          _titleContainer("绑定手机号"),
                          // 绑定手机号主体
                          Container(
                            margin: AllpassEdgeInsets.bottom50Inset,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(bean.telephone,
                                    overflow: TextOverflow.ellipsis,
                                    style: AllpassTextUI
                                        .firstTitleStyle,
                                  ),),
                                Padding(padding: AllpassEdgeInsets
                                    .smallLPadding,),
                                InkWell(
                                  child: Text("复制",
                                    style: TextStyle(fontSize: 14, color: _mainColor),),
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(
                                        text: bean.telephone));
                                    Fluttertoast.showToast(msg: "已复制手机号");
                                  },
                                )
                              ],
                            ),
                          ),
                          // 备注标题
                          _titleContainer("备注"),
                          // 备注主体
                          Container(
                            margin: AllpassEdgeInsets.bottom50Inset,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: <Widget>[
                                Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if (bean.notes.length >= 1) {
                                          Navigator.push(
                                              context, CupertinoPageRoute(
                                            builder: (context) =>
                                                DetailTextPage("备注", bean.notes, false),));
                                        }
                                      },
                                      child: Text(bean.notes.length < 1
                                          ? "无备注"
                                          : bean.notes,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: bean.notes.length < 1
                                            ? AllpassTextUI
                                            .hintTextStyle
                                            : AllpassTextUI
                                            .firstTitleStyle,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          // 标签标题
                          _titleContainer("标签"),
                          // 标签主体
                          Container(
                            margin: AllpassEdgeInsets.bottom30Inset,
                            child: Wrap(
                              children: _getTag(bean),
                              spacing: 5,
                            ),
                          )
                        ],
                      ),
                    )),
              ),
              Padding(padding: AllpassEdgeInsets.smallTBPadding,),
              // 最下面一行点击按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: "edit",
                    backgroundColor: Colors.blueAccent,
                    elevation: 0,
                    onPressed: () => Navigator.push(context, CupertinoPageRoute(
                        builder: (_) => EditCardPage(bean, DataOperation.update))),
                    child: Icon(Icons.edit),
                  ),
                  Padding(padding: AllpassEdgeInsets.smallLPadding,),
                  FloatingActionButton(
                    heroTag: "delete",
                    elevation: 0,
                    backgroundColor: Colors.redAccent,
                    onPressed: () async {
                      bool delete = await showDialog(
                          context: context,
                          builder: (context) => ConfirmDialog("确认删除", "你将删除此卡片，确认吗？"));
                      if (delete) {
                        deleted = true;
                        await provider.deleteCard(bean);
                        Fluttertoast.showToast(msg: "删除成功");
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

  List<Widget> _getTag(CardBean bean) {
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

  Widget _titleContainer(String title) {
    return Container(
      margin: AllpassEdgeInsets.bottom10Inset,
      child: Text(title,
        style: TextStyle(fontSize: 16, color: _mainColor),
      ),
    );
  }
}