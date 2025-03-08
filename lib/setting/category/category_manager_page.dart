import 'package:allpass/card/data/card_provider.dart';
import 'package:allpass/classification/category_provider.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/common/widget/bottom_sheet.dart';
import 'package:allpass/common/widget/confirm_dialog.dart';
import 'package:allpass/core/enums/category_type.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/setting/category/widget/add_category_dialog.dart';
import 'package:allpass/setting/category/widget/edit_category_dialog.dart';
import 'package:allpass/setting/theme/theme_provider.dart';
import 'package:allpass/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 属性管理页
/// 通过指定[type]来指定属性页的名称，属性页中是[ListView]
/// 点击每一个[ListTile]弹出模态菜单，菜单中有编辑与删除选项
class CategoryManagerPage extends StatefulWidget {

  final CategoryType type;

  CategoryManagerPage(this.type);

  @override
  State<StatefulWidget> createState() {
    return _CategoryManagerPage();
  }
}

class _CategoryManagerPage extends State<CategoryManagerPage> {

  late CategoryType type;

  @override
  void initState() {
    super.initState();
    this.type = widget.type;
  }

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    var categoryName = type.titles(context);
    return Selector<CategoryProvider, List<String>>(
      builder: (context, value, child) {
        var provider = context.watch<CategoryProvider>();
        return Scaffold(
          appBar: child as AppBar,
          backgroundColor: context.watch<ThemeProvider>().specialBackgroundColor,
          body: Column(
            children: <Widget>[
              Padding(padding: AllpassEdgeInsets.smallTopInsets),
              Expanded(
                child: ReorderableListView(
                  children: _getAllWidget(context, categoryName, provider, value),
                  onReorder: (int oldIndex, int newIndex) {
                    switch (this.type) {
                      case CategoryType.folder:
                        provider.reorderFolder(oldIndex, newIndex);
                        break;
                      case CategoryType.label:
                        provider.reorderLabel(oldIndex, newIndex);
                        break;
                    }
                  },
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: "add$categoryName",
            child: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AddCategoryDialog(type: this.type),
              ).then((value) async {
                if (value != null) {
                  if (this.type == CategoryType.folder && await provider.addFolder([value])) {
                    ToastUtil.show(
                      msg: l10n.createCategorySuccess(categoryName, value),
                    );
                  } else if (this.type == CategoryType.label && await provider.addLabel([value])) {
                    ToastUtil.show(
                      msg: l10n.createCategorySuccess(categoryName, value),
                    );
                  } else {
                    ToastUtil.show(
                      msg: l10n.categoryAlreadyExists(categoryName, value),
                    );
                  }
                }
              });
            },
          ),
        );
      },
      selector: (context, provider) {
        switch (type) {
          case CategoryType.folder:
            return provider.folderList;
          case CategoryType.label:
            return provider.labelList;
        }
      },
      child: AppBar(
        title: Text(
          l10n.categoryManagement(categoryName),
          style: AllpassTextUI.titleBarStyle,
        ),
        centerTitle: true,
      ),
    );
  }

  List<Widget> _getAllWidget(
    BuildContext context,
    String categoryName,
    CategoryProvider provider,
    List<String> data,
  ) {
    var l10n = context.l10n;
    List<Widget> widgets = [];
    for (int currIndex = 0; currIndex < data.length; currIndex++) {
      String currCategoryName = data[currIndex];
      widgets.add(
        // TODO 增加trailing属性显示有多少个密码账号含有此标签
        Card(
          key: ValueKey(data[currIndex]),
          child: ListTile(
            title: Text(
              currCategoryName,
              overflow: TextOverflow.ellipsis,
            ),
            leading: Icon(
              Icons.list,
              color: Colors.grey,
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return BaseBottomSheet(
                    builder: (context) {
                      return [
                        ListTile(
                          title: Text(l10n.updateCategory(categoryName)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 24),
                          leading: Icon(
                            Icons.edit_attributes,
                            color: Colors.blue,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => EditCategoryDialog(
                                widget.type,
                                data[currIndex],
                              ),
                            ).then((value) async {
                              if (value != null) {
                                switch (this.type) {
                                  case CategoryType.folder:
                                    if (provider.isFolderDuplicated(value)) {
                                      ToastUtil.showError(
                                        msg: l10n.categoryAlreadyExists(categoryName, value),
                                      );
                                      return;
                                    }
                                    await editFolderAndUpdate(provider, currIndex, value);
                                    break;

                                  case CategoryType.label:
                                    if (provider.isLabelDuplicated(value)) {
                                      ToastUtil.showError(
                                          msg: l10n.categoryAlreadyExists(categoryName, value),
                                      );
                                      return;
                                    }
                                    await editLabelAndUpdate(provider, currIndex, value);
                                    break;
                                }
                                ToastUtil.show(
                                  msg: l10n.updateCategorySuccess(categoryName, value),
                                );
                              }
                            });
                          },
                        ),
                        ListTile(
                          title: Text(l10n.deleteCategory(categoryName)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 24),
                          leading: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onTap: () async {
                            String hintText = "";
                            Future<Null> Function()? deleteCallback;
                            switch (this.type) {
                              case CategoryType.folder:
                                hintText = l10n.deleteFolderWarning;
                                deleteCallback = () async {
                                  if (await deleteFolderAndUpdate(provider, currCategoryName)) {
                                    ToastUtil.show(msg: l10n.deleteSuccess);
                                  }
                                };
                                break;

                              case CategoryType.label:
                                hintText = l10n.deleteLabelWarning;
                                deleteCallback = () async {
                                  if (await deleteLabelAndUpdate(provider, currCategoryName)) {
                                    ToastUtil.show(msg: l10n.deleteSuccess);
                                  }
                                };
                                break;
                            }
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => ConfirmDialog(
                                l10n.confirmDelete,
                                hintText,
                                danger: true,
                                onConfirm: () async {
                                  await deleteCallback?.call();
                                },
                              ),
                            );
                          },
                        ),
                      ];
                    },
                  );
                },
              );
            },
          ),
          margin: AllpassEdgeInsets.settingCardInset,
          elevation: 0,
        ),
      );
    }
    return widgets;
  }

  Future<bool> editLabelAndUpdate(
    CategoryProvider provider,
    int index,
    String newLabel,
  ) async {
    try {
      String oldLabel = provider.labelList[index];

      var passwordProvider = context.read<PasswordProvider>();
      for (var bean in passwordProvider.passwordList) {
        if (bean.label.contains(oldLabel)) {
          bean.label[bean.label.indexOf(oldLabel)] = newLabel;
          await passwordProvider.updatePassword(bean);
        }
      }

      var cardProvider = context.read<CardProvider>();
      for (var bean in cardProvider.cardList) {
        if (bean.label.contains(oldLabel)) {
          bean.label[bean.label.indexOf(oldLabel)] = newLabel;
          await cardProvider.updateCard(bean);
        }
      }

      await provider.updateLabel(index, newLabel);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editFolderAndUpdate(
    CategoryProvider provider,
    int index,
    String newFolder,
  ) async {
    try {
      String oldFolder = provider.folderList[index];

      var passwordProvider = context.read<PasswordProvider>();
      for (var bean in passwordProvider.passwordList) {
        if (bean.folder == oldFolder) {
          bean.folder = newFolder;
          await passwordProvider.updatePassword(bean);
        }
      }

      var cardProvider = context.read<CardProvider>();
      for (var bean in cardProvider.cardList) {
        if (bean.folder == oldFolder) {
          bean.folder = newFolder;
          await cardProvider.updateCard(bean);
        }
      }

      await provider.updateFolder(index, newFolder);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteLabelAndUpdate(
    CategoryProvider provider,
    String label,
  ) async {
    try {
      var passwordProvider = context.read<PasswordProvider>();
      for (var bean in passwordProvider.passwordList) {
        if (bean.label.contains(label)) {
          bean.label.remove(label);
          await passwordProvider.updatePassword(bean);
        }
      }

      var cardProvider = context.read<CardProvider>();
      for (var bean in cardProvider.cardList) {
        if (bean.label.contains(label)) {
          bean.label.remove(label);
          await cardProvider.updateCard(bean);
        }
      }

      await provider.deleteLabel(label);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteFolderAndUpdate(
    CategoryProvider provider,
    String folder,
  ) async {
    try {
      var passwordProvider = context.read<PasswordProvider>();
      for (var bean in passwordProvider.passwordList) {
        if (folder == bean.folder) {
          bean.folder = "";
          await passwordProvider.updatePassword(bean);
        }
      }

      var cardProvider = context.read<CardProvider>();
      for (var bean in cardProvider.cardList) {
        if (folder == bean.folder) {
          bean.folder = "";
          await cardProvider.updateCard(bean);
        }
      }

      await provider.deleteFolder(folder);
      return true;
    } catch (e) {
      return false;
    }
  }

}