import 'package:allpass/application.dart';
import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/card/data/card_repository.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/data/password_repository.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/util/encrypt_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecretKeyUpgradePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SecretKeyUpgradePage();
  }
}

class _SecretKeyUpgradePage extends State<StatefulWidget> {
  PasswordRepository passwordRepository = AllpassApplication.getIt.get();
  CardRepository cardRepository = AllpassApplication.getIt.get();
  late EncryptHolder encryptHolder;

  TextEditingController controller = TextEditingController(text: "生成后的密钥显示在此");
  bool haveGen = false;
  bool inUpgrade = false;
  bool haveUpgrade = false;
  String? _latestKey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
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
                  child: Text(
                    "请仔细阅读",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text(
                    "Allpass 1.5.0及以后使用了新的密钥存储方式",
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text(
                    "Allpass会对每一个用户生成独一无二的密钥并将其存储到系统特定的区域中，"
                    "这意味着即使反编译了Allpass并通过某些方法获取到了数据库中的数据，也无法轻易破解",
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: "升级后，所有密码的加密和解密均将依赖生成的新密钥，请",
                      ),
                      TextSpan(
                        text: "妥善保管生成后的新密钥",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ]),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text(
                    "如果您进行了WebDAV同步，即使卸载了Allpass并且备份文件中密码已加密，仍然可以通过密钥找回数据",
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text(
                    "升级所需时间较短，因手机而异",
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text(
                    "升级过程中请不要退出程序，否则可能造成数据丢失！",
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text(
                    "***************** 注意 *****************",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "如果您使用过Allpass进行WebDAV备份，那么密钥更新后旧的备份文件",
                        ),
                        TextSpan(
                          text: "无法",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "再使用！（本机数据不受影响）",
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text(
                    "为了安全保证，仍建议在升级前通过“导出为csv”的方式进行备份！",
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text(
                    "可以直接编辑下面的输入框，手动输入自定义密钥(32位)",
                    textAlign: TextAlign.center,
                  ),
                ),

                NoneBorderCircularTextField(
                  editingController: controller,
                  textAlign: TextAlign.center,
                  onChanged: (s) {
                    _latestKey = s;
                    setState(() {
                      haveGen = s.length == 32;
                    });
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor),
                      ),
                      child: Text(
                        "生成密钥",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        _latestKey = EncryptUtil.generateRandomKey(32);
                        if (!haveGen) {
                          ToastUtil.show(msg: "生成完成，请保管好新密钥（可以长按复制）");
                        }
                        setState(() {
                          haveGen = true;
                          controller.text = _latestKey!;
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => haveGen ? primaryColor : Colors.grey),
                      ),
                      child: haveUpgrade
                          ? Text(
                              "升级完成",
                              style: TextStyle(color: Colors.white),
                            )
                          : inUpgrade
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    strokeWidth: 2.3,
                                  ),
                                )
                              : Text(
                                  "开始升级",
                                  style: TextStyle(color: Colors.white),
                                ),
                      onPressed: () async {
                        if (haveUpgrade) {
                          Navigator.pop(context);
                          return;
                        }
                        if (!haveGen) {
                          ToastUtil.show(msg: "请先生成密钥");
                        } else if (_latestKey?.length != 32) {
                          ToastUtil.show(msg: "密钥长度必须为32位");
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
              ],
            ),
          ),
        ));
  }

  Future<bool> updateData() async {
    String backupKey = (await EncryptUtil.getStoreKey())!;
    encryptHolder = EncryptHolder(backupKey);
    List<PasswordBean> passwords = await passwordRepository.requestAll();
    List<PasswordBean> passwordsBackup = [];
    passwordsBackup.addAll(passwords);
    List<CardBean> cards = await cardRepository.requestAll();
    List<CardBean> cardsBackup = [];
    cardsBackup.addAll(cards);
    String backup1 = Config.password;
    String? backup2 = Config.webDavPassword;

    var passwordProvider = context.read<PasswordProvider>();
    var cardProvider = context.read<CardProvider>();

    await EncryptUtil.initEncryptByKey(_latestKey!);
    try {
      Config.setPassword(
          EncryptUtil.encrypt(encryptHolder.decrypt(Config.password)));
      if ((Config.webDavPassword?.length ?? 0) > 6) {
        Config.setWebDavPassword(
            EncryptUtil.encrypt(encryptHolder.decrypt(Config.webDavPassword!)));
      }
      for (PasswordBean bean in passwords) {
        String password =
            EncryptUtil.encrypt(encryptHolder.decrypt(bean.password));
        bean.password = password;
        passwordRepository.updateById(bean);
      }
      for (CardBean bean in cards) {
        var password = EncryptUtil.encrypt(encryptHolder.decrypt(bean.password));
        bean.password = password;
        cardRepository.updateById(bean);
      }
      await passwordProvider.refresh();
      await cardProvider.refresh();
      ToastUtil.show(msg: "升级了${passwords.length}条密码和${cards.length}个卡片");
      return true;
    } catch (e) {
      await EncryptUtil.initEncryptByKey(backupKey);
      Config.setPassword(backup1);
      Config.setWebDavPassword(backup2);
      for (PasswordBean bean in passwordsBackup) {
        var password = EncryptUtil.encrypt(encryptHolder.decrypt(bean.password));
        bean.password = password;
        passwordRepository.updateById(bean);
      }
      for (CardBean bean in cardsBackup) {
        var password = EncryptUtil.encrypt(encryptHolder.decrypt(bean.password));
        bean.password = password;
        cardRepository.updateById(bean);
      }
      await passwordProvider.refresh();
      await cardProvider.refresh();
      ToastUtil.show(msg: "升级失败：$e");
      return false;
    }
  }
}
