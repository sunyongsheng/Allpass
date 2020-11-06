import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/card/page/view_card_page.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/anim/animation_routes.dart';

class CardWidgetItem extends StatelessWidget {
  final Key key;
  final int index;
  CardWidgetItem(this.index, {this.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CardProvider>(
      key: key,
      builder: (context, model, _) {
        return SizedBox(
          height: 100,
          child: Card(
            elevation: 0,
            color: model.cardList[index].color,
            margin: AllpassEdgeInsets.forCardInset,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(AllpassUI.smallBorderRadius))),
            child: GestureDetector(
              onPanDown: (details) => RuntimeData.updateTapPosition(details),
              onTap: () => Navigator.push(context, ExtendRoute(
                page: ViewCardPage(model.cardList[index]),
                tapPosition: RuntimeData.tapVerticalPosition
              )).then((bean) async {
                if (bean != null) {
                  // 改变了就更新，没改变就删除
                  if (bean.isChanged) {
                    await model.updateCard(bean);
                  } else {
                    await model.deleteCard(model.cardList[index]);
                  }
                }
              }),
              onLongPress: () async {
                if (Config.longPressCopy) {
                  Clipboard.setData(ClipboardData(text: model.cardList[index].cardId));
                  Fluttertoast.showToast(msg: "已复制卡号");
                }
              },
              child: ListTile(
                title: Text(
                  model.cardList[index].name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  "ID: ${model.cardList[index].cardId}",
                  style:
                  TextStyle(color: Colors.white, letterSpacing: 1, height: 1.7),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                contentPadding: EdgeInsets.only(left: 30, right: 30, top: 5),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CardWidgetContainerItem extends StatelessWidget {
  final Key key;
  final int index;
  CardWidgetContainerItem(this.index, {this.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CardProvider>(
      builder: (context, model, _) {
        return OpenContainer(
          closedElevation: 0,
          openBuilder: (context, _) {
            return ViewCardPage(model.cardList[index]);
          },
          closedBuilder: (context, _) {
            return SizedBox(
              height: 100,
              child: Card(
                elevation: 2,
                color: model.cardList[index].color,
                margin: AllpassEdgeInsets.forCardInset,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(AllpassUI.smallBorderRadius))),
                child: ListTile(
                  title: Text(
                    model.cardList[index].name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    "ID: ${model.cardList[index].cardId}",
                    style:
                    TextStyle(color: Colors.white, letterSpacing: 1, height: 1.7),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  contentPadding: EdgeInsets.only(left: 30, right: 30, top: 5),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class SimpleCardWidgetItem extends StatelessWidget {

  final int index;

  SimpleCardWidgetItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Consumer<CardProvider>(
      builder: (context, model, _) {
        return Container(
          margin: AllpassEdgeInsets.listInset,
          child: GestureDetector(
            onPanDown: (details) => RuntimeData.updateTapPosition(details),
            child: ListTile(
              leading: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius),
                    color: model.cardList[index].color
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Text(
                    model.cardList[index].name.substring(0, 1),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              title: Text(model.cardList[index].name),
              subtitle: Text(model.cardList[index].ownerName),
              onTap: () => Navigator.push(context, ExtendRoute(
                page: ViewCardPage(model.cardList[index]),
                tapPosition: RuntimeData.tapVerticalPosition,
              )).then((bean) async {
                if (bean != null) {
                  // 改变了就更新，没改变就删除
                  if (bean.isChanged) {
                    await model.updateCard(bean);
                  } else {
                    await model.deleteCard(model.cardList[index]);
                  }
                }
              }),
            ),
          ),
        );
      },
    );
  }
}

class MultiCardWidgetItem extends StatefulWidget {
  final Key key;
  final int index;

  MultiCardWidgetItem(this.index, {this.key});

  @override
  State<StatefulWidget> createState() {
    return _MultiCardWidgetItem(index);
  }
}

class _MultiCardWidgetItem extends State<StatefulWidget> {
  final int index;

  _MultiCardWidgetItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Consumer<CardProvider>(
      key: widget.key,
      builder: (context, model, child) {
        return Container(
          margin: AllpassEdgeInsets.listInset,
          child: CheckboxListTile(
            value: RuntimeData.multiCardList.contains(model.cardList[index]),
            onChanged: (value) {
              setState(() {
                if (value) {
                  RuntimeData.multiCardList.add(model.cardList[index]);
                } else {
                  RuntimeData.multiCardList.remove(model.cardList[index]);
                }
              });
            },
            secondary: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius),
                  color: model.cardList[index].color
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Text(
                  model.cardList[index].name.substring(0, 1),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            title: Text(model.cardList[index].name, overflow: TextOverflow.ellipsis,),
            subtitle: Text(model.cardList[index].cardId, overflow: TextOverflow.ellipsis,),
          ),
        );
      },
    );
  }
}