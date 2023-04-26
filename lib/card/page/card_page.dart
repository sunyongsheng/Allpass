import 'dart:io';

import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/card/page/edit_card_page.dart';
import 'package:allpass/card/page/view_card_page.dart';
import 'package:allpass/card/widget/card_widget_item.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/confirm_dialog.dart';
import 'package:allpass/common/widget/empty_data_widget.dart';
import 'package:allpass/common/widget/select_item_dialog.dart';
import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/search/search_page.dart';
import 'package:allpass/search/search_provider.dart';
import 'package:allpass/search/widget/search_button_widget.dart';
import 'package:allpass/common/data/multi_item_edit_provider.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 卡片页面
class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() {
    return _CardPageState();
  }
}

class _CardPageState extends State<CardPage> with AutomaticKeepAliveClientMixin {

  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  // 查询
  Future<Null> _query(CardProvider model) async {
    await model.refresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    CardProvider model = context.watch();
    MultiItemEditProvider<CardBean> editProvider = context.watch();

    List<Widget> appbarActions = [
      IconButton(
        splashColor: Colors.transparent,
        icon: editProvider.editMode
            ? Icon(Icons.clear)
            : Icon(Icons.sort),
        onPressed: editProvider.switchEditMode,
      ),
      Padding(padding: AllpassEdgeInsets.smallLPadding)
    ];
    Widget? floatingButton;
    if (editProvider.editMode) {
      appbarActions.insertAll(0, [
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case "删除":
                _deleteCard(context, model, editProvider);
                break;
              case "移动":
                _moveCard(context, model, editProvider);
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: "移动", child: Text("移动")),
            PopupMenuItem(value: "删除", child: Text("删除")),
          ],
        ),
        IconButton(
          splashColor: Colors.transparent,
          icon: Icon(Icons.select_all),
          onPressed: () {
            if (editProvider.selectedCount != model.count) {
              editProvider.selectAll(model.cardList);
            } else {
             editProvider.unselectAll();
            }
          },
        )
      ]);
    } else {
      if (Platform.isIOS) {
        floatingButton = FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => EditCardPage(null, DataOperation.add),
              ),
            );
          },
          heroTag: "card",
        );
      } else {
        Color mainColor = Theme.of(context).primaryColor;
        var circleFabBorder = CircleBorder();
        floatingButton = OpenContainer(
          closedBuilder: (context, openContainer) {
            return Tooltip(
              message: "添加卡片项目",
              child: InkWell(
                customBorder: circleFabBorder,
                onTap: () => openContainer(),
                child: SizedBox(
                  height: 56,
                  width: 56,
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
          openColor: mainColor,
          closedColor: mainColor,
          closedElevation: 6,
          closedShape: CircleBorder(),
          openBuilder: (context, closedContainer) {
            return EditCardPage(null, DataOperation.add);
          },
        );
      }
    }

    Widget listView;
    if (model.cardList.isNotEmpty) {
      if (editProvider.editMode) {
        listView = ListView.builder(
          controller: _controller,
          itemBuilder: (context, index) => MultiCardWidgetItem(
            card: model.cardList[index],
            selection: editProvider.isSelected,
            onChanged: editProvider.select,
          ),
          itemCount: model.count,
          physics: const AlwaysScrollableScrollPhysics(),
        );
      } else {
        listView = ListView.separated(
          controller: _controller,
          padding: AllpassEdgeInsets.forCardInset,
          itemBuilder: (context, index) {
            return MaterialCardWidget(
                data: model.cardList[index],
                pageCreator: (_) => ViewCardPage(),
                onCardClicked: () => model.previewCard(index: index),
            );
          },
          itemCount: model.count,
          physics: const AlwaysScrollableScrollPhysics(),
          separatorBuilder: (context, index) {
            return SizedBox(height: 8);
          },
        );
      }
    } else {
      listView = EmptyDataWidget(subtitle: "这里存储你的卡片信息，例如\n身份证，银行卡或贵宾卡等");
    }

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: AllpassEdgeInsets.smallLPadding,
          child: InkWell(
            splashColor: Colors.transparent,
            child: Text(
              "卡片",
              style: AllpassTextUI.titleBarStyle,
            ),
            onTap: () {
              _controller.animateTo(
                0,
                duration: Duration(milliseconds: 200),
                curve: Curves.decelerate,
              );
            },
          ),
        ),
        automaticallyImplyLeading: false,
        actions: appbarActions,
      ),
      body: Column(
        children: <Widget>[
          // 搜索框 按钮
          SearchButtonWidget(_searchPress, "卡片"),
          // 卡片列表
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _query(model),
              child: listView,
            ),
          ),
        ],
      ),
      floatingActionButton: floatingButton,
    );
  }

  void _searchPress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: SearchProvider(AllpassType.card, context),
          child: SearchPage(AllpassType.card),
        ),
      ),
    );
  }

  void _deleteCard(BuildContext context, CardProvider model, MultiItemEditProvider editProvider,) {
    if (editProvider.isEmpty) {
      ToastUtil.show(msg: "请选择至少一项卡片");
    } else {
      showDialog<bool>(
        context: context,
        builder: (context) => ConfirmDialog(
          "确认删除",
          "您将删除${editProvider.selectedCount}项卡片，确认吗？",
          danger: true,
          onConfirm: () async {
            for (var item in editProvider.selectedItem) {
              await model.deleteCard(item);
            }
            editProvider.unselectAll();
          },
        ),
      );
    }
  }

  void _moveCard(BuildContext context, CardProvider model, MultiItemEditProvider<CardBean> editProvider,) {
    if (editProvider.isEmpty) {
      ToastUtil.show(msg: "请选择至少一项卡片");
    } else {
      showDialog(
        context: context,
        builder: (context) => DefaultSelectItemDialog<String>(
          list: RuntimeData.folderList,
          onSelected: (value) async {
            editProvider.selectedItem.forEach((element) async {
              element.folder = value;
              await model.updateCard(element);
            });
            ToastUtil.show(
              msg: "已移动${editProvider.selectedCount}项密码至 $value 文件夹",
            );
            editProvider.unselectAll();
          },
        ),
      );
    }
  }
}
