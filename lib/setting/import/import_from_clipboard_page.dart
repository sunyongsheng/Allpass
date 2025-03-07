import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/setting/import/import_base_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/encrypt/encrypt_util.dart';
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

class _ImportFromClipboardPage extends ImportBaseState<int> {

  late TextEditingController _controller;

  int _groupValue = 1;

  bool importing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color mainColor = Theme.of(context).primaryColor;
    var l10n = context.l10n;
    var fillColor = WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return mainColor;
      return Colors.grey;
    });

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
              onPressed: () => showDialog(
                context: context,
                builder: (context) => InformationHelpDialog(
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
            children: <Widget>[
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
                padding: AllpassEdgeInsets.dividerInset,
                child: Column(
                  children: <Widget>[
                    InkWell(
                      child: Row(
                        children: <Widget>[
                          Radio<int>(
                            fillColor: fillColor,
                            value: 1, // "名称 账号 密码 网站地址"
                            groupValue: _groupValue,
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value!;
                              });
                            },
                          ),
                          Text(
                            l10n.importFromClipboardFormat1,
                            style: AllpassTextUI.firstTitleStyle,
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _groupValue = 1;
                        });
                      },
                    ),
                    InkWell(
                      child: Row(
                        children: <Widget>[
                          Radio<int>(
                            value: 2, // "名称 账号 密码",
                            fillColor: fillColor,
                            groupValue: _groupValue,
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value!;
                              });
                            },
                          ),
                          Text(
                            l10n.importFromClipboardFormat2,
                            style: AllpassTextUI.firstTitleStyle,
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _groupValue = 2;
                        });
                      },
                    ),
                    InkWell(
                      child: Row(
                        children: <Widget>[
                          Radio<int>(
                            value: 3, // "账号 密码 网站地址",
                            groupValue: _groupValue,
                            fillColor: fillColor,
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value!;
                              });
                            },
                          ),
                          Text(
                            l10n.importFromClipboardFormat3,
                            style: AllpassTextUI.firstTitleStyle,
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _groupValue = 3;
                        });
                      },
                    ),
                    InkWell(
                      child: Row(
                        children: <Widget>[
                          Radio<int>(
                            value: 4, // "账号 密码",
                            fillColor: fillColor,
                            groupValue: _groupValue,
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value!;
                              });
                            },
                          ),
                          Text(
                            l10n.importFromClipboardFormat4,
                            style: AllpassTextUI.firstTitleStyle,
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _groupValue = 4;
                        });
                      },
                    ),
                    InkWell(
                      child: Row(
                        children: <Widget>[
                          Radio<int>(
                            value: 5, // "密码",
                            fillColor: fillColor,
                            groupValue: _groupValue,
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value!;
                              });
                              ToastUtil.show(msg: l10n.importFromClipboardFormat5Hint);
                            },
                          ),
                          Text(
                            l10n.importFromClipboardFormat5,
                            style: AllpassTextUI.firstTitleStyle,
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _groupValue = 5;
                        });
                        ToastUtil.show(msg: l10n.importFromClipboardFormat5Hint);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: AllpassEdgeInsets.forViewCardInset,
                height: AllpassScreenUtil.setHeight(1000),
                child: NoneBorderCircularTextField(
                  editingController: _controller,
                  maxLines: 1000,
                  hintText: l10n.pasteDataHere,
                )
              ),
              Container(
                padding: AllpassEdgeInsets.forViewCardInset,
                child: LoadingTextButton(
                  title: l10n.startImport,
                  loadingTitle: l10n.importing,
                  loading: importing,
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    setState(() {
                      importing = true;
                    });
                    await startImport(context, _groupValue);
                    setState(() {
                      importing = false;
                    });
                  },
                ),
              ),
              Padding(
                padding: AllpassEdgeInsets.smallTBPadding,
              )
            ],
          ),
        ));
  }

  Future<List<PasswordBean>> parseText(int value) async {
    String text = _controller.text;
    if (text.isEmpty) return [];
    List<String> tempRows = text.split("\n");
    List<String> rows = [];
    for (String tr in tempRows) {
      if (tr.trim().length <= 1) continue;
      else rows.add(tr);
    }
    List<PasswordBean> temp = [];
    // 下面这种情况需要设置默认用户名
    var l10n = context.l10n;
    if (value == 5) {
      String defaultUsername = rows[0];
      for (String row in rows.sublist(1)) {
        List<String> tempFields = row.split(" ");
        List<String> fields = [];
        // 确保不会出现空字段
        for (String field in tempFields) {
          if (field == "") continue;
          else fields.add(field);
        }
        if (fields.length < 2) throw Exception(l10n.recordFormatIncorrect);
        temp.add(PasswordBean(
          name: fields[0],
          username: defaultUsername,
          password: EncryptUtil.encrypt(fields[1]),
          url: ""
        ));
      }
      return temp;
    }
    // 不用单独设置默认用户名
    for (String row in rows) {
      if (row.length <= 3) continue;
      List<String> tempFields = row.split(" ");
      List<String> fields = [];
      for (String field in tempFields) {
        if (field == "") continue;
        else fields.add(field);
      }
      if (value == 1) {
        if (fields.length < 4) throw Exception(l10n.recordFormatIncorrect);
        temp.add(PasswordBean(
          name: fields[0],
          username: fields[1],
          password: EncryptUtil.encrypt(fields[2]),
          url: fields[3],
        ));
      } else if (value == 2) {
        if (fields.length < 3) throw Exception(l10n.recordFormatIncorrect);
        temp.add(PasswordBean(
          name: fields[0],
          username: fields[1],
          password: EncryptUtil.encrypt(fields[2]),
          url: "",
        ));
      } else if (value == 3) {
        if (fields.length < 3) throw Exception(l10n.recordFormatIncorrect);
        temp.add(PasswordBean(
          name: "",
          username: fields[0],
          password: EncryptUtil.encrypt(fields[1]),
          url: fields[2],
        ));
      } else if (value == 4) {
        if (fields.length < 2) throw Exception(l10n.recordFormatIncorrect);
        temp.add(PasswordBean(
          name: "",
          username: fields[0],
          password: EncryptUtil.encrypt(fields[1]),
          url: "",
        ));
      }
    }
    return temp;
  }
  
  @override
  Future<bool> importActual(
    BuildContext context,
    int params,
    void Function() ensureNotCancel,
    void Function(double p1) onUpdateProgress,
  ) async {
    List<PasswordBean> list = await parseText(_groupValue);
    var count = 0;
    var size = list.length;
    var passwordProvider = context.read<PasswordProvider>();
    for (var bean in list) {
      ensureNotCancel();

      await passwordProvider.insertPassword(bean);
      count++;
      onUpdateProgress(count / size);
    }
    ToastUtil.show(msg: context.l10n.importRecordSuccess(list.length));
    return true;
  }
}
