import 'package:flutter/material.dart';

import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/pages/setting/category_manager_page.dart';
import 'package:allpass/pages/setting/csv_import_export_page.dart';

/// 设置页面
class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _SettingPage();
}

class _SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<_SettingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "设置",
          style: AllpassTextUI.mainTitleStyle,
        ),
        centerTitle: true,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  child: ListTile(
                    title: Text("标签管理"),
                    leading: Icon(Icons.label_outline),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryManagerPage("标签")));
                    },
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15),
                ),
                Container(
                  child: ListTile(
                    title: Text("文件夹管理"),
                    leading: Icon(Icons.folder_open),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryManagerPage("文件夹")));
                    },
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15),
                ),
                Container(
                  child: ListTile(
                    title: Text("导入/导出"),
                    leading: Icon(Icons.import_export),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => CsvImportExportPage(),
                      ));
                    },
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15),
                ),
              ],
            ),
          )
        ],
      ),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
    );
  }
}
