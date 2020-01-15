import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:allpass/model/password_bean.dart';
import 'package:allpass/pages/password/view_password_page.dart';
import 'package:allpass/params/params.dart';
import 'package:allpass/provider/password_list.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/encrypt_util.dart';

import '../application.dart';

class PasswordListWidget extends StatelessWidget {
  final PasswordBean _bean;

  get bean => _bean;

  PasswordListWidget(this._bean);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AllpassEdgeInsets.listInset,
      //ListTile可以作为listView的一种子组件类型，支持配置点击事件，一个拥有固定样式的Widget
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: getRandomColor(_bean.uniqueKey),
          child: Text(
            _bean.name.substring(0, 1),
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(_bean.name, overflow: TextOverflow.ellipsis,),
        subtitle: Text(_bean.username, overflow: TextOverflow.ellipsis,),
        onTap: () {
          Navigator.push(Application.key.currentContext, MaterialPageRoute(
              builder: (context) => ViewPasswordPage(bean)
          )).then((reBean) {
            if (reBean != null) {
              if (bean.isChanged) {
                Provider.of<PasswordList>(Application.key.currentContext).updatePassword(reBean);
              } else {
                Provider.of<PasswordList>(Application.key.currentContext).deletePassword(bean);
              }
            }
          });
        },
        onLongPress: () async {
          if (Params.longPressCopy) {
            String pw = await EncryptUtil.decrypt(_bean.password);
            Clipboard.setData(ClipboardData(text: pw));
            Fluttertoast.showToast(msg: "已复制密码");
          } else {
            Fluttertoast.showToast(msg: "多选");
          }
        },
      ),
    );
  }

}