import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:allpass/utils/allpass_ui.dart';
import 'package:allpass/utils/screen_util.dart';
import 'package:allpass/utils/encrypt_util.dart';
import 'package:allpass/model/password_bean.dart';
import 'package:allpass/provider/password_list.dart';

/// 从剪贴板中导入
class ImportFromClipboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImportFromClipboard();
  }
}

class _ImportFromClipboard extends State<ImportFromClipboard> {
  final TextEditingController _controller = TextEditingController();
  int _groupValue = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          title: Text(
            "从剪贴板导入",
            style: AllpassTextUI.titleBarStyle,
          ),
          centerTitle: true,
          backgroundColor: AllpassColorUI.mainBackgroundColor,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.help_outline, color: Colors.black,),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("帮助"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(AllpassUI.smallBorderRadius))
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text("此功能帮助您轻松地从之前在记事本中保存的密码导入到Allpass中；\n"),
                          Text("名称是密码的助记符，您可以随便起一个名称来让您知道此条记录是什么内容；\n"),
                          Text("账号是登录使用的账号名，有可能是手机、邮箱或者其他您设置的账号；\n"),
                          Text("网站地址可以帮助Allpass在正确的网站填充您的密码，大多数情况下是网站登录页的URL地址；\n"),
                          Text("两个字段之间请以“空格”作为分隔符，这样Allpass才能正确分辨哪个是用户名，哪个是密码；\n"),
                          Text("如果选择了最后一个导入格式，请在第一行输入统一的用户名；如果有多个用户名，可以分为几次导入；")
                        ],
                      )
                    ),
                  )
                );
              },
            ),
          ],
        ),
        backgroundColor: AllpassColorUI.mainBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: AllpassEdgeInsets.forCardInset,
                child: Text(
                  "请选择密码格式（空格为分隔符）",
                  style: AllpassTextUI.titleBarStyle,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: AllpassEdgeInsets.forCardInset,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Radio(
                        value: 1, // "名称 账号 密码 网站地址"
                        groupValue: _groupValue,
                        onChanged: (value) {
                          setState(() {
                            _groupValue = value;
                          });
                        },
                      ),
                      title: Text("名称 账号 密码 网站地址"),
                      onTap: () {
                        setState(() {
                          _groupValue = 1;
                        });
                      },
                    ),
                    ListTile(
                      leading: Radio(
                        value: 2, // "名称 账号 密码",
                        groupValue: _groupValue,
                        onChanged: (value) {
                          setState(() {
                            _groupValue = value;
                          });
                        },
                      ),
                      title: Text("名称 账号 密码"),
                      onTap: () {
                        setState(() {
                          _groupValue = 2;
                        });
                      },
                    ),
                    ListTile(
                      leading: Radio(
                        value: 3, // "账号 密码 网站地址",
                        groupValue: _groupValue,
                        onChanged: (value) {
                          setState(() {
                            _groupValue = value;
                          });
                        },
                      ),
                      title: Text("账号 密码 网站地址"),
                      onTap: () {
                        setState(() {
                          _groupValue = 3;
                        });
                      },
                    ),
                    ListTile(
                      leading: Radio(
                        value: 4, // "账号 密码",
                        groupValue: _groupValue,
                        onChanged: (value) {
                          setState(() {
                            _groupValue = value;
                          });
                        },
                      ),
                      title: Text("账号 密码"),
                      onTap: () {
                        setState(() {
                          _groupValue = 4;
                        });
                      },
                    ),
                    ListTile(
                      leading: Radio(
                        value: 5, // "密码",
                        groupValue: _groupValue,
                        onChanged: (value) {
                          setState(() {
                            _groupValue = value;
                          });
                          Fluttertoast.showToast(msg: "请在第一行输入默认用户名");
                        },
                      ),
                      title: Text("名称 密码"),
                      onTap: () {
                        setState(() {
                          _groupValue = 5;
                        });
                        Fluttertoast.showToast(msg: "请在第一行输入默认用户名");
                      },
                    )
                  ],
                ),
              ),
              Container(
                padding: AllpassEdgeInsets.listInset,
                height: AllpassScreenUtil.setHeight(1000),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius),
                    ),
                  ),
                  maxLines: 1000,
                  controller: _controller,
                ),
              ),
              Padding(
                padding: AllpassEdgeInsets.smallTBPadding,
                child: FlatButton(
                  color: AllpassColorUI.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius),
                  ),
                  child: Text(
                    "导入",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    try {
                      List<PasswordBean> list = await parseText(_groupValue);
                      for (var bean in list) {
                        Provider.of<PasswordList>(context).insertPassword(bean);
                      }
                      Fluttertoast.showToast(msg: "导入了${list.length}条记录");
                    } catch (e) {
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }

  Future<List<PasswordBean>> parseText(int value) async {
    String text = _controller.text;
    List<String> tempRows = text.split("\n");
    List<String> rows = [];
    for (String tr in tempRows) {
      if (tr.trim().length <= 1) continue;
      else rows.add(tr);
    }
    List<PasswordBean> temp = [];
    // 下面这种情况需要设置默认用户名
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
        if (fields.length < 2) throw Exception("某条记录格式不正确！");
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
        if (fields.length < 4) throw Exception("某条记录格式不正确！");
        temp.add(PasswordBean(
          name: fields[0],
          username: fields[1],
          password: EncryptUtil.encrypt(fields[2]),
          url: fields[3],
        ));
      } else if (value == 2) {
        if (fields.length < 3) throw Exception("某条记录格式不正确！");
        temp.add(PasswordBean(
          name: fields[0],
          username: fields[1],
          password: EncryptUtil.encrypt(fields[2]),
          url: "",
        ));
      } else if (value == 3) {
        if (fields.length < 3) throw Exception("某条记录格式不正确！");
        temp.add(PasswordBean(
          username: fields[0],
          password: EncryptUtil.encrypt(fields[1]),
          url: fields[2],
        ));
      } else if (value == 4) {
        if (fields.length < 2) throw Exception("某条记录格式不正确！");
        temp.add(PasswordBean(
          username: fields[0],
          password: EncryptUtil.encrypt(fields[1]),
          url: "",
        ));
      }
    }
    return temp;
  }
}
