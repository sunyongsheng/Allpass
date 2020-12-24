import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/card/page/view_card_page.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/password/page/view_password_page.dart';
import 'package:allpass/password/widget/password_widget_item.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:allpass/card/widget/card_widget_item.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/nodata_widget.dart';
import 'package:allpass/common/anim/animation_routes.dart';

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
      backgroundColor: Provider.of<ThemeProvider>(context).specialBackgroundColor,
      body: _getListView(context, _controller),
    );
  }

  Widget _getListView(BuildContext context, ScrollController controller) {
    List<Widget> all = List();
    List<Widget> list1 = List();
    List<Widget> list2 = List();
    List<PasswordBean> passwordList = Provider.of<PasswordProvider>(context).passwordList;
    for (int index = 0; index < passwordList.length; index++) {
      try {
        if (passwordList[index].folder == type) {
          list1.add(PasswordWidgetItem(data: passwordList[index], onPasswordClicked: () {
            Navigator.push(context, ExtendRoute(
                page: ViewPasswordPage(index),
                tapPosition: RuntimeData.tapVerticalPosition
            ));
          }));
        }
      } catch (e) {
      }
    }
    List<CardBean> cardList = Provider.of<CardProvider>(context).cardList;
    for (int index = 0; index < cardList.length; index++) {
      try {
        if (type == cardList[index].folder) {
          list2.add(SimpleCardWidgetItem(data: cardList[index], onCardClicked: () {
            Navigator.push(context, ExtendRoute(
              page: ViewCardPage(index),
              tapPosition: RuntimeData.tapVerticalPosition,
            ));
          }));
        }
      } catch (e) {
      }
    }
    if (list1.length == 0 && list2.length == 0) {
      return NoDataWidget(null);
    }
    all.add(Padding(
      padding: EdgeInsets.symmetric(vertical: AllpassScreenUtil.setHeight(10)),
    ));
    all.add(Card(
      margin: AllpassEdgeInsets.settingCardInset,
      elevation: 0,
      child: Column(
        children: list1,
      ),
    ));
    all.add(Card(
      margin: AllpassEdgeInsets.settingCardInset,
      elevation: 0,
      child: Column(
        children: list2,
      ),
    ));
    all.add(Padding(
      padding: EdgeInsets.symmetric(vertical: AllpassScreenUtil.setHeight(10)),
    ));
    return ListView(
      children: all,
      controller: controller,
    );
  }
}