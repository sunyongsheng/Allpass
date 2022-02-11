import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:allpass/util/screen_util.dart';
import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/card/page/view_card_page.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/page/view_password_page.dart';
import 'package:allpass/password/widget/password_widget_item.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:allpass/card/widget/card_widget_item.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/nodata_widget.dart';

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
    List<Widget> all = [];
    List<Widget> list1 = [];
    List<Widget> list2 = [];
    var itemColor = Theme.of(context).cardTheme.color;
    PasswordProvider provider1 = Provider.of<PasswordProvider>(context);
    for (int index = 0; index < provider1.count; index++) {
      try {
        if (provider1.passwordList[index].folder == type) {
          list1.add(MaterialPasswordWidget(
              data: provider1.passwordList[index],
              containerShape: 4,
              itemColor: itemColor,
              pageCreator: () => ViewPasswordPage(),
              onPasswordClicked: () => provider1.previewPassword(index: index),
          ));
        }
      } catch (e) {
      }
    }
    CardProvider provider2 = Provider.of<CardProvider>(context);
    for (int index = 0; index < provider2.count; index++) {
      try {
        if (type == provider2.cardList[index].folder) {
          list2.add(MaterialSimpleCardWidget(
              data: provider2.cardList[index],
              pageCreator: () => ViewCardPage(),
              containerShape: 4,
              itemColor: itemColor,
              onCardClicked: () => provider2.previewCard(index: index)
          ));
        }
      } catch (e) {
      }
    }
    if (list1.length == 0 && list2.length == 0) {
      return NoDataWidget();
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