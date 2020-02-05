import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/provider/card_list.dart';
import 'package:allpass/provider/password_list.dart';
import 'package:allpass/pages/card/card_widget_item.dart';
import 'package:allpass/pages/password/password_widget_item.dart';

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
              return PasswordWidgetItem(index);
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
              return SimpleCardWidgetItem(index);
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