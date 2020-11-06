import 'package:allpass/classification/widget/classification_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:allpass/core/param/runtime_data.dart';
import 'package:allpass/core/param/allpass_type.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/classification/page/favorite_page.dart';
import 'package:allpass/setting/category/category_manager_page.dart';
import 'package:allpass/classification/page/classification_details_page.dart';

class ClassificationPage extends StatelessWidget {

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: InkWell(
            splashColor: Colors.transparent,
            child: Text(
              "分类",
              style: AllpassTextUI.titleBarStyle,
            ),
            onTap: () {
              _controller.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
            },
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: GridView(
          controller: _controller,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AllpassScreenUtil.setWidth(40),
            crossAxisSpacing: AllpassScreenUtil.setWidth(40),
          ),
          padding: AllpassEdgeInsets.listInset,
          children: getClassWidgets(context),
        )
    );
  }

  List<Widget> getClassWidgets(BuildContext context) {
    List<Widget> list  = List();
    list.add(
        ClassificationItem(
          onPress: () {
            Navigator.push(context, CupertinoPageRoute(
                builder: (context) => FavoritePage()
            ));
          },
          title: "收藏",
        )
    );
    list.addAll(RuntimeData.folderList.map((folder) =>
        ClassificationItem(
          onPress: () {
            Navigator.push(context, CupertinoPageRoute(
              builder: (context) => ClassificationDetailsPage(folder)
            ));
          },
          onLongPress: () => Navigator.push(context, CupertinoPageRoute(
            builder: (context) => CategoryManagerPage(CategoryType.Folder),
          )),
          title: folder,
          color: getRandomColor(seed: folder.hashCode),
        )
    ));
    return list;
  }
}