import 'package:allpass/classification/category_provider.dart';
import 'package:allpass/l10n/l10n_support.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:allpass/core/enums/category_type.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/util/screen_util.dart';
import 'package:allpass/classification/page/favorite_page.dart';
import 'package:allpass/setting/category/category_manager_page.dart';
import 'package:allpass/classification/page/classification_details_page.dart';
import 'package:allpass/classification/widget/classification_item.dart';
import 'package:provider/provider.dart';

class ClassificationPage extends StatelessWidget {

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    return Scaffold(
        appBar: AppBar(
          title: InkWell(
            splashColor: Colors.transparent,
            child: Text(
              l10n.folderTitle,
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
    List<Widget> list = [];
    list.add(
        ClassificationItem(
          onPress: () {
            Navigator.push(context, CupertinoPageRoute(
                builder: (context) => FavoritePage()
            ));
          },
          title: context.l10n.fav,
        )
    );
    list.addAll(context.watch<CategoryProvider>().folderList.map((folder) =>
        ClassificationItem(
          onPress: () {
            Navigator.push(context, CupertinoPageRoute(
              builder: (context) => ClassificationDetailsPage(folder)
            ));
          },
          onLongPress: () => Navigator.push(context, CupertinoPageRoute(
            builder: (context) => CategoryManagerPage(CategoryType.folder),
          )),
          title: folder,
          color: getRandomColor(seed: folder.hashCode),
        )
    ));
    return list;
  }
}