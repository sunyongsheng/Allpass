import 'package:allpass/card/data/card_repository.dart';
import 'package:allpass/card/model/card_bean.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';
import 'package:allpass/core/di/di.dart';
import 'package:allpass/core/param/config.dart';
import 'package:allpass/encrypt/encryption.dart';
import 'package:allpass/encrypt/password_generator.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/password/repository/password_repository.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/encrypt/encrypt_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:flutter/material.dart';

class SecretKeyUpgradePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SecretKeyUpgradePage();
  }
}

class _SecretKeyUpgradePage extends State<StatefulWidget> {
  PasswordRepository passwordRepository = inject();
  CardRepository cardRepository = inject();

  TextEditingController controller = TextEditingController();
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
    var l10n = context.l10n;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.secretKeyUpdate,
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
                    l10n.secretKeyUpdateHelp1,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text(
                    l10n.secretKeyUpdateHelp2,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text(
                    l10n.secretKeyUpdateHelp3,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: l10n.secretKeyUpdateHelp4,
                      ),
                      TextSpan(
                        text: l10n.secretKeyUpdateHelp5,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ]),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text(
                    l10n.secretKeyUpdateHelp6,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text(
                    l10n.secretKeyUpdateHelp7,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text(
                    l10n.secretKeyUpdateHelp8,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text(
                    l10n.secretKeyUpdateHelp9,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: l10n.secretKeyUpdateHelp10,
                        ),
                        TextSpan(
                          text: l10n.secretKeyUpdateHelp11,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: l10n.secretKeyUpdateHelp12,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text(
                    l10n.secretKeyUpdateHelp13,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: AllpassEdgeInsets.smallTBPadding,
                  child: Text(
                    l10n.secretKeyUpdateHelp14,
                    textAlign: TextAlign.center,
                  ),
                ),

                NoneBorderCircularTextField(
                  editingController: controller,
                  textAlign: TextAlign.center,
                  hintText: l10n.secretKeyUpdateHint,
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
                        l10n.generateSecretKey,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        _latestKey = PasswordGenerator.generate(32);
                        if (!haveGen) {
                          ToastUtil.show(msg: l10n.generateSecretKeyDone);
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
                          (states) => haveGen ? primaryColor : Colors.grey,
                        ),
                      ),
                      child: haveUpgrade
                          ? Text(
                              l10n.upgradeDone,
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
                                  l10n.startUpgrade,
                                  style: TextStyle(color: Colors.white),
                                ),
                      onPressed: () async {
                        if (haveUpgrade) {
                          Navigator.pop(context);
                          return;
                        }
                        if (!haveGen) {
                          ToastUtil.show(msg: l10n.pleaseGenerateKeyFirst);
                        } else if (_latestKey?.length != 32) {
                          ToastUtil.show(msg: l10n.secretKeyLengthRequire);
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
    var encryption = Encryption(backupKey);
    List<PasswordBean> passwords = await passwordRepository.findAll();
    List<PasswordBean> passwordsBackup = passwords.map((e) => e.copy()).toList();
    List<CardBean> cards = await cardRepository.findAll();
    List<CardBean> cardsBackup = cards.map((e) => e.copy()).toList();
    String backup1 = Config.password;
    String? backup2 = Config.webDavPassword;

    await EncryptUtil.initEncryptByKey(_latestKey!);
    try {
      Config.setPassword(
          EncryptUtil.encrypt(encryption.decrypt(Config.password)));
      if ((Config.webDavPassword?.isNotEmpty ?? false)) {
        Config.setWebDavPassword(
            EncryptUtil.encrypt(encryption.decrypt(Config.webDavPassword!)));
      }
      for (PasswordBean bean in passwords) {
        String password =
            EncryptUtil.encrypt(encryption.decrypt(bean.password));
        bean.password = password;
        passwordRepository.updateById(bean);
      }
      for (CardBean bean in cards) {
        var password = EncryptUtil.encrypt(encryption.decrypt(bean.password));
        bean.password = password;
        cardRepository.updateById(bean);
      }
      ToastUtil.show(msg: context.l10n.secretKeyUpgradeResult(passwords.length, cards.length));
      return true;
    } catch (e) {
      await EncryptUtil.initEncryptByKey(backupKey);
      Config.setPassword(backup1);
      Config.setWebDavPassword(backup2);
      for (PasswordBean bean in passwordsBackup) {
        var password = EncryptUtil.encrypt(encryption.decrypt(bean.password));
        bean.password = password;
        passwordRepository.updateById(bean);
      }
      for (CardBean bean in cardsBackup) {
        var password = EncryptUtil.encrypt(encryption.decrypt(bean.password));
        bean.password = password;
        cardRepository.updateById(bean);
      }
      ToastUtil.show(msg: context.l10n.secretKeyUpgradeFailed(e));
      return false;
    }
  }
}
