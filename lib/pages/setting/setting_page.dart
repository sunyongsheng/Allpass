import 'package:allpass/model/card_bean.dart';
import 'package:allpass/model/password_bean.dart';
import 'package:allpass/utils/csv_helper.dart';
import 'package:flutter/material.dart';

import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/dao/card_dao.dart';
import 'package:allpass/dao/password_dao.dart';
import 'package:allpass/params/params.dart';

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
  PasswordDao pd = PasswordDao();
  CardDao cd = CardDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置", style: AllpassTextUI.mainTitleStyle,),
        centerTitle: true,
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(child:Column(
        children: <Widget>[
          FlatButton(
            onPressed: () {
              pd.deleteTable();
            },
            child: Text("删除Pass表"),
          ),
          FlatButton(
            onPressed: () {
              cd.deleteTable();
            },
            child: Text("删除Card表"),
          ),
          FlatButton(
            onPressed: () {
              Params.paramsInit();
            },
            child: Text("重新初始化参数"),
          ),
          FlatButton(
            onPressed: () {
              Params.labelParamsPersistence();
              Params.folderParamsPersistence();
            },
            child: Text("持久化"),
          ),
          FlatButton(
            onPressed: () async {
              PasswordDao dao = PasswordDao();
              CsvHelper helper = CsvHelper();
              List<PasswordBean> list =  await dao.getAllPasswordBeanList();
              helper.passwordExportCsv(list);
            },
            child: Text("写入Password CSV文件"),
          ),
          FlatButton(
            onPressed: () async {
              CardDao dao = CardDao();
              CsvHelper helper = CsvHelper();
              List<CardBean> list =  await dao.getAllCardBeanList();
              helper.cardExportCsv(list);
            },
            child: Text("Card CSV文件"),
          )
        ],
      ),),
      backgroundColor: AllpassColorUI.mainBackgroundColor,
    );
  }
}