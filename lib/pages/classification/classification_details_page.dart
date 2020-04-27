import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:allpass/provider/card_list.dart';
import 'package:allpass/provider/password_list.dart';
import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/pages/card/card_widget_item.dart';
import 'package:allpass/pages/password/password_widget_item.dart';

class ClassificationDetailsPage extends StatelessWidget {

  final ScrollController _controller = ScrollController();

  final String type;
  ClassificationDetailsPage(this.type);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          splashColor: Colors.transparent,
          child: Text(
            type,
            style: AllpassTextUI.titleBarStyle,
          ),
          onTap: () {
            _controller.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
          },
        ),
        centerTitle: true,
      ),
      body: ListView(
        controller: _controller,
        children: _getWidgetsList(context),
      ),
    );
  }

  List<Widget> _getWidgetsList(BuildContext context) {
    List<Widget> list = List();
    for (int index = 0; index < Provider.of<PasswordList>(context).passwordList.length; index++) {
      try {
        list.add(Consumer<PasswordList>(
          builder: (context, model, _) {
            if (model.passwordList[index].folder == type) {
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
            if (model.cardList[index].folder == type) {
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