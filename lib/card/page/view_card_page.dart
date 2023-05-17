import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:allpass/core/param/constants.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/card/page/edit_card_page.dart';
import 'package:allpass/common/page/detail_text_page.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/decrypt_error_widget.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/encrypt/encrypt_util.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/common/widget/label_chip.dart';
import 'package:allpass/common/widget/confirm_dialog.dart';
import 'package:allpass/setting/theme/theme_provider.dart';

class ViewCardPage extends StatefulWidget {
  @override
  _ViewCardPage createState() => _ViewCardPage();
}

class _ViewCardPage extends State<ViewCardPage> {

  bool cardIdVisible = false;
  bool passwordVisible = false;
  String password = "";
  String cache = "noCache";

  bool deleted = false;

  @override
  Widget build(BuildContext context) {
    if (deleted) return Container();

    Color mainColor = Theme.of(context).primaryColor;
    CardProvider provider = context.watch();
    CardBean bean = provider.currCard;

    if (bean == CardBean.empty) {
      ToastUtil.show(msg: context.l10n.unknownErrorOccur);
      Navigator.pop(context);
      return Container();
    }

    try {
      if (cache != bean.password) {
        password = EncryptUtil.decrypt(bean.password);
        cache = bean.password;
      }
    } on ArgumentError {
      return DecryptErrorWidget(
        originalValue: bean.password,
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            context.l10n.viewCard,
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
                        padding: EdgeInsets.symmetric(
                          vertical: 23,
                          horizontal: 0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: AllpassUI.smallBorderRadius,
                            color: bean.color,
                          ),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.transparent,
                            child: Text(
                              bean.name.substring(0, 1),
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
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
                            padding: EdgeInsets.only(left: 5),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: AllpassScreenUtil.setWidth(450),
                              ),
                              child: Text(
                                bean.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: 0,
                              right: 5,
                              top: 3,
                              bottom: 0,
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.folder_open),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  color: Colors.grey[250],
                                  child: Container(
                                    child: Text(
                                      bean.folder,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    width: 50,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                        Padding(
                          padding: AllpassEdgeInsets.smallTBPadding,
                        ),
                        // 拥有者姓名标题
                        _titleContainer(mainColor, context.l10n.ownerName),
                        // 拥有者姓名主体
                        Container(
                          margin: AllpassEdgeInsets.bottom50Inset,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(bean.ownerName,
                                  overflow: TextOverflow.ellipsis,
                                  style: AllpassTextUI.firstTitleStyle,
                                ),
                              ),
                              Padding(padding: AllpassEdgeInsets.smallLPadding),
                              InkWell(
                                child: Text(
                                  context.l10n.copy,
                                  style: TextStyle(fontSize: 14, color: mainColor),
                                ),
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                    text: bean.ownerName,
                                  ));
                                  ToastUtil.show(msg: context.l10n.nameCopied);
                                },
                              )
                            ],
                          ),
                        ),
                        // 卡号标题
                        _titleContainer(mainColor, context.l10n.cardId),
                        // 卡号主体
                        Container(
                          margin: AllpassEdgeInsets.bottom30Inset,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(cardIdVisible
                                    ? bean.cardId
                                    : "*" * bean.cardId.length,
                                  overflow: TextOverflow.ellipsis,
                                  style: AllpassTextUI.firstTitleStyle,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  InkWell(
                                    child: cardIdVisible
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                                    onTap: () {
                                      setState(() {
                                        cardIdVisible = !cardIdVisible;
                                      });
                                    },
                                  ),
                                  Padding(padding: AllpassEdgeInsets.smallLPadding,),
                                  InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                        text: bean.cardId,
                                      ));
                                      ToastUtil.show(
                                        msg: context.l10n.cardIdCopied,
                                      );
                                    },
                                    child: Text(
                                      context.l10n.copy,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: mainColor,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        // 密码标题
                        _titleContainer(mainColor, context.l10n.password),
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
                                      ToastUtil.show(msg: context.l10n.passwordCopied);
                                    },
                                    child: Text(
                                      context.l10n.copy,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: mainColor,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        // 绑定手机号标题
                        _titleContainer(mainColor, context.l10n.phoneNumber),
                        // 绑定手机号主体
                        Container(
                          margin: AllpassEdgeInsets.bottom50Inset,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  bean.telephone,
                                  overflow: TextOverflow.ellipsis,
                                  style: AllpassTextUI.firstTitleStyle,
                                ),
                              ),
                              Padding(padding: AllpassEdgeInsets.smallLPadding),
                              InkWell(
                                child: Text(
                                  context.l10n.copy,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: mainColor,
                                  ),
                                ),
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                    text: bean.telephone,
                                  ));
                                  ToastUtil.show(msg: context.l10n.phoneNumberCopied);
                                },
                              )
                            ],
                          ),
                        ),
                        // 备注标题
                        _titleContainer(mainColor, context.l10n.notes),
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
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => DetailTextPage(
                                            context.l10n.notes,
                                            bean.notes,
                                            false,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    bean.notes.length < 1
                                        ? context.l10n.emptyNotes
                                        : bean.notes,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: bean.notes.length < 1
                                        ? AllpassTextUI.hintTextStyle
                                        : AllpassTextUI.firstTitleStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 标签标题
                        _titleContainer(mainColor, context.l10n.labels),
                        // 标签主体
                        Container(
                          margin: AllpassEdgeInsets.bottom30Inset,
                          child: Wrap(
                            children: _getTag(bean),
                            spacing: 5,
                          ),
                        )
                      ],
                    )
                ),
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
                        builder: (_) => EditCardPage(bean, DataOperation.update),
                    )),
                    child: Icon(Icons.edit),
                  ),
                  Padding(padding: AllpassEdgeInsets.smallLPadding,),
                  FloatingActionButton(
                    heroTag: "delete",
                    elevation: 0,
                    backgroundColor: Colors.redAccent,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        context.l10n.confirmDelete,
                        context.l10n.deleteCardWarning,
                        danger: true,
                        onConfirm: () async {
                          deleted = true;
                          await provider.deleteCard(bean);
                          ToastUtil.show(msg: context.l10n.deleteSuccess);
                          Navigator.pop(context);
                        },
                      ),
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

  List<Widget> _getTag(CardBean bean) {
    List<Widget> labelChoices = [];
    bean.label?.forEach((item) {
      labelChoices.add(LabelChip(
        text: item,
        selected: true,
        onSelected: (_) {},
      ));
    });
    if (labelChoices.length == 0) {
      labelChoices.add(Text(
        context.l10n.emptyLabel,
        style: AllpassTextUI.hintTextStyle,
      ));
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