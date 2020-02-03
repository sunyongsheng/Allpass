import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/provider/card_list.dart';
import 'package:allpass/provider/password_list.dart';
import 'package:allpass/pages/card/view_card_page.dart';
import 'package:allpass/pages/password/view_password_page.dart';

class FavoritePage extends StatelessWidget {

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          splashColor: Colors.transparent,
          child: Text(
            "收藏",
            style: AllpassTextUI.titleBarStyle,
          ),
          onTap: () {
            _controller.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
          },
        ),
        centerTitle: true,
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      body: ListView(
        controller: _controller,
        children: _getFavWidgets(context),
      ),
    );
  }

  List<Widget> _getFavWidgets(BuildContext context) {
    List<Widget> list = List();
    for (int index = 0; index < Provider.of<PasswordList>(context).passwordList.length; index++) {
      try {
        list.add(Consumer<PasswordList>(
          builder: (context, model, _) {
            if (model.passwordList[index].fav == 1) {
              return Container(
                margin: AllpassEdgeInsets.listInset,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: getRandomColor(model.passwordList[index].uniqueKey),
                    child: Text(
                      model.passwordList[index].name.substring(0, 1),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(model.passwordList[index].name, overflow: TextOverflow.ellipsis,),
                  subtitle: Text(model.passwordList[index].username, overflow: TextOverflow.ellipsis,),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ViewPasswordPage(model.passwordList[index])
                    )).then((bean) {
                      if (bean != null) {
                        if (bean.isChanged) {
                          model.updatePassword(bean);
                        } else {
                          model.deletePassword(model.passwordList[index]);
                        }
                      }
                    });
                  },
                ),
              );
            } else {
              return Container();
            }
          },
        ));
      } catch (e) {
      }
    }
    list.add(Container(
      child: Divider(thickness: 1.5,),
      padding: AllpassEdgeInsets.dividerInset,
    ));
    for (int index = 0; index < Provider.of<CardList>(context).cardList.length; index++) {
      try {
        list.add(Consumer<CardList>(
          builder: (context, model, _) {
            if (model.cardList[index].fav == 1) {
              Color t = getRandomColor(model.cardList[index].uniqueKey);
              return Container(
                margin: AllpassEdgeInsets.listInset,
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: t
                    ),
                    child: CircleAvatar(
                      backgroundColor: t,
                      child: Text(
                        model.cardList[index].name.substring(0, 1),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  title: Text(model.cardList[index].name),
                  subtitle: Text(model.cardList[index].ownerName),
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ViewCardPage(model.cardList[index])
                  )).then((bean) {
                    if (bean != null) {
                      // 改变了就更新，没改变就删除
                      if (bean.isChanged) {
                        model.updateCard(bean);
                      } else {
                        model.deleteCard(model.cardList[index]);
                      }
                    }
                  }),
                ),
              );
            } else {
              return Container();
            }
          },
        ));
      } catch (e) {
        print(e.toString());
      }
    }
    return list;
  }

}