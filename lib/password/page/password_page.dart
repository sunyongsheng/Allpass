import 'dart:io';

import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/confirm_dialog.dart';
import 'package:allpass/common/widget/empty_data_widget.dart';
import 'package:allpass/common/widget/select_item_dialog.dart';
import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/page/edit_password_page.dart';
import 'package:allpass/password/page/view_password_page.dart';
import 'package:allpass/password/widget/letter_index_bar.dart';
import 'package:allpass/password/widget/password_widget_item.dart';
import 'package:allpass/search/search_page.dart';
import 'package:allpass/search/search_provider.dart';
import 'package:allpass/search/widget/search_button_widget.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 密码页面
class PasswordPage extends StatefulWidget {
  @override
  _PasswordPageState createState() {
    return _PasswordPageState();
  }
}

class _PasswordPageState extends State<PasswordPage>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<Null> _query(PasswordProvider model) async {
    await model.refresh();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    PasswordProvider model = context.watch();

    List<Widget> appbarActions = [
      IconButton(
        splashColor: Colors.transparent,
        icon: RuntimeData.multiPasswordSelected
            ? Icon(Icons.clear)
            : Icon(Icons.sort),
        onPressed: () {
          setState(() {
            RuntimeData.multiSelectClear(AllpassType.password);
          });
        },
      ),
      Padding(padding: AllpassEdgeInsets.smallLPadding)
    ];
    Widget? floatingButton;
    if (RuntimeData.multiPasswordSelected) {
      appbarActions.insertAll(0, [
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case "删除":
                _deletePassword(context, model);
                break;
              case "移动":
                _movePassword(context, model);
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
            if (RuntimeData.multiPasswordList.length != model.count) {
              RuntimeData.multiPasswordList.clear();
              setState(() {
                RuntimeData.multiPasswordList.addAll(model.passwordList);
              });
            } else {
              setState(() {
                RuntimeData.multiPasswordList.clear();
              });
            }
          },
        )
      ]);
    } else {
      if (Platform.isIOS) {
        floatingButton = FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => EditPasswordPage(null, DataOperation.add),
            ),
          ),
          heroTag: "password",
        );
      } else {
        Color mainColor = Theme.of(context).primaryColor;
        var circleFabBorder = CircleBorder();
        floatingButton = OpenContainer(
          closedBuilder: (context, openContainer) {
            return Tooltip(
              message: "添加密码项目",
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
            return EditPasswordPage(null, DataOperation.add);
          },
        );
      }
    }

    Widget listView;
    if (model.passwordList.isNotEmpty) {
      if (RuntimeData.multiPasswordSelected) {
        listView = ListView.builder(
          controller: _controller,
          itemBuilder: (context, index) => MultiPasswordWidgetItem(index),
          itemCount: model.count,
          physics: const AlwaysScrollableScrollPhysics(),
        );
      } else {
        listView = Stack(
          children: <Widget>[
            ListView.builder(
              controller: _controller,
              itemBuilder: (context, index) {
                return MaterialPasswordWidget(
                  data: model.passwordList[index],
                  containerShape: 0,
                  pageCreator: (_) => ViewPasswordPage(),
                  onPasswordClicked: () => model.previewPassword(index: index),
                );
              },
              itemCount: model.count,
              physics: const AlwaysScrollableScrollPhysics(),
            ),
            LetterIndexBar(_controller),
          ],
        );
      }
    } else {
      listView = EmptyDataWidget(subtitle: "这里存储你的密码信息，例如\n微博账号、知乎账号等");
    }

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: AllpassEdgeInsets.smallLPadding,
          child: InkWell(
            splashColor: Colors.transparent,
            child: Text(
              "密码",
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
          SearchButtonWidget(_searchPress, "密码"),
          // 密码列表
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _query(model),
              child: Scrollbar(
                child: listView,
              ),
            ),
          )
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
          value: SearchProvider(AllpassType.password, context),
          child: SearchPage(AllpassType.password),
        ),
      ),
    );
  }

  void _deletePassword(BuildContext context, PasswordProvider model) {
    if (RuntimeData.multiPasswordList.length == 0) {
      ToastUtil.show(msg: "请选择至少一项密码");
    } else {
      showDialog<bool>(
        context: context,
        builder: (context) => ConfirmDialog(
          "确认删除",
          "您将删除${RuntimeData.multiPasswordList.length}项密码，确认吗？",
          danger: true,
          onConfirm: () async {
            for (var item in RuntimeData.multiPasswordList) {
              await model.deletePassword(item);
            }
            RuntimeData.multiPasswordList.clear();
          },
        ),
      );
    }
  }

  void _movePassword(BuildContext context, PasswordProvider model) {
    if (RuntimeData.multiPasswordList.length == 0) {
      ToastUtil.show(msg: "请选择至少一项密码");
    } else {
      showDialog(
        context: context,
        builder: (context) => DefaultSelectItemDialog<String>(
          list: RuntimeData.folderList,
          onSelected: (value) async {
            for (int i = 0; i < RuntimeData.multiPasswordList.length; i++) {
              RuntimeData.multiPasswordList[i].folder = value;
              await model.updatePassword(RuntimeData.multiPasswordList[i]);
            }
            ToastUtil.show(
              msg: "已移动${RuntimeData.multiPasswordList.length}项密码至 $value 文件夹",
            );
            setState(
              () {
                RuntimeData.multiPasswordList.clear();
              },
            );
          },
        ),
      );
    }
  }
}
