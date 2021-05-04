import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:filesystem_picker/filesystem_picker.dart';

import 'package:allpass/card/data/card_dao.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/confirm_dialog.dart';
import 'package:allpass/core/param/allpass_type.dart';
import 'package:allpass/password/data/password_dao.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/setting/account/widget/input_main_password_dialog.dart';
import 'package:allpass/util/csv_util.dart';
import 'package:allpass/util/toast_util.dart';

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
                  if (confirm != null && confirm) {
                    if (!Platform.isAndroid) {
                      ToastUtil.show(msg: "导出目前只支持安卓设备");
                      return;
                    }
                    showDialog<bool>(
                        context: context,
                        builder: (context) => InputMainPasswordDialog()
                    ).then((right) async {
                      if (right) {
                        String path = await goToConfirm(context);
                        if (path != null) {
                          _process(context, exportFuture(context, Directory(path), type: AllpassType.Password));
                        }
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
                  if (confirm != null && confirm) {
                    if (!Platform.isAndroid) {
                      ToastUtil.show(msg: "导出目前只支持安卓设备");
                      return;
                    }
                    showDialog<bool>(
                        context: context,
                        builder: (context) => InputMainPasswordDialog()
                    ).then((right) async{
                      if (right != null && right) {
                        String path = await goToConfirm(context);
                        if (path != null) {
                          _process(context, exportFuture(context, Directory(path), type: AllpassType.Card));
                        }
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
                  if (confirm != null && confirm) {
                    if (!Platform.isAndroid) {
                      ToastUtil.show(msg: "导出目前只支持安卓设备");
                      return;
                    }
                    showDialog<bool>(
                        context: context,
                        builder: (context) => InputMainPasswordDialog()
                    ).then((right) async{
                      if (right) {
                        String path = await goToConfirm(context);
                        if (path != null) {
                          _process(context, exportFuture(context, Directory(path)));
                        }
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

  Future<String> goToConfirm(BuildContext context) async {
    return await FilesystemPicker.open(
        title: '保存到文件夹',
        context: context,
        rootName: "/Android/data/top.aengus.allpass/files",
        rootDirectory: await getExternalStorageDirectory(),
        fsType: FilesystemType.folder,
        pickText: '确认保存',
        folderIconColor: Theme.of(context).primaryColor,
        requestPermission: () async {
          return await askPermission();
        }
    );
  }

  Future<bool> askPermission() async {
    if (await Permission.storage.isGranted) {
      return true;
    }
    if (await Permission.storage.isDenied || await Permission.storage.isLimited) {
      return await Permission.storage.request() == PermissionStatus.granted;
    }
    return false;
  }

  Future<Null> exportFuture(BuildContext context, Directory newDir, {AllpassType type}) async {
    switch (type) {
      case AllpassType.Password:
        List<PasswordBean> list = await PasswordDao().getAllPasswordBeanList();
        String path = await CsvUtil.passwordExportCsv(list, newDir);
        Clipboard.setData(ClipboardData(text: path));
        break;
      case AllpassType.Card:
        List<CardBean> list = await CardDao().getAllCardBeanList();
        String path = await CsvUtil.cardExportCsv(list, newDir);
        Clipboard.setData(ClipboardData(text: path));
        break;
      default:
        List<PasswordBean> passList = await PasswordDao().getAllPasswordBeanList();
        await CsvUtil.passwordExportCsv(passList, newDir);
        List<CardBean> cardList = await CardDao().getAllCardBeanList();
        await CsvUtil.cardExportCsv(cardList, newDir);
    }
    ToastUtil.show(msg: "已导出到$newDir");
  }
}

void _process(BuildContext context, Future futureFunction) {
  showDialog(
      context: context,
      builder: (cx) => FutureBuilder(
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