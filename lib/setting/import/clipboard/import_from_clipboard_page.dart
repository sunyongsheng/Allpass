import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/setting/import/clipboard/content_parser.dart';
import 'package:allpass/setting/import/import_base_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/common/widget/loading_text_button.dart';
import 'package:allpass/common/widget/information_help_dialog.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';

/// 从剪贴板中导入
class ImportFromClipboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImportFromClipboardPage();
  }
}

class _ImportFromClipboardPage extends ImportBaseState<List<PasswordBean>> {

  late TextEditingController _controller;
  late TextEditingController _accountController;

  ContentFormatType _selectedType = ContentFormatType.nameAccountPasswordUrl;

  bool importing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _accountController = TextEditingController();
    _accountController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color mainColor = Theme
        .of(context)
        .primaryColor;
    var l10n = context.l10n;
    var fillColor = WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return mainColor;
      return Colors.grey;
    });
    var children = <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        padding: AllpassEdgeInsets.forCardInset,
        child: Text(
          l10n.importFromClipboardSelectFormat,
          style: TextStyle(
              fontSize: 16
          ),
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        child: Column(
          children: ContentFormatType.values.map((type) {
            return InkWell(
              child: Row(
                children: <Widget>[
                  Radio<ContentFormatType>(
                    fillColor: fillColor,
                    value: type, // "名称 账号 密码 网站地址"
                    groupValue: _selectedType,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = type;
                      });
                    },
                  ),
                  Text(
                    type.l10n(context),
                    style: AllpassTextUI.firstTitleStyle,
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _selectedType = type;
                });
              },
            );
          }).toList(growable: false),
        ),
      )
    ];
    if (_requireAccount(_selectedType)) {
      children.add(Container(
        padding: AllpassEdgeInsets.listInset,
        child: NoneBorderCircularTextField(
          editingController: _accountController,
          maxLines: 1,
          hintText: l10n.importFromClipboardFormatHint,
          errorText: _accountController.text.isEmpty
              ? l10n.importFromClipboardFormatHint2
              : null,
        ),
      ));
    }
    children.addAll([
      Container(
        padding: AllpassEdgeInsets.listInset,
        height: AllpassScreenUtil.setHeight(1000),
        child: NoneBorderCircularTextField(
          editingController: _controller,
          maxLines: 1000,
          hintText: l10n.pasteDataHere,
        ),
      ),
      Container(
        padding: AllpassEdgeInsets.forCardInset,
        child: LoadingTextButton(
          title: l10n.startImport,
          loadingTitle: l10n.importing,
          loading: importing,
          color: Theme
              .of(context)
              .primaryColor,
          onPressed: () {
            _onTapImport();
          },
        ),
      ),
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.importFromClipboard,
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () =>
                showDialog(
                  context: context,
                  builder: (context) =>
                      InformationHelpDialog(
                        content: <Widget>[
                          Text(l10n.importFromClipboardHelp1),
                          Text(l10n.importFromClipboardHelp2),
                          Text(l10n.importFromClipboardHelp3),
                          Text(l10n.importFromClipboardHelp4),
                          Text(l10n.importFromClipboardHelp5),
                          Text(l10n.importFromClipboardHelp6),
                        ],
                      ),
                ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }

  void _onTapImport() async {
    if (importing) {
      return;
    }

    if (_requireAccount(_selectedType)) {
      if (_accountController.text.isEmpty) {
        ToastUtil.show(msg: context.l10n.importFromClipboardFormatHint2);
        return;
      }
    }

    setState(() {
      importing = true;
    });
    List<PasswordBean> list = await parseText(_selectedType);
    if (list.isNotEmpty) {
      await startImport(context, list);
    }
    setState(() {
      importing = false;
    });
  }

  bool _requireAccount(ContentFormatType type) =>
      type == ContentFormatType.namePassword ||
          type == ContentFormatType.password;

  Future<List<PasswordBean>> parseText(ContentFormatType type) async {
    String text = _controller.text;
    if (text.isEmpty) {
      ToastUtil.show(msg: context.l10n.importFromClipboardFormatHint3);
      return [];
    }

    List<String> tempRows = text.split("\n");
    List<PasswordBean> result = [];
    var parser = ContentParser.of(type);
    var params = _requireAccount(type)
        ? AccountContentParserParams(_accountController.text)
        : EmptyContentParserParams.instance;
    var rowIndex = 0;
    for (String tr in tempRows) {
      rowIndex++;
      var row = tr.trim();
      if (row.isEmpty) continue;
      var model = parser.parse(row, params: params);
      if (model == null) {
        ToastUtil.show(msg: context.l10n.recordFormatIncorrect(rowIndex));
        return [];
      }

      result.add(model);
    }
    return result;
  }

  @override
  Future<int> importActual(
    BuildContext context,
    List<PasswordBean> params,
    void Function() ensureNotCancel,
    void Function(double p1) onUpdateProgress,
  ) async {
    var count = 0;
    var size = params.length;
    var passwordProvider = context.read<PasswordProvider>();
    for (var bean in params) {
      ensureNotCancel();

      await passwordProvider.insertPassword(bean);
      count++;
      onUpdateProgress(count / size);
    }
    return count;
  }
}
