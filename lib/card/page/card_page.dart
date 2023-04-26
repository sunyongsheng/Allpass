import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/card/page/edit_card_page.dart';
import 'package:allpass/card/page/view_card_page.dart';
import 'package:allpass/card/widget/card_widget_item.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/confirm_dialog.dart';
import 'package:allpass/common/widget/empty_data_widget.dart';
import 'package:allpass/common/widget/route_floating_action_button.dart';
import 'package:allpass/common/widget/select_item_dialog.dart';
import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/extension/widget_extension.dart';
import 'package:allpass/search/search_page.dart';
import 'package:allpass/search/search_provider.dart';
import 'package:allpass/search/widget/search_button_widget.dart';
import 'package:allpass/common/data/multi_item_edit_provider.dart';
import 'package:allpass/util/toast_util.dart';
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
            onTap: _controller.scrollToTop,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: _buildAppBarActions(),
      ),
      body: Column(
        children: <Widget>[
          // 搜索框 按钮
          SearchButtonWidget(_searchPress, "卡片"),
          // 卡片列表
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _query(context.read<CardProvider>()),
              child: _buildCardContent(),
            ),
          ),
        ],
      ),
      floatingActionButton: Selector<MultiItemEditProvider<CardBean>, bool>(
        selector: (_, editProvider) => editProvider.editMode,
        builder: (_, editMode, child) => editMode ? Container() : child!,
        child: MaterialRouteFloatingActionButton(
          heroTag: "add_card",
          tooltip: "添加卡片条目",
          builder: (_) => EditCardPage(null, DataOperation.add),
          child: Icon(Icons.add),
        ),
      ),
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

  List<Widget> _buildAppBarActions() {
    return [
      Consumer2<MultiItemEditProvider<CardBean>, CardProvider>(
        builder: (context, editProvider, provider, __) {
          var children = <Widget>[];
          if (editProvider.editMode) {
            children.add(PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case "删除":
                    _deleteCard(context, provider, editProvider);
                    break;
                  case "移动":
                    _moveCard(context, provider, editProvider);
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: "移动", child: Text("移动")),
                PopupMenuItem(value: "删除", child: Text("删除")),
              ],
            ));
            children.add(IconButton(
              splashColor: Colors.transparent,
              icon: Icon(Icons.select_all),
              onPressed: () {
                if (editProvider.selectedCount != provider.count) {
                  editProvider.selectAll(provider.cardList);
                } else {
                  editProvider.unselectAll();
                }
              },
            ));
          }
          children.add(Padding(
            padding: AllpassEdgeInsets.smallRPadding,
            child: IconButton(
              splashColor: Colors.transparent,
              icon: editProvider.editMode ? Icon(Icons.clear) : Icon(Icons.sort),
              onPressed: editProvider.switchEditMode,
            ),
          ));
          return Row(
            children: children,
          );
        },
      )
    ];
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
            ToastUtil.show(msg: "已删除 ${editProvider.selectedCount} 项卡片");
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
              msg: "已移动 ${editProvider.selectedCount} 项卡片至 $value 文件夹",
            );
            editProvider.unselectAll();
          },
        ),
      );
    }
  }

  Widget _buildCardContent() {
    return Selector<CardProvider, bool>(
      selector: (_, provider) => provider.cardList.isEmpty,
      builder: (_, empty, emptyWidget) {
        if (empty) {
          return emptyWidget!;
        } else {
          return _buildCardList();
        }
      },
      child: const EmptyDataWidget(subtitle: "这里存储你的卡片信息，例如\n身份证，银行卡或贵宾卡等"),
    );
  }

  Widget _buildCardList() {
    return Consumer2<CardProvider, MultiItemEditProvider<CardBean>>(
      builder: (_, provider, editProvider, cardList) {
        if (editProvider.editMode) {
          return ListView.builder(
            controller: _controller,
            itemBuilder: (context, index) => MultiCardWidgetItem(
              card: provider.cardList[index],
              selection: editProvider.isSelected,
              onChanged: editProvider.select,
            ),
            itemCount: provider.count,
            physics: const AlwaysScrollableScrollPhysics(),
          );
        } else {
          return cardList!;
        }
      },
      child: Consumer<CardProvider>(
        builder: (_, provider, __) => ListView.separated(
          controller: _controller,
          padding: AllpassEdgeInsets.forCardInset,
          itemBuilder: (context, index) => MaterialCardWidget(
            data: provider.cardList[index],
            pageCreator: (_) => ViewCardPage(),
            onClick: () => provider.previewCard(index: index),
          ),
          itemCount: provider.count,
          physics: const AlwaysScrollableScrollPhysics(),
          separatorBuilder: (_, index) => SizedBox(height: 8),
        ),
      ),
    );
  }
}
