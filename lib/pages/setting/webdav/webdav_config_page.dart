import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:allpass/application.dart';
import 'package:allpass/params/config.dart';
import 'package:allpass/provider/theme_provider.dart';
import 'package:allpass/utils/encrypt_util.dart';
import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/utils/webdav_util.dart';
import 'package:allpass/services/webdav_sync_service.dart';
import 'package:allpass/pages/setting/webdav/webdav_sync_page.dart';


class WebDavConfigPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebDavConfigPage();
  }
}

class _WebDavConfigPage extends State<StatefulWidget> {
  TextEditingController _urlController;
  TextEditingController _usernameController;
  TextEditingController _passwordController;
  TextEditingController _portController;
  WebDavUtil _utils;

  Color _mainColor;
  bool _pressNext;
  bool _passwordVisible;

  @override
  void initState() {
    _urlController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _portController = TextEditingController();
    _passwordVisible = false;
    _pressNext = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _mainColor = Provider.of<ThemeProvider>(context).currTheme.primaryColor;
      });
    });
    _utils = WebDavUtil();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _urlController?.dispose();
    _usernameController?.dispose();
    _passwordController?.dispose();
    _portController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "账号配置",
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 40, right: 40, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "WebDAV服务器地址",
                    style: TextStyle(fontSize: 16, color: _mainColor),
                  ),
                  TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                        suffix: InkWell(
                          child: Icon(
                            Icons.cancel,
                            size: 20,
                            color: Colors.black26,
                          ),
                          onTap: () {
                            // 保证在组件build的第一帧时才去触发取消清空内容，防止报错
                            WidgetsBinding.instance.addPostFrameCallback((_) => _urlController.clear());
                          },
                        )
                    ),
                    onChanged: (_) => _setPortAuto(),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "端口号",
                    style: TextStyle(fontSize: 16, color: _mainColor),
                  ),
                  TextField(
                    controller: _portController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        suffix: InkWell(
                          child: Icon(
                            Icons.cancel,
                            size: 20,
                            color: Colors.black26,
                          ),
                          onTap: () {
                            // 保证在组件build的第一帧时才去触发取消清空内容，防止报错
                            WidgetsBinding.instance.addPostFrameCallback((_) => _portController.clear());
                          },
                        )
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "用户名",
                    style: TextStyle(fontSize: 16, color: _mainColor),
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                        suffix: InkWell(
                          child: Icon(
                            Icons.cancel,
                            size: 20,
                            color: Colors.black26,
                          ),
                          onTap: () {
                            // 保证在组件build的第一帧时才去触发取消清空内容，防止报错
                            WidgetsBinding.instance.addPostFrameCallback((_) => _usernameController.clear());
                          },
                        )
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "密码",
                    style: TextStyle(fontSize: 16, color: _mainColor),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          onSubmitted: (_) async => await _nextStep(),
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                              suffix: InkWell(
                                child: Icon(
                                  Icons.cancel,
                                  size: 20,
                                  color: Colors.black26,),
                                onTap: () {
                                  // 保证在组件build的第一帧时才去触发取消清空内容，防止报错
                                  WidgetsBinding.instance.addPostFrameCallback((_) => _passwordController.clear());
                                },
                              )
                          ),
                        ),
                      ),
                      IconButton(
                        icon: _passwordVisible == true
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          this.setState(() {
                            if (_passwordVisible == false)
                              _passwordVisible = true;
                            else
                              _passwordVisible = false;
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  color: _mainColor,
                  child: _pressNext
                      ? LimitedBox(
                    maxHeight: 20,
                    maxWidth: 20,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 2.3,
                    ),
                  )
                      : Text("下一步", style: TextStyle(color: Colors.white)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius),
                  ),
                  onPressed: () async => await _nextStep(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<Null> _nextStep() async {
    setState(() {
      _pressNext = !_pressNext;
    });
    if (_pressNext) {
      try {
        _utils.updateConfig(
          urlPath: _urlController.text,
          username: _usernameController.text,
          password: _passwordController.text,
          port: int.parse(_portController.text),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: "端口号必须为数字！");
        setState(() {
          _pressNext = false;
        });
        return;
      }
      bool auth = await _utils.authConfirm();
      if (auth) {
        Config.setWebDavUrl(_utils.urlPath);
        Config.setWebDavUsername(_utils.username);
        Config.setWebDavPassword(EncryptUtil.encrypt(_utils.password));
        Config.setWebDavPort(_utils.port);
        Config.setWebDavAuthSuccess(true);
        // 注册单例
        Application.getIt.registerSingleton(WebDavSyncService());
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => WebDavSyncPage()));
      } else {
        Config.setWebDavAuthSuccess(false);
        Fluttertoast.showToast(msg: "验证失败，请重试");
      }
      setState(() {
        _pressNext = false;
      });
    } else {
      _utils.cancel();
    }
  }

  void _setPortAuto() {
    if (_urlController.text.startsWith("https://")) {
      _portController.text = "443";
    } else if (_urlController.text.startsWith("http://")){
      _portController.text = "80";
    }
  }

}