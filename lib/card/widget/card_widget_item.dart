import 'dart:io';

import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PlatformCardWidget extends StatelessWidget {
  final CardBean data;

  final WidgetBuilder pageCreator;

  final VoidCallback? onCardClicked;

  const PlatformCardWidget(
      {Key? key,
      required this.data,
      required this.pageCreator,
      this.onCardClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _CardWidgetItem(
        key: key,
        data: data,
        onCardClicked: () {
          onCardClicked?.call();
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => pageCreator.call(context)));
        },
      );
    } else {
      return _MaterialCardWidget(
          data: data,
          pageCreator: pageCreator,
          key: key,
          onCardClicked: onCardClicked);
    }
  }
}

class _MaterialCardWidget extends StatelessWidget {
  final Key? key;

  final CardBean data;

  final WidgetBuilder pageCreator;

  final VoidCallback? onCardClicked;

  const _MaterialCardWidget(
      {this.key,
      required this.data,
      required this.pageCreator,
      this.onCardClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return OpenContainer(
      openBuilder: (context, closedContainer) {
        return pageCreator.call(context);
      },
      openColor: data.color ?? backgroundColor,
      closedColor: data.color ?? backgroundColor,
      closedShape: RoundedRectangleBorder(
        borderRadius: AllpassUI.smallBorderRadius,
      ),
      closedElevation: 0,
      closedBuilder: (context, openContainer) {
        return _CardWidgetItem(
            key: key,
            data: data,
            onCardClicked: () {
              onCardClicked?.call();
              openContainer();
            });
      },
    );
  }
}

class _CardWidgetItem extends StatelessWidget {
  final Key? key;

  final CardBean data;

  final VoidCallback? onCardClicked;

  const _CardWidgetItem({this.key, required this.data, this.onCardClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: data.color,
      margin: EdgeInsets.all(0),
      child: GestureDetector(
        onTap: () => onCardClicked?.call(),
        onLongPress: () async {
          if (Config.longPressCopy) {
            Clipboard.setData(ClipboardData(text: data.cardId));
            ToastUtil.show(msg: "已复制卡号");
          }
        },
        child: ListTile(
          title: Text(
            data.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            "ID: ${data.cardId}",
            style:
                TextStyle(color: Colors.white, letterSpacing: 1, height: 1.7),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        ),
      ),
    );
  }
}

class PlatformSimpleCardWidget extends StatelessWidget {
  final CardBean data;

  final WidgetBuilder pageCreator;

  final VoidCallback? onCardClicked;

  final double containerShape;

  final Color? itemColor;

  const PlatformSimpleCardWidget(
      {Key? key,
      required this.data,
      required this.pageCreator,
      this.onCardClicked,
      required this.containerShape,
      this.itemColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return SimpleCardWidgetItem(
          key: key,
          data: data,
          onCardClicked: () {
            onCardClicked?.call();
            Navigator.push(context,
                CupertinoPageRoute(builder: (ctx) => pageCreator.call(ctx)));
          });
    } else {
      return _MaterialSimpleCardWidget(
          data: data,
          pageCreator: pageCreator,
          onCardClicked: onCardClicked,
          containerShape: containerShape,
          itemColor: itemColor,
          key: key);
    }
  }
}

class _MaterialSimpleCardWidget extends StatelessWidget {
  final CardBean data;

  final WidgetBuilder pageCreator;

  final VoidCallback? onCardClicked;

  final double containerShape;

  final Color? itemColor;

  const _MaterialSimpleCardWidget({
    Key? key,
    required this.data,
    required this.pageCreator,
    required this.containerShape,
    this.onCardClicked,
    this.itemColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return OpenContainer(
      openBuilder: (context, closedContainer) {
        return pageCreator.call(context);
      },
      openColor: backgroundColor,
      closedColor: itemColor ?? backgroundColor,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(this.containerShape)),
      ),
      closedElevation: 0,
      closedBuilder: (context, openContainer) {
        return SimpleCardWidgetItem(
            key: key,
            data: data,
            onCardClicked: () {
              onCardClicked?.call();
              openContainer();
            });
      },
    );
  }
}

class SimpleCardWidgetItem extends StatelessWidget {
  final CardBean data;
  final VoidCallback? onCardClicked;

  SimpleCardWidgetItem({Key? key, required this.data, this.onCardClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CardProvider>(
      builder: (context, model, _) {
        return Container(
          margin: AllpassEdgeInsets.listInset,
          child: GestureDetector(
            child: ListTile(
              leading: Container(
                decoration: BoxDecoration(
                    borderRadius: AllpassUI.smallBorderRadius,
                    color: data.color),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Text(
                    data.name.substring(0, 1),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              title: Text(data.name),
              subtitle: Text(data.ownerName),
              onTap: () => onCardClicked?.call(),
            ),
          ),
        );
      },
    );
  }
}

class MultiCardWidgetItem extends StatefulWidget {
  final CardBean data;

  MultiCardWidgetItem({Key? key, required this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MultiCardWidgetItem(data);
  }
}

class _MultiCardWidgetItem extends State<StatefulWidget> {
  final CardBean data;

  _MultiCardWidgetItem(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AllpassEdgeInsets.listInset,
      child: CheckboxListTile(
        value: RuntimeData.multiCardList.contains(data),
        onChanged: (value) {
          setState(() {
            if (value ?? false) {
              RuntimeData.multiCardList.add(data);
            } else {
              RuntimeData.multiCardList.remove(data);
            }
          });
        },
        secondary: Container(
          decoration: BoxDecoration(
              borderRadius: AllpassUI.smallBorderRadius,
              color: data.color),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Text(
              data.name.substring(0, 1),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        title: Text(
          data.name,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          data.cardId,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
