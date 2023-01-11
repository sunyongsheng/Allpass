import 'dart:io';
import 'package:allpass/card/data/card_repository.dart';
import 'package:allpass/password/data/password_repository.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:allpass/application.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/confirm_dialog.dart';
import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/setting/account/widget/input_main_password_dialog.dart';
import 'package:allpass/util/csv_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:share/share.dart';

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
                showDialog(
                    context: context,
                    builder: (context) => ConfirmDialog(
                      "导出确认",
                      "导出后的密码将被所有人可见，确认吗？",
                      onConfirm: () {
                        showDialog<bool>(
                            context: context,
                            builder: (context) => InputMainPasswordDialog(
                              onVerified: () async {
                                var directory = await getApplicationDocumentsDirectory();
                                exportActual(context, Directory(directory.path), type: AllpassType.password);
                              },
                            )
                        );
                      },
                    )
                );
              },
            ),
          ),
          Container(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              title: Text("卡片"),
              leading: Icon(Icons.credit_card, color: AllpassColorUI.allColor[1]),
              onTap: () => showDialog<bool>(
                  context: context,
                  builder: (context) => ConfirmDialog(
                    "导出确认",
                    "导出后的卡片将被所有人可见，确认吗？",
                    onConfirm: () {
                      showDialog<bool>(
                          context: context,
                          builder: (context) => InputMainPasswordDialog(
                            onVerified: () async {
                              var directory = await getApplicationDocumentsDirectory();
                              exportActual(context, Directory(directory.path), type: AllpassType.card);
                            },
                          )
                      );
                    },
                  )
              ),
            ),
          ),
          Container(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
              title: Text("所有"),
              leading: Icon(Icons.all_inclusive, color: AllpassColorUI.allColor[4]),
              onTap: () => showDialog(
                  context: context,
                  builder: (context) => ConfirmDialog(
                    "导出确认",
                    "导出后的数据将被所有人可见，确认吗？",
                    onConfirm: () {
                      showDialog<bool>(
                          context: context,
                          builder: (context) => InputMainPasswordDialog(
                            onVerified: () async {
                              var directory = await getApplicationDocumentsDirectory();
                              exportActual(context, Directory(directory.path));
                            },
                          )
                      );
                    },
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> exportActual(BuildContext context, Directory newDir, {AllpassType? type}) async {
    switch (type) {
      case AllpassType.password:
        PasswordRepository passwordRepository = AllpassApplication.getIt.get();
        List<PasswordBean> list = await passwordRepository.requestAll();
        ExportResult result = await CsvUtil.passwordExportCsv(list, newDir);
        if (result.success) {
          Share.shareFiles([result.path!], mimeTypes: ["text/*"]);
        } else {
          ToastUtil.show(msg: "导出失败: ${result.msg}");
        }
        break;
      case AllpassType.card:
        CardRepository cardRepository = AllpassApplication.getIt.get();
        List<CardBean> list = await cardRepository.requestAll();
        ExportResult result = await CsvUtil.cardExportCsv(list, newDir);
        if (result.success) {
          Share.shareFiles([result.path!], mimeTypes: ["text/*"]);
        } else {
          ToastUtil.show(msg: "导出失败: ${result.msg}");
        }
        break;
      default:
        PasswordRepository passwordRepository = AllpassApplication.getIt.get();
        List<PasswordBean> passwordList = await passwordRepository.requestAll();
        ExportResult passwordResult = await CsvUtil.passwordExportCsv(passwordList, newDir);
        CardRepository cardRepository = AllpassApplication.getIt.get();
        List<CardBean> cardList = await cardRepository.requestAll();
        ExportResult cardResult = await CsvUtil.cardExportCsv(cardList, newDir);
        if (passwordResult.success && cardResult.success) {
          Share.shareFiles([passwordResult.path!, cardResult.path!], mimeTypes: ["text/*", "text/*"]);
        } else {
          ToastUtil.show(msg: "导出失败: ${passwordResult.msg}");
        }
    }
  }
}