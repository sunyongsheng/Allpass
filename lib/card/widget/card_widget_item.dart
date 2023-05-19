import 'dart:io';

import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MaterialCardWidget extends StatelessWidget {
  final CardBean data;

  final WidgetBuilder pageCreator;

  final VoidCallback? onClick;

  const MaterialCardWidget({
    Key? key,
    required this.data,
    required this.pageCreator,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _CardWidgetItem(
        key: key,
        data: data,
        onCardClicked: () {
          onClick?.call();
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => pageCreator.call(context)),
          );
        },
      );
    }

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
            onClick?.call();
            openContainer();
          },
        );
      },
    );
  }
}

class _CardWidgetItem extends StatelessWidget {
  final CardBean data;

  final VoidCallback? onCardClicked;

  const _CardWidgetItem({
    Key? key,
    required this.data,
    this.onCardClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          gradient: data.gradientColor,
        ),
        child: ListTile(
          title: Text(
            data.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            "ID: ${data.cardId}",
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1,
              height: 1.7,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          onTap: () => onCardClicked?.call(),
          onLongPress: () {
            if (Config.longPressCopy) {
              Clipboard.setData(ClipboardData(text: data.cardId));
              ToastUtil.show(msg: context.l10n.cardIdCopied);
            }
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        ),
      ),
    );
  }
}

class MaterialSimpleCardWidget extends StatelessWidget {
  final CardBean data;

  final WidgetBuilder pageCreator;

  final VoidCallback? onCardClicked;

  final double containerShape;

  final Color? itemColor;

  const MaterialSimpleCardWidget({
    Key? key,
    required this.data,
    required this.pageCreator,
    required this.containerShape,
    this.onCardClicked,
    this.itemColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return SimpleCardWidgetItem(
        key: key,
        data: data,
        onCardClicked: () {
          onCardClicked?.call();
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (ctx) => pageCreator.call(ctx)),
          );
        },
      );
    }

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
          },
        );
      },
    );
  }
}

class SimpleCardWidgetItem extends StatelessWidget {
  final CardBean data;
  final VoidCallback? onCardClicked;

  SimpleCardWidgetItem({
    Key? key,
    required this.data,
    this.onCardClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: AllpassEdgeInsets.widgetItemInset,
      leading: Container(
        decoration: BoxDecoration(
          borderRadius: AllpassUI.smallBorderRadius,
          color: data.color,
        ),
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
      onLongPress: () {
        if (Config.longPressCopy) {
          Clipboard.setData(ClipboardData(text: data.cardId));
          ToastUtil.show(msg: context.l10n.cardIdCopied);
        }
      },
    );
  }
}

class MultiCardWidgetItem extends StatefulWidget {
  final CardBean card;
  final bool Function(CardBean) selection;
  final void Function(bool, CardBean) onChanged;

  MultiCardWidgetItem({
    Key? key,
    required this.card,
    required this.selection,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MultiCardWidgetItem(card);
  }
}

class _MultiCardWidgetItem extends State<MultiCardWidgetItem> {
  final CardBean data;

  _MultiCardWidgetItem(this.data);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: AllpassEdgeInsets.widgetItemInset,
      value: widget.selection(data),
      onChanged: (value) {
        widget.onChanged(value ?? false, data);
      },
      secondary: Container(
        decoration: BoxDecoration(
          borderRadius: AllpassUI.smallBorderRadius,
          color: data.color,
        ),
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
    );
  }
}
