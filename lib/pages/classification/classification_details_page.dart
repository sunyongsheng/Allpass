import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/utils/screen_util.dart';
import 'package:allpass/provider/card_list.dart';
import 'package:allpass/provider/password_list.dart';
import 'package:allpass/provider/theme_provider.dart';
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
      backgroundColor: Provider.of<ThemeProvider>(context).backgroundColor2,
      body: ListView(
        controller: _controller,
        children: _getWidgetsList(context),
      ),
    );
  }

  List<Widget> _getWidgetsList(BuildContext context) {
    List<Widget> all = List();
    List<Widget> list1 = List();
    List<Widget> list2 = List();
    for (int index = 0; index < Provider.of<PasswordList>(context).passwordList.length; index++) {
      try {
        list1.add(PasswordWidgetItem(index));
      } catch (e) {
      }
    }
    for (int index = 0; index < Provider.of<CardList>(context).cardList.length; index++) {
      try {
        list2.add(SimpleCardWidgetItem(index));
      } catch (e) {
      }
    }
    all.add(Padding(
      padding: EdgeInsets.symmetric(vertical: AllpassScreenUtil.setHeight(10)),
    ));
    all.add(Card(
      margin: AllpassEdgeInsets.settingCardInset,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius)),
      child: Column(
        children: list1,
      ),
    ));
    all.add(Card(
      margin: AllpassEdgeInsets.settingCardInset,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius)),
      child: Column(
        children: list2,
      ),
    ));
    all.add(Padding(
      padding: EdgeInsets.symmetric(vertical: AllpassScreenUtil.setHeight(10)),
    ));
    return all;
  }
}