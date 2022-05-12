import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:allpass/core/param/config.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/webdav_util.dart';
import 'package:allpass/setting/webdav/webdav_sync_page.dart';
import 'package:allpass/common/widget/information_help_dialog.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';
import 'package:allpass/common/widget/loading_text_button.dart';

class WebDavConfigPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebDavConfigPage();
  }
}

class _WebDavConfigPage extends State<StatefulWidget> {

  late TextEditingController _urlController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _portController;
  late WebDavUtil _utils;

  bool _pressNext = false;
  bool _passwordVisible = false;
  bool _frameDone = false;

  @override
  void initState() {
    _urlController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _portController = TextEditingController();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _frameDone = true;
    });
    _utils = WebDavUtil();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _urlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _portController.dispose();
    _frameDone = false;
  }

  @override
  Widget build(BuildContext context) {
    Color mainColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "账号配置",
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              String example = "https://dav.jianguoyun.com/dav/";
              showDialog(
                context: context,
                builder: (context) => InformationHelpDialog(
                  content: [
                    Text("此功能可以将您的数据备份到 WebDAV 服务器中或者进行数据恢复.\n"),
                    Text("WebDAV 服务器地址请以 http:// 或 https:// 开头，如坚果云(点击复制)：\n"),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: example));
                        ToastUtil.show(msg: "复制成功");
                      },
                      child: Text(example)),
                    Text("\n"),
                    Text("端口号代表服务所在端口，如果您不清楚，请不要编辑.")
                  ],
                )
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30, bottom: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NoneBorderCircularTextField(
                editingController: _urlController,
                hintText: "WebDAV服务器地址",
                onChanged: (_) => _setPortAuto(),
                trailing: InkWell(
                  child: Icon(
                    Icons.cancel,
                    size: 20,
                  ),
                  onTap: () {
                    if (_frameDone) _urlController.clear();
                  },
                ),
              ),
              NoneBorderCircularTextField(
                editingController: _portController,
                hintText: "端口号",
                trailing: InkWell(
                  child: Icon(
                    Icons.cancel,
                    size: 20,
                  ),
                  onTap: () {
                    if (_frameDone) _portController.clear();
                  },
                ),
              ),
              NoneBorderCircularTextField(
                editingController: _usernameController,
                hintText: "账号",
                trailing: InkWell(
                  child: Icon(
                    Icons.cancel,
                    size: 20,
                  ),
                  onTap: () {
                    if (_frameDone) _usernameController.clear();
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: NoneBorderCircularTextField(
                      editingController: _passwordController,
                      hintText: "密码",
                      obscureText: !_passwordVisible,
                      trailing: InkWell(
                        child: Icon(
                          Icons.cancel,
                          size: 20,
                        ),
                        onTap: () {
                          if (_frameDone)_passwordController.clear();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: AllpassEdgeInsets.smallLPadding,
                    child: InkWell(
                      child: _passwordVisible == true
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      onTap: () => showPassword(),
                    ),
                  )

                ],
              ),
              Padding(
                padding: AllpassEdgeInsets.smallTBPadding,
                child: LoadingTextButton(
                  color: mainColor,
                  title: "下一步",
                  loadingTitle: "配置中",
                  loading: _pressNext,
                  onPressed: () async => await _nextStep(),
                ),
              )
            ],
          ),
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
        ToastUtil.showError(msg: "端口号必须为数字！");
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
        ToastUtil.show(msg: "账号验证成功");
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => WebDavSyncPage()));
      } else {
        Config.setWebDavAuthSuccess(false);
        ToastUtil.show(msg: "验证失败，请重试");
      }
      setState(() {
        _pressNext = false;
      });
    } else {
      _utils.cancelConfirmAuth();
    }
  }

  void _setPortAuto() {
    if (_urlController.text.startsWith("https://")) {
      _portController.text = "443";
    } else if (_urlController.text.startsWith("http://")){
      _portController.text = "80";
    }
  }

  void showPassword() {
    setState(() {
      if (_passwordVisible == false)
        _passwordVisible = true;
      else
        _passwordVisible = false;
    });
  }

}