import 'dart:io';

import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/ui/after_post_frame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:provider/provider.dart';

import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/password/widget/select_app_dialog.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/encrypt/encrypt_util.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:allpass/util/theme_util.dart';
import 'package:allpass/util/device_apps_holder.dart';
import 'package:allpass/common/page/detail_text_page.dart';
import 'package:allpass/common/widget/label_chip.dart';
import 'package:allpass/setting/category/widget/add_category_dialog.dart';
import 'package:allpass/common/widget/password_generation_dialog.dart';
import 'package:allpass/common/widget/none_border_circular_textfield.dart';

/// 查看或编辑密码页面
class EditPasswordPage extends StatefulWidget {

  final PasswordBean? data;

  final int operation;

  EditPasswordPage(this.data, this.operation);

  @override
  _EditPasswordPage createState() {
    return _EditPasswordPage();
  }
}

class _EditPasswordPage extends State<EditPasswordPage> with AfterFirstFrameMixin {

  String get pageTitle => (operation == DataOperation.add)
      ? context.l10n.createPassword
      : context.l10n.updatePassword;

  PasswordBean? editingData;

  int operation = DataOperation.add;

  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController notesController;
  late TextEditingController urlController;
  List<String> labels = [];
  String folder = "默认";
  String? appName;
  String? appId;
  int fav = 0;
  late String createTime;

  bool _passwordVisible = false;


  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    notesController.dispose();
    urlController.dispose();
  }


  @override
  void initState() {
    super.initState();
    operation = widget.operation;
    if (operation == DataOperation.update) {
      editingData = widget.data;
      var editingPassword = editingData!;
      folder = editingPassword.folder;
      labels.addAll(editingPassword.label);
      fav = editingPassword.fav;
      createTime = editingPassword.createTime;
      appName = editingPassword.appName;
      appId = editingPassword.appId;

      nameController = TextEditingController(text: editingPassword.name);
      usernameController = TextEditingController(text: editingPassword.username);
      notesController = TextEditingController(text: editingPassword.notes);
      urlController = TextEditingController(text: editingPassword.url);
      passwordController = TextEditingController(text: EncryptUtil.decrypt(editingPassword.password));
    } else {
      nameController = TextEditingController();
      usernameController = TextEditingController();
      notesController = TextEditingController();
      urlController = TextEditingController();
      passwordController = TextEditingController();

      createTime = DateTime.now().toIso8601String();
    }
  }

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    PasswordProvider provider = context.watch<PasswordProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitle,
          style: AllpassTextUI.titleBarStyle,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.code),
            onPressed: () {
              showDialog(
                context: context,
                builder: (cx) => PasswordGenerationDialog(),
              ).then((value) {
                if (value != null) passwordController.text = value;
              });
            },
          ),
          IconButton(
            icon: fav == 1
                ? Icon(Icons.favorite, color: Colors.redAccent,)
                : Icon(Icons.favorite_border),
            onPressed: () {
              setState(() {
                fav = fav == 1 ? 0 : 1;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.check,),
            onPressed: () async {
              if (usernameController.text.length >= 1
                  && passwordController.text.length >= 1
                  && nameController.text.length >= 1) {
                String pw = EncryptUtil.encrypt(passwordController.text);
                String name = nameController.text.trimLeft();
                PasswordBean tempData = PasswordBean(
                  key: editingData?.uniqueKey,
                  username: usernameController.text,
                  password: pw,
                  url: urlController.text,
                  name: name,
                  folder: folder,
                  label: labels,
                  notes: notesController.text,
                  fav: fav,
                  color: editingData?.color,
                  createTime: createTime,
                  appId: appId,
                  appName: appName
                );
                if (operation == DataOperation.add) {
                  provider.insertPassword(tempData);
                  ToastUtil.show(msg: l10n.createSuccess);
                } else {
                  provider.updatePassword(tempData);
                  ToastUtil.show(msg: l10n.updateSuccess);
                }
                Navigator.pop(context);
              } else {
                ToastUtil.showError(msg: l10n.upsertPasswordRule);
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _createContent(context, provider),
        ),
      ),
    );
  }

  List<Widget> _createContent(BuildContext context, PasswordProvider provider) {
    Color mainColor = Theme.of(context).primaryColor;
    EdgeInsets marginInset = EdgeInsets.only(left: 30, right: 30, bottom: 20);
    var list = <Widget>[
      _createNameWidget(marginInset, mainColor),
      _createUsernameWidget(marginInset, mainColor, provider),
      _createPasswordWidget(marginInset, mainColor),
      _createUrlWidget(marginInset, mainColor),
      _createFolderWidget(marginInset, mainColor)
    ];
    if (Platform.isAndroid) {
      list.add(_createOwnerAppWidget(marginInset, mainColor));
    }
    list.add(_createLabelWidget(mainColor));
    list.add(_createNoteWidget(marginInset, mainColor));
    return list;
  }

  Widget _createNameWidget(EdgeInsets marginInset, Color mainColor) {
    return Container(
      margin: marginInset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.l10n.name,
            style: TextStyle(fontSize: 16, color: mainColor),
          ),
          NoneBorderCircularTextField(
            editingController: nameController,
            inputType: TextInputType.text,
            trailing: InkWell(
              child: Icon(Icons.cancel, size: 20,),
              onTap: () => afterFirstFrame(() {
                nameController.clear();
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _createUsernameWidget(EdgeInsets marginInset, Color mainColor, PasswordProvider provider) {
    return Container(
      margin: marginInset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.l10n.account,
            style: TextStyle(fontSize: 16, color: mainColor),
          ),
          NoneBorderCircularTextField(
            editingController: usernameController,
            inputType: TextInputType.emailAddress,
            trailing: InkWell(
              child: Icon(
                Icons.cancel,
                size: 20,
              ),
              onTap: () => afterFirstFrame(() {
                usernameController.clear();
              }),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _getMostUsedUsername(provider),
            ),
          )
        ],
      ),
    );
  }

  Widget _createPasswordWidget(EdgeInsets marginInset, Color mainColor) {
    return Container(
      margin: marginInset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.l10n.password,
            style: TextStyle(fontSize: 16, color: mainColor),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: NoneBorderCircularTextField(
                  editingController: passwordController,
                  inputType: TextInputType.visiblePassword,
                  trailing: InkWell(
                    child: Icon(
                        Icons.cancel,
                        size: 20),
                    onTap: () => afterFirstFrame(() {
                      passwordController.clear();
                    }),
                  ),
                  obscureText: !_passwordVisible,
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
    );
  }

  Widget _createUrlWidget(EdgeInsets marginInset, Color mainColor) {
    return Container(
      margin: marginInset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.l10n.url,
            style: TextStyle(fontSize: 16, color: mainColor),
          ),
          NoneBorderCircularTextField(
            editingController: urlController,
            inputType: TextInputType.url,
            trailing: InkWell(
              child: Icon(
                Icons.cancel,
                size: 20,
              ),
              onTap: () => afterFirstFrame(() {
                urlController.clear();
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _createFolderWidget(EdgeInsets marginInset, Color mainColor) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            context.l10n.folderTitle,
            style: TextStyle(fontSize: 16, color: mainColor),
          ),
          DropdownButton(
            onChanged: (newValue) {
              setState(() {
                folder = newValue.toString();
              });
            },
            items: RuntimeData.folderList.map<DropdownMenuItem<String>>((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    color: ThemeUtil.isInDarkTheme(context)
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              );
            }).toList(),
            style: AllpassTextUI.firstTitleStyle,
            elevation: 8,
            iconSize: 30,
            value: folder,
          ),
        ],
      ),
    );
  }

  Widget _createOwnerAppWidget(EdgeInsets marginInset, Color mainColor) {
    return Container(
      margin: marginInset,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            context.l10n.ownerApp,
            style: TextStyle(fontSize: 16, color: mainColor),
          ),
          TextButton(
            child: Text(appId?.isEmpty ?? true ? context.l10n.none : appName!),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (_) => FutureBuilder<List<AppInfo>>(
                  future: DeviceAppsHolder.getInstalledApps(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        return SelectAppDialog(
                          list: (snapshot.data ?? [])..sort((a, b) => a.name.compareTo(b.name)),
                          selectedApp: appId,
                          onSelected: (app) {
                            setState(() {
                              appName = app.name;
                              appId = app.packageName;
                            });
                          },
                          onCancel: () {
                            setState(() {
                              appName = null;
                              appId = null;
                            });
                          },
                        );
                      default:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _createLabelWidget(Color mainColor) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              context.l10n.labels,
              style: TextStyle(fontSize: 16, color: mainColor),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 8.0,
                  runSpacing: 10.0,
                  children: _getTag(),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _createNoteWidget(EdgeInsets marginInset, Color mainColor) {
    return Container(
      margin: marginInset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.l10n.notes,
            style: TextStyle(fontSize: 16, color: mainColor),
          ),
          NoneBorderCircularTextField(
            editingController: notesController,
            readOnly: true,
            maxLines: null,
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(
                builder: (context) => DetailTextPage(context.l10n.notes, notesController.text, (newValue) {
                  setState(() {
                    notesController.text = newValue;
                  });
                }),
              ));
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _getMostUsedUsername(PasswordProvider passwordProvider) {
    List<Widget> usernameChips = [];
    passwordProvider.mostUsedUsername.forEach((element) {
      usernameChips.add(Container(
        padding: EdgeInsets.only(right: 8),
        child: LabelChip(
          text: element,
          selected: false,
          onSelected: (_) {
            usernameController.text = element;
          },
        ),
      ));
    });
    return usernameChips;
  }

  List<Widget> _getTag() {
    List<Widget> labelChoices = [];
    RuntimeData.labelList.forEach((item) {
      labelChoices.add(LabelChip(
        text: item,
        selected: labels.contains(item),
        onSelected: (selected) {
          setState(() => labels.contains(item)
              ? labels.remove(item)
              : labels.add(item));
        },
      ));
    });
    labelChoices.add(
      ChoiceChip(
          label: Icon(Icons.add),
          selected: false,
          onSelected: (_) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AddCategoryDialog(),
            ).then((label) {
              if (label != null && RuntimeData.labelListAdd([label])) {
                setState(() {});
                ToastUtil.show(msg: context.l10n.createLabelSuccess(label));
              } else if (label != null) {
                ToastUtil.show(msg: context.l10n.labelAlreadyExists(label));
              }
            });
          },
      ),
    );
    return labelChoices;
  }
}
