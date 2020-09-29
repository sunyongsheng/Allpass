import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/model/data/card_bean.dart';
import 'package:allpass/model/data/password_bean.dart';
import 'package:allpass/provider/card_provider.dart';
import 'package:allpass/provider/password_provider.dart';
import 'package:allpass/provider/theme_provider.dart';
import 'package:allpass/page/card/card_widget_item.dart';
import 'package:allpass/page/password/password_widget_item.dart';
import 'package:allpass/widget/common/nodata_widget.dart';

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
      ),
      backgroundColor: Provider.of<ThemeProvider>(context).specialBackgroundColor,
      body: _getFavWidgetListView(context, _controller),
    );
  }

  Widget _getFavWidgetListView(BuildContext context, ScrollController controller) {
    List<Widget> list1 = List();
    List<Widget> list2 = List();
    List<Widget> all = List();
    List<PasswordBean> passwordList = Provider.of<PasswordProvider>(context).passwordList;
    for (int index = 0; index < passwordList.length; index++) {
      try {
        if (passwordList[index].fav == 1) {
          list1.add(PasswordWidgetItem(index));
        }
      } catch (e) {
      }
    }
    List<CardBean> cardList = Provider.of<CardProvider>(context).cardList;
    for (int index = 0; index < cardList.length; index++) {
      try {
        if (cardList[index].fav == 1) {
          list2.add(SimpleCardWidgetItem(index));
        }
      } catch (e) {
        print(e.toString());
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
    return ListView(
      controller: controller,
      children: all,
    );
  }

}