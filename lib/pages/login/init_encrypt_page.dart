import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:allpass/params/config.dart';
import 'package:allpass/provider/theme_provider.dart';
import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/utils/encrypt_util.dart';
import 'package:allpass/utils/navigation_util.dart';


class InitEncryptPage extends StatefulWidget {

  @override
  State createState() {
    return _InitEncryptPage();
  }
}

class _InitEncryptPage extends State<InitEncryptPage> {

  TextEditingController controller = TextEditingController(text: "生成后的密钥显示在此");
  bool inGen = false;
  bool haveGen = false;
  String _latestKey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: AllpassEdgeInsets.listInset,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text("请仔细阅读", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text("Allpass 2.0.0及以后使用了新的密钥存储方式", textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text("Allpass会对每一个用户生成独一无二的密钥并将其存储到系统特定的区域中", textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text("密码的加密和解密将依赖此密钥，请妥善保管此密钥", textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text("如果您进行了WebDAV同步，即使卸载了Allpass并且备份文件中密码已加密，仍然可以通过密钥找回数据", textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text("如果因为意外原因导致尚未生成密钥便退出了Allpass，Allpass仍然会生成一个默认密钥，但是建议您重新注册"),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text("请点击下面的按钮生成密钥", textAlign: TextAlign.center,),
                ),
                Padding(padding: AllpassEdgeInsets.smallTBPadding,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      color: Provider.of<ThemeProvider>(context).lightTheme.primaryColor,
                      child: haveGen
                          ? Text("重新生成", style: TextStyle(color: Colors.white))
                          : (inGen
                          ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 2.3,
                        ),)
                          : Text("点击生成", style: TextStyle(color: Colors.white),)),
                      onPressed: () async {
                        setState(() {
                          inGen = true;
                        });
                        _latestKey = await EncryptUtil.initEncrypt(needFresh: true);
                        setState(() {
                          haveGen = true;
                          inGen = false;
                          controller.text = _latestKey;
                        });
                      },
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                    FlatButton(
                      color: haveGen
                          ? Provider.of<ThemeProvider>(context).lightTheme.primaryColor
                          : Colors.grey,
                      child: Text("去登录", style: TextStyle(color: Colors.white),),
                      onPressed: () async {
                        if (!haveGen) {
                          Fluttertoast.showToast(msg: "请先生成密钥");
                        } else {
                          EncryptHolder holder = EncryptHolder(EncryptUtil.initialKey);
                          Config.setPassword(EncryptUtil.encrypt(holder.decrypt(Config.password)));
                          NavigationUtil.goLoginPage(context);
                        }
                      },
                    )
                  ],
                ),
                TextField(controller: controller, textAlign: TextAlign.center,)
              ],
            ),
          ),
        )
    );
  }
}