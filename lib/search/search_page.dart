import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/card/page/edit_card_page.dart';
import 'package:allpass/card/page/view_card_page.dart';
import 'package:allpass/card/widget/card_widget_item.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/bottom_sheet.dart';
import 'package:allpass/common/widget/confirm_dialog.dart';
import 'package:allpass/common/widget/empty_data_widget.dart';
import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/password/page/edit_password_page.dart';
import 'package:allpass/password/page/view_password_page.dart';
import 'package:allpass/password/widget/password_widget_item.dart';
import 'package:allpass/search/search_provider.dart';
import 'package:allpass/encrypt/encrypt_util.dart';
import 'package:allpass/util/theme_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final AllpassType type;

  SearchPage(this.type);

  @override
  State<SearchPage> createState() => _SearchPage(type);
}

class _SearchPage extends State<SearchPage> {
  final AllpassType type;

  late TextEditingController searchController;
  late FocusNode focusNode;

  _SearchPage(this.type);

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (_, provider, __) {
      return Scaffold(
          appBar: AppBar(
            title: searchWidget(provider),
            automaticallyImplyLeading: false,
          ),
          body: provider.empty()
              ? Center(child: EmptyDataWidget(title: context.l10n.searchResultEmpty))
              : ListView.builder(
                itemBuilder: (_, index) =>
                    buildSearchResultItem(provider, index),
                itemCount: provider.length(),
          ),
      );
    });
  }

  Widget buildSearchResultItem(SearchProvider provider, int index) {
    if (type == AllpassType.password) {
      var item = provider.passwordSearch[index];
      return PasswordWidgetItem(
        data: item,
        onPasswordClicked: () {
          focusNode.unfocus();
          showModalBottomSheet(
            context: context,
            builder: (context) => createPassBottomSheet(context, item),
          );
        },
      );
    } else if (type == AllpassType.card) {
      var item = provider.cardSearch[index];
      return SimpleCardWidgetItem(
        data: provider.cardSearch[index],
        onCardClicked: () {
          focusNode.unfocus();
          showModalBottomSheet(
            context: context,
            builder: (context) => createCardBottomSheet(context, item),
          );
        },
      );
    }
    return Container();
  }

  /// 搜索栏
  Widget searchWidget(SearchProvider provider) {
    var l10n = context.l10n;
    return Container(
      padding: EdgeInsets.only(left: 0, right: 0, bottom: 11, top: 11),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: AllpassUI.smallBorderRadius,
                color: Theme.of(context).inputDecorationTheme.fillColor,
              ),
              height: 35,
              child: TextField(
                style: TextStyle(fontSize: 14),
                controller: searchController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 20, right: 20),
                  hintText: l10n.searchHint,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: ThemeUtil.isInDarkTheme(context)
                        ? Colors.grey
                        : Colors.grey[900],
                  ),
                ),
                onChanged: (_) {
                  provider.search(searchController.text.toLowerCase());
                },
                onEditingComplete: () {
                  provider.search(searchController.text.toLowerCase());
                },
              ),
            ),
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Text(l10n.cancel, style: AllpassTextUI.secondTitleStyle),
            ),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // 点击密码弹出模态菜单
  Widget createPassBottomSheet(BuildContext context, PasswordBean data) {
    var l10n = context.l10n;
    return BaseBottomSheet(
      builder: (context) => <Widget>[
        ListTile(
          leading: Icon(
            Icons.remove_red_eye,
            color: Colors.lightGreen,
          ),
          title: Text(l10n.view),
          onTap: () {
            Navigator.pop(context);
            context.read<PasswordProvider>().previewPassword(bean: data);
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ViewPasswordPage(),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(
            Icons.edit,
            color: Colors.blue,
          ),
          title: Text(l10n.edit),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => EditPasswordPage(data, DataOperation.update),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.teal,
          ),
          title: Text(l10n.copyUsername),
          onTap: () {
            Clipboard.setData(ClipboardData(text: data.username));
            ToastUtil.show(msg: l10n.usernameCopied);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.content_copy,
            color: Colors.orange,
          ),
          title: Text(l10n.copyPassword),
          onTap: () async {
            String pw = EncryptUtil.decrypt(data.password);
            Clipboard.setData(ClipboardData(text: pw));
            ToastUtil.show(msg: l10n.passwordCopied);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.delete_outline,
            color: Colors.red,
          ),
          title: Text(l10n.deletePassword),
          onTap: () => showDialog(
            context: context,
            builder: (context) => ConfirmDialog(
              l10n.confirmDelete,
              l10n.deletePasswordWaring,
              danger: true,
              onConfirm: () async {
                await context.read<PasswordProvider>().deletePassword(data);
                ToastUtil.show(msg: l10n.deleteSuccess);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  // 点击卡片弹出模态菜单
  Widget createCardBottomSheet(BuildContext context, CardBean data) {
    var l10n = context.l10n;
    return BaseBottomSheet(
      builder: (context) => <Widget>[
        ListTile(
          leading: Icon(
            Icons.remove_red_eye,
            color: Colors.lightGreen,
          ),
          title: Text(l10n.view),
          onTap: () {
            Navigator.pop(context);
            context.read<CardProvider>().previewCard(bean: data);
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => ViewCardPage()));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.edit,
            color: Colors.blue,
          ),
          title: Text(l10n.edit),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => EditCardPage(data, DataOperation.update),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.teal,
          ),
          title: Text(l10n.copyOwnerName),
          onTap: () {
            Clipboard.setData(ClipboardData(text: data.ownerName));
            ToastUtil.show(msg: l10n.ownerNameCopied);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.content_copy,
            color: Colors.orange,
          ),
          title: Text(l10n.copyCardId),
          onTap: () {
            Clipboard.setData(ClipboardData(text: data.cardId));
            ToastUtil.show(msg: l10n.cardIdCopied);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.delete_outline,
            color: Colors.red,
          ),
          title: Text(l10n.deleteCard),
          onTap: () => showDialog(
            context: context,
            builder: (context) => ConfirmDialog(
              l10n.confirmDelete,
              l10n.deleteCardWarning,
              danger: true,
              onConfirm: () async {
                await context.read<CardProvider>().deleteCard(data);
                ToastUtil.show(msg: l10n.deleteSuccess);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }
}
