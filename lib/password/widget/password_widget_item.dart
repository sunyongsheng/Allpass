import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:allpass/core/param/config.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/encrypt_util.dart';

class PasswordWidgetItem extends StatelessWidget {

  final Key? key;

  final PasswordBean data;

  final VoidCallback? onPasswordClicked;

  PasswordWidgetItem({this.key, required this.data, this.onPasswordClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AllpassEdgeInsets.listInset,
      child: GestureDetector(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: data.color,
            child: Text(data.name.substring(0, 1),
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Text(data.name, overflow: TextOverflow.ellipsis,),
          subtitle: Text(data.username, overflow: TextOverflow.ellipsis,),
          onTap: () => onPasswordClicked?.call(),
          onLongPress: () {
            if (Config.longPressCopy) {
              Clipboard.setData(ClipboardData(
                  text: EncryptUtil.decrypt(data.password)
              ));
              ToastUtil.show(msg: "已复制密码");
            }
          },
        ),
        onPanDown: (details) => RuntimeData.updateTapPosition(details),
      ),
    );
  }
}

class MultiPasswordWidgetItem extends StatefulWidget {

  final Key? key;
  final int index;
  MultiPasswordWidgetItem(this.index, {this.key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MultiPasswordWidgetItem(this.index);
  }

}

class _MultiPasswordWidgetItem extends State<StatefulWidget> {

  final int index;

  _MultiPasswordWidgetItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordProvider>(
      builder: (context, model, child) {
        return Container(
          margin: AllpassEdgeInsets.listInset,
          child: CheckboxListTile(
            value: RuntimeData.multiPasswordList.contains(model.passwordList[index]),
            onChanged: (value) {
              setState(() {
                if (value ?? false) {
                  RuntimeData.multiPasswordList.add(model.passwordList[index]);
                } else {
                  RuntimeData.multiPasswordList.remove(model.passwordList[index]);
                }
              });
            },
            secondary: CircleAvatar(
              backgroundColor: model.passwordList[index].color,
              child: Text(
                model.passwordList[index].name.substring(0, 1),
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(model.passwordList[index].name, overflow: TextOverflow.ellipsis,),
            subtitle: Text(model.passwordList[index].username, overflow: TextOverflow.ellipsis,),
          ),
        );
      },
    );
  }
}