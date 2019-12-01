import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_file_picker/flutter_document_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:directory_picker/directory_picker.dart';

import 'package:allpass/dao/card_dao.dart';
import 'package:allpass/dao/password_dao.dart';
import 'package:allpass/model/card_bean.dart';
import 'package:allpass/model/password_bean.dart';
import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/csv_helper.dart';
import 'package:allpass/pages/setting/chrome_import_help.dart';

/// 导入导出页面
class ImportExportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text("导入/导出", style: AllpassTextUI.mainTitleStyle,),
        centerTitle: true,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ListTile(
              title: Text("从Chrome中导入"),
              leading: Icon(CustomIcons.chrome),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ChromeImportHelpPage(),
                ));
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ListTile(
              title: Text("从CSV文件中导入"),
              leading: Icon(Icons.import_contacts),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ImportTypeSelectPage(),
                ));
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ListTile(
              title: Text("导出为CSV文件"),
              leading: Icon(Icons.call_missed_outgoing),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ExportTypeSelectPage(),
                ));
              },
            ),
          )
        ],
      )
    );
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
        title: Text("选择导入类型", style: AllpassTextUI.mainTitleStyle,),
        centerTitle: true,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        brightness: Brightness.light,
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ListTile(
              title: Text("密码"),
              leading: Icon(Icons.supervised_user_circle),
              onTap: () async {
                FlutterDocumentPickerParams param = FlutterDocumentPickerParams(
                  allowedFileExtensions: ["csv"]
                );
                String path = await FlutterDocumentPicker.openDocument(params: param);
                if (path != null) {
                  try {
                    List<PasswordBean> passwordList = await CsvHelper().passwordImportFromCsv(path);
                    for (var bean in passwordList) {
                      passwordDao.insert(bean);
                    }
                    Fluttertoast.showToast(msg: "导入 ${passwordList.length}条记录");
                  } catch (assertError) {
                    Fluttertoast.showToast(msg: "导入失败，请确保csv文件为标准Allpass导出文件");
                  }
                } else {
                  Fluttertoast.showToast(msg: "取消导入");
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ListTile(
              title: Text("卡片"),
              leading: Icon(Icons.credit_card),
              onTap: () async {
                FlutterDocumentPickerParams param = FlutterDocumentPickerParams(
                    allowedFileExtensions: ["csv"]
                );
                String path = await FlutterDocumentPicker.openDocument(params: param);
                if (path != null) {
                  try {
                    List<CardBean> cardList = await CsvHelper().cardImportFromCsv(path);
                    for (var bean in cardList) {
                      cardDao.insert(bean);
                    }
                    Fluttertoast.showToast(msg: "导入 ${cardList.length}条记录");
                  } catch (assertError) {
                    Fluttertoast.showToast(msg: "导入失败，请确保csv文件为标准Allpass导出文件");
                  }
                } else {
                  Fluttertoast.showToast(msg: "取消导入");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 导出选择页
class ExportTypeSelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("选择导出内容", style: AllpassTextUI.mainTitleStyle,),
        centerTitle: true,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        brightness: Brightness.light,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ListTile(
              title: Text("密码"),
              leading: Icon(Icons.supervised_user_circle),
              onTap: () async {
                Directory dir = await getExternalStorageDirectory();
                Directory newDir = await DirectoryPicker.pick(
                    context: context,
                    rootDirectory: dir,
                );
                List<PasswordBean> list = await PasswordDao().getAllPasswordBeanList();
                String path = await CsvHelper().passwordExportCsv(list, newDir);
                Clipboard.setData(ClipboardData(text: path));
                Fluttertoast.showToast(msg: "已导出到$newDir");
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ListTile(
              title: Text("卡片"),
              leading: Icon(Icons.credit_card),
              onTap: () async {
                Directory dir = await getExternalStorageDirectory();
                Directory newDir = await DirectoryPicker.pick(
                  context: context,
                  rootDirectory: dir,
                );
                List<CardBean> list = await CardDao().getAllCardBeanList();
                String path = await CsvHelper().cardExportCsv(list, newDir);
                Clipboard.setData(ClipboardData(text: path));
                Fluttertoast.showToast(msg: "已导出到$newDir");
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ListTile(
              title: Text("所有"),
              leading: Icon(Icons.all_inclusive),
              onTap: () async {
                Directory dir = await getExternalStorageDirectory();
                Directory newDir = await DirectoryPicker.pick(
                  context: context,
                  rootDirectory: dir,
                );
                List<PasswordBean> passList = await PasswordDao().getAllPasswordBeanList();
                await CsvHelper().passwordExportCsv(passList, newDir);
                List<CardBean> cardList = await CardDao().getAllCardBeanList();
                await CsvHelper().cardExportCsv(cardList, newDir);
                Fluttertoast.showToast(msg: "已导出到$newDir");
              },
            ),
          ),
        ],
      ),
    );
  }

}