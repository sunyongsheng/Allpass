import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/card/page/edit_card_page.dart';
import 'package:allpass/card/page/view_card_page.dart';
import 'package:allpass/card/widget/card_widget_item.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/confirm_dialog.dart';
import 'package:allpass/common/widget/empty_data_widget.dart';
import 'package:allpass/common/widget/multi_edit_button.dart';
import 'package:allpass/common/widget/route_floating_action_button.dart';
import 'package:allpass/common/widget/select_item_dialog.dart';
import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/extension/widget_extension.dart';
import 'package:allpass/l10n/l10n_support.dart';
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

    var l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: AllpassEdgeInsets.smallLPadding,
          child: InkWell(
            splashColor: Colors.transparent,
            child: Text(
              l10n.card,
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
          SearchButtonWidget(_searchPress, l10n.card),
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
        builder: (_, editMode, child) => AnimatedScale(
          scale: editMode ? 0 : 1,
          duration: Duration(milliseconds: 180),
          child: child,
        ),
        child: MaterialRouteFloatingActionButton(
          heroTag: "add_card",
          tooltip: l10n.addCardItem,
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
        builder: (context) => ChangeNotifierProvider(
          create: (context) => SearchProvider(AllpassType.card),
          child: SearchPage(AllpassType.card),
        ),
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      Selector<MultiItemEditProvider<CardBean>, bool>(
        selector: (_, editProvider) => editProvider.editMode,
        builder: (context, editMode, __) {
          var provider = context.read<CardProvider>();
          var editProvider = context.read<MultiItemEditProvider<CardBean>>();
          return MultiEditButton(
            inEditMode: editMode,
            onClickMove: () => _moveCard(context, provider, editProvider),
            onClickDelete: () => _deleteCard(context, provider, editProvider),
            onClickEdit: editProvider.switchEditMode,
            onClickSelectAll: () {
              if (editProvider.selectedCount != provider.count) {
                editProvider.selectAll(provider.cardList);
              } else {
                editProvider.unselectAll();
              }
            },
          );
        },
      )
    ];
  }

  void _deleteCard(
    BuildContext context,
    CardProvider provider,
    MultiItemEditProvider<CardBean> editProvider,
  ) {
    var cardProvider = context.read<CardProvider>();
    var editProvider = context.read<MultiItemEditProvider<CardBean>>();
    if (editProvider.isEmpty) {
      ToastUtil.show(msg: context.l10n.selectOneCardAtLeast);
    } else {
      showDialog<bool>(
        context: context,
        builder: (context) => ConfirmDialog(
          context.l10n.confirmDelete,
          context.l10n.deletePasswordsWarning(editProvider.selectedCount),
          danger: true,
          onConfirm: () async {
            for (var item in editProvider.selectedItem) {
              await cardProvider.deleteCard(item);
            }
            ToastUtil.show(msg: context.l10n.deletePasswordsSuccess(editProvider.selectedCount));
            editProvider.unselectAll();
          },
        ),
      );
    }
  }

  void _moveCard(
    BuildContext context,
    CardProvider provider,
    MultiItemEditProvider<CardBean> editProvider,
  ) {
    var cardProvider = context.read<CardProvider>();
    var editProvider = context.read<MultiItemEditProvider<CardBean>>();
    if (editProvider.isEmpty) {
      ToastUtil.show(msg: context.l10n.selectOneCardAtLeast);
    } else {
      showDialog(
        context: context,
        builder: (context) => DefaultSelectItemDialog<String>(
          list: RuntimeData.folderList,
          onSelected: (value) async {
            editProvider.selectedItem.forEach((element) async {
              element.folder = value;
              await cardProvider.updateCard(element);
            });
            ToastUtil.show(
              msg: context.l10n.moveCardsSuccess(editProvider.selectedCount, value),
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
      child: EmptyDataWidget(subtitle: context.l10n.cardEmptyHint),
    );
  }

  Widget _buildCardList() {
    return Consumer2<CardProvider, MultiItemEditProvider<CardBean>>(
      builder: (_, provider, editProvider, cardList) {
        if (editProvider.editMode) {
          return Scrollbar(
            controller: _controller,
            child: ListView.builder(
              controller: _controller,
              itemBuilder: (context, index) => MultiCardWidgetItem(
                card: provider.cardList[index],
                selection: editProvider.isSelected,
                onChanged: editProvider.select,
              ),
              itemCount: provider.count,
              physics: const AlwaysScrollableScrollPhysics(),
            ),
          );
        } else {
          return cardList!;
        }
      },
      child: Consumer<CardProvider>(
        builder: (_, provider, __) => Scrollbar(
          controller: _controller,
          child: ListView.separated(
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
      ),
    );
  }
}
