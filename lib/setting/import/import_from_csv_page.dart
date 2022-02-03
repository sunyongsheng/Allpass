import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import 'package:allpass/application.dart';
import 'package:allpass/card/data/card_dao.dart';
import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/core/enums/allpass_type.dart';
import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/password/data/password_dao.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/util/csv_util.dart';
import 'package:allpass/util/toast_util.dart';

class ImportFromCsvPage extends StatelessWidget {
  final CardDao cardDao = AllpassApplication.getIt.get();
  final PasswordDao passwordDao = AllpassApplication.getIt.get();

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
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['csv']
                  );
                  _process(context, importFuture(context, AllpassType.password,
                      result?.files.single.path));
                }
            ),
          ),
          Container(
            padding: AllpassEdgeInsets.listInset,
            child: ListTile(
                title: Text("卡片"),
                leading: Icon(Icons.credit_card, color: AllpassColorUI.allColor[1]),
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['csv']
                  );
                  _process(context, importFuture(context, AllpassType.card,
                      result?.files.single.path));
                }
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> importFuture(BuildContext context, AllpassType type, String? path) async {
    if (path != null) {
      try {
        if (type == AllpassType.password) {
          List<PasswordBean> passwordList = await CsvUtil.passwordImportFromCsv(path: path) ?? [];
          for (var bean in passwordList) {
            await Provider.of<PasswordProvider>(context, listen: false).insertPassword(bean);
            RuntimeData.labelListAdd(bean.label);
            RuntimeData.folderListAdd(bean.folder);
          }
          ToastUtil.show(msg: "导入 ${passwordList.length}条记录");
          await Provider.of<PasswordProvider>(context, listen: false).refresh();
        } else {
          List<CardBean> cardList = await CsvUtil.cardImportFromCsv(path) ?? [];
          for (var bean in cardList) {
            await Provider.of<CardProvider>(context, listen: false).insertCard(bean);
            RuntimeData.labelListAdd(bean.label);
            RuntimeData.folderListAdd(bean.folder);
          }
          ToastUtil.show(msg: "导入 ${cardList.length}条记录");
          await Provider.of<CardProvider>(context, listen: false).refresh();
        }
      } catch (assertError) {
        ToastUtil.showError(msg: "导入失败，请确保csv文件为标准Allpass导出文件");
      }
    } else {
      ToastUtil.show(msg: "取消导入");
    }
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
