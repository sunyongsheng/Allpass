import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/param/config.dart';
import 'package:allpass/param/runtime_data.dart';
import 'package:allpass/provider/password_list.dart';
import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/route/animation_routes.dart';
import 'package:allpass/page/password/view_password_page.dart';

class PasswordWidgetItem extends StatelessWidget {
  final int index;

  PasswordWidgetItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordList>(
      builder: (context, model, child) {
        return Container(
          margin: AllpassEdgeInsets.listInset,
          child: GestureDetector(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: model.passwordList[index].color,
                child: Text(
                  model.passwordList[index].name.substring(0, 1),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text(model.passwordList[index].name, overflow: TextOverflow.ellipsis,),
              subtitle: Text(model.passwordList[index].username, overflow: TextOverflow.ellipsis,),
              onTap: () {
                Navigator.push(context, ExtendRoute(
                  page: ViewPasswordPage(model.passwordList[index]),
                  tapPosition: RuntimeData.tapVerticalPosition
                )).then((bean) async {
                  if (bean != null) {
                    if (bean.isChanged) {
                      await model.updatePassword(bean);
                    } else {
                      await model.deletePassword(model.passwordList[index]);
                    }
                  }
                });
              },
              onLongPress: () {
                if (Config.longPressCopy) {
                  Clipboard.setData(ClipboardData(
                      text: EncryptUtil.decrypt(model.passwordList[index].password)
                  ));
                  Fluttertoast.showToast(msg: "已复制密码");
                }
              },
            ),
            onPanDown: (details) => RuntimeData.updateTapPosition(details),
          ),
        );
      },
    );
  }
}

class PasswordWidgetContainerItem extends StatelessWidget {
  final int index;
  PasswordWidgetContainerItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordList>(
      builder: (context, model, _) {
        return OpenContainer(
          closedElevation: 0,
          openBuilder: (context, _) {
            return ViewPasswordPage(model.passwordList[index]);
          },
          closedBuilder: (context, _) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: model.passwordList[index].color,
                child: Text(model.passwordList[index].name.substring(0, 1),
                  style: TextStyle(color: Colors.white),),
              ),
              title: Text(model.passwordList[index].name, overflow: TextOverflow.ellipsis,),
              subtitle: Text(model.passwordList[index].username, overflow: TextOverflow.ellipsis,),
            );
          },
        );
      },
    );
  }
}

class MultiPasswordWidgetItem extends StatefulWidget {

  final int index;
  MultiPasswordWidgetItem(this.index);

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
    return Consumer<PasswordList>(
      builder: (context, model, child) {
        return Container(
          margin: AllpassEdgeInsets.listInset,
          child: CheckboxListTile(
            value: RuntimeData.multiPasswordList.contains(model.passwordList[index]),
            onChanged: (value) {
              setState(() {
                if (value) {
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