import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:allpass/utils/encrypt_util.dart';
import 'package:allpass/dao/card_dao.dart';
import 'package:allpass/dao/password_dao.dart';
import 'package:allpass/model/card_bean.dart';
import 'package:allpass/model/password_bean.dart';
import 'package:allpass/params/config.dart';
import 'package:allpass/provider/card_list.dart';
import 'package:allpass/provider/password_list.dart';
import 'package:allpass/provider/theme_provider.dart';
import 'package:allpass/ui/allpass_ui.dart';

class SecretKeyUpgradePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SecretKeyUpgradePage();
  }
}

class _SecretKeyUpgradePage extends State<StatefulWidget> {

  PasswordDao passwordDao = PasswordDao();
  CardDao cardDao = CardDao();
  EncryptHolder encryptHolder;


  TextEditingController controller = TextEditingController(text: "生成后的密钥显示在此");
  bool haveGen = false;
  bool inUpgrade = false;
  bool haveUpgrade = false;
  String _latestKey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "加密密钥更新",
            style: AllpassTextUI.titleBarStyle,
          ),
          centerTitle: true,
        ),
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
                  child: Text("升级所需时间较短，因手机而异", textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text("升级过程中请不要退出程序，否则可能造成数据丢失！", textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text("如果您使用过Allpass进行WebDAV备份，那么密钥更新后旧的备份文件无法再使用！（本机数据不受影响）", textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text("为了安全保证，仍建议在升级前通过“导出为csv”的方式进行备份！", textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text("请点击下面的按钮开始更新", textAlign: TextAlign.center,),
                ),
                Padding(padding: AllpassEdgeInsets.smallTBPadding,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      color: Provider.of<ThemeProvider>(context).lightTheme.primaryColor,
                      child: haveGen
                          ? Text("重新生成", style: TextStyle(color: Colors.white))
                          : Text("点击生成", style: TextStyle(color: Colors.white),),
                      onPressed: () async {
                        _latestKey = EncryptUtil.generateRandomKey(32);
                        setState(() {
                          haveGen = true;
                          controller.text = _latestKey;
                        });
                      },
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                    FlatButton(
                      color: haveGen
                          ? Provider.of<ThemeProvider>(context).lightTheme.primaryColor
                          : Colors.grey,
                      child: haveUpgrade
                          ? Text("升级完成", style: TextStyle(color: Colors.white),)
                          : inUpgrade ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 2.3,
                        ),)
                          : Text("开始升级", style: TextStyle(color: Colors.white),),
                      onPressed: () async {
                        if (haveUpgrade) {
                          Navigator.pop(context);
                          return;
                        }
                        if (!haveGen) {
                          Fluttertoast.showToast(msg: "请先生成密钥");
                        } else {
                          setState(() {
                            inUpgrade = true;
                          });
                          await updateData();
                          setState(() {
                            haveUpgrade = true;
                            inUpgrade = false;
                          });
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

  Future<bool> updateData() async {
    encryptHolder = EncryptHolder(await EncryptUtil.getStoreKey());
    await EncryptUtil.initEncryptByKey(_latestKey);
    List<PasswordBean> passwords = await passwordDao.getAllPasswordBeanList() ?? [];
    List<PasswordBean> passwordsBackup = List();
    passwordsBackup.addAll(passwords);
    List<CardBean> cards = await cardDao.getAllCardBeanList() ?? [];
    List<CardBean> cardsBackup = List();
    cardsBackup.addAll(cards);
    String backup1 = Config.password;
    String backup2 = Config.webDavPassword;
    try {
      Config.setPassword(EncryptUtil.encrypt(encryptHolder.decrypt(Config.password)));
      if (Config.webDavPassword.length > 6) {
        Config.setWebDavPassword(EncryptUtil.encrypt(encryptHolder.decrypt(Config.webDavPassword)));
      }
      for (PasswordBean bean in passwords) {
        String password = EncryptUtil.encrypt(encryptHolder.decrypt(bean.password));
        bean.password = password;
        passwordDao.updatePasswordBeanById(bean);
      }
      for (CardBean bean in cards) {
        String password = EncryptUtil.encrypt(encryptHolder.decrypt(bean.password));
        bean.password = password;
        cardDao.updateCardBeanById(bean);
      }
      await Provider.of<PasswordList>(context).refresh();
      await Provider.of<CardList>(context).refresh();
      Fluttertoast.showToast(msg: "升级了${passwords.length}条密码和${cards.length}个卡片");
      return true;
    } catch (e) {
      Config.setPassword(backup1);
      Config.setWebDavPassword(backup2);
      for (PasswordBean bean in passwordsBackup) {
        String password = EncryptUtil.encrypt(encryptHolder.decrypt(bean.password));
        bean.password = password;
        passwordDao.updatePasswordBeanById(bean);
      }
      for (CardBean bean in cardsBackup) {
        String password = EncryptUtil.encrypt(encryptHolder.decrypt(bean.password));
        bean.password = password;
        cardDao.updateCardBeanById(bean);
      }
      await Provider.of<PasswordList>(context).refresh();
      await Provider.of<CardList>(context).refresh();
      Fluttertoast.showToast(msg: "升级失败：$e");
      return false;
    }
  }
}