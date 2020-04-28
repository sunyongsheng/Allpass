import 'dart:io';

import 'package:allpass/params/runtime_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_file_picker/flutter_document_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:directory_picker/directory_picker.dart';
import 'package:provider/provider.dart';

import 'package:allpass/params/allpass_type.dart';
import 'package:allpass/dao/card_dao.dart';
import 'package:allpass/dao/password_dao.dart';
import 'package:allpass/model/card_bean.dart';
import 'package:allpass/model/password_bean.dart';
import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/ui/icon_resource.dart';
import 'package:allpass/utils/csv_util.dart';
import 'package:allpass/pages/setting/import/chrome_import_help.dart';
import 'package:allpass/pages/setting/import/import_from_clipboard_page.dart';
import 'package:allpass/provider/card_list.dart';
import 'package:allpass/provider/password_list.dart';
import 'package:allpass/widgets/common/confirm_dialog.dart';
import 'package:allpass/widgets/setting/input_main_password_dialog.dart';

/// 导入导出页面
class ImportExportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          title: Text(
            "导入/导出",
            style: AllpassTextUI.titleBarStyle,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: AllpassEdgeInsets.listInset,
              child: ListTile(
                title: Text("从Chrome中导入"),
                leading: Icon(CustomIcons.chrome, color: AllpassColorUI.allColor[6]),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ChromeImportHelpPage(),
                      ));
                },
              ),
            ),
            Container(
              padding: AllpassEdgeInsets.listInset,
              child: ListTile(
                title: Text("从CSV文件中导入"),
                leading: Icon(Icons.import_contacts, color: AllpassColorUI.allColor[4]),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ImportTypeSelectPage(),
                      ));
                },
              ),
            ),
            Container(
              padding: AllpassEdgeInsets.listInset,
              child: ListTile(
                title: Text("从剪贴板中导入"),
                leading: Icon(Icons.content_paste, color: AllpassColorUI.allColor[1]),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ImportFromClipboard(),
                      ));
                },
              ),
            ),
            Container(
              padding: AllpassEdgeInsets.listInset,
              child: ListTile(
                title: Text("导出为CSV文件"),
                leading: Icon(Icons.call_missed_outgoing, color: AllpassColorUI.allColor[3]),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ExportTypeSelectPage(),
                      ));
                },
              ),
            )
          ],
        ));
  }
}

/// 导入类型选择
class ImportTypeSelectPage extends StatelessWidget {
  final CardDao cardDao = CardDao();
  final PasswordDao passwordDao = PasswordDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "选择导入类型",
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              title: Text("密码"),
              leading: Icon(Icons.supervised_user_circle, color: AllpassColorUI.allColor[0]),
              onTap: () async {
                FlutterDocumentPickerParams param = FlutterDocumentPickerParams(
                    allowedFileExtensions: ["csv"]
                );
                String path = await FlutterDocumentPicker.openDocument(params: param);
                _process(context, importFuture(context, AllpassType.PASSWORD, path));
              }
            ),
          ),
          Container(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              title: Text("卡片"),
              leading: Icon(Icons.credit_card, color: AllpassColorUI.allColor[1]),
              onTap: () async {
                FlutterDocumentPickerParams param = FlutterDocumentPickerParams(
                    allowedFileExtensions: ["csv"]
                );
                String path = await FlutterDocumentPicker.openDocument(params: param);
                _process(context, importFuture(context, AllpassType.CARD, path));
              }
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> importFuture(BuildContext context, AllpassType type, String path) async {
    if (path != null) {
      try {
        if (type == AllpassType.PASSWORD) {
          List<PasswordBean> passwordList = await CsvUtil().passwordImportFromCsv(path: path);
          for (var bean in passwordList) {
            await Provider.of<PasswordList>(context).insertPassword(bean);
            RuntimeData.labelListAdd(bean.label);
            RuntimeData.folderListAdd(bean.folder);
          }
          Fluttertoast.showToast(msg: "导入 ${passwordList.length}条记录");
          await Provider.of<PasswordList>(context).refresh();
        } else {
          List<CardBean> cardList = await CsvUtil().cardImportFromCsv(path);
          for (var bean in cardList) {
            await Provider.of<CardList>(context).insertCard(bean);
            RuntimeData.labelListAdd(bean.label);
            RuntimeData.folderListAdd(bean.folder);
          }
          Fluttertoast.showToast(msg: "导入 ${cardList.length}条记录");
          await Provider.of<CardList>(context).refresh();
        }
      } catch (assertError) {
        Fluttertoast.showToast(msg: "导入失败，请确保csv文件为标准Allpass导出文件");
      }
    } else {
      Fluttertoast.showToast(msg: "取消导入");
    }
  }
}

/// 导出选择页
class ExportTypeSelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "选择导出内容",
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              title: Text("密码"),
              leading: Icon(Icons.supervised_user_circle, color: AllpassColorUI.allColor[0]),
              onTap: () {
                showDialog<bool>(
                  context: context,
                  builder: (context) => ConfirmDialog("导出确认", "导出后的密码将被所有人可见，确认吗？")).then((confirm) {
                    if (confirm) {
                      showDialog<bool>(
                        context: context,
                        builder: (context) => InputMainPasswordDialog()
                      ).then((right) async{
                        if (right) {
                          Directory dir = await getExternalStorageDirectory();
                          Directory newDir = await DirectoryPicker.pick(
                            context: context,
                            rootDirectory: dir,
                          );
                          _process(context, exportFuture(context, newDir, type: AllpassType.PASSWORD));
                        }
                      });
                    }
                });
              },
            ),
          ),
          Container(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              title: Text("卡片"),
              leading: Icon(Icons.credit_card, color: AllpassColorUI.allColor[1]),
              onTap: () {
                showDialog<bool>(
                    context: context,
                    builder: (context) => ConfirmDialog("导出确认", "导出后的卡片将被所有人可见，确认吗？")).then((confirm) {
                  if (confirm) {
                    showDialog<bool>(
                        context: context,
                        builder: (context) => InputMainPasswordDialog()
                    ).then((right) async{
                      if (right) {
                        Directory dir = await getExternalStorageDirectory();
                        Directory newDir = await DirectoryPicker.pick(
                          context: context,
                          rootDirectory: dir,
                        );
                        _process(context, exportFuture(context, newDir, type: AllpassType.CARD));
                      }
                    });
                  }
                });
              },
            ),
          ),
          Container(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              title: Text("所有"),
              leading: Icon(Icons.all_inclusive, color: AllpassColorUI.allColor[4]),
              onTap: () {
                showDialog<bool>(
                    context: context,
                    builder: (context) => ConfirmDialog("导出确认", "导出后的数据将被所有人可见，确认吗？")).then((confirm) {
                  if (confirm) {
                    showDialog<bool>(
                        context: context,
                        builder: (context) => InputMainPasswordDialog()
                    ).then((right) async{
                      if (right) {
                        Directory dir = await getExternalStorageDirectory();
                        Directory newDir = await DirectoryPicker.pick(
                          context: context,
                          rootDirectory: dir,
                        );
                        _process(context, exportFuture(context, newDir));
                      }
                    });
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> exportFuture(BuildContext context, Directory newDir, {AllpassType type}) async {
    switch (type) {
      case AllpassType.PASSWORD:
        List<PasswordBean> list = await PasswordDao().getAllPasswordBeanList();
        String path = await CsvUtil().passwordExportCsv(list, newDir);
        Clipboard.setData(ClipboardData(text: path));
        break;
      case AllpassType.CARD:
        List<CardBean> list = await CardDao().getAllCardBeanList();
        String path = await CsvUtil().cardExportCsv(list, newDir);
        Clipboard.setData(ClipboardData(text: path));
        break;
      default:
        List<PasswordBean> passList = await PasswordDao().getAllPasswordBeanList();
        await CsvUtil().passwordExportCsv(passList, newDir);
        List<CardBean> cardList = await CardDao().getAllCardBeanList();
        await CsvUtil().cardExportCsv(cardList, newDir);
    }
    Fluttertoast.showToast(msg: "已导出到$newDir");
  }
}

void _process(BuildContext context, Future futureFunction) {
  showDialog(
      context: context,
      child: FutureBuilder(
        future: futureFunction,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Center(
                child: Icon(
                  Icons.check_circle,
                  size: 50,
                  color: Colors.white,
                ),
              );
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      )
  );
}
