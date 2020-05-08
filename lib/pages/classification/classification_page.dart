import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import 'package:allpass/params/runtime_data.dart';
import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/utils/screen_util.dart';
import 'package:allpass/pages/classification/favorite_page.dart';
import 'package:allpass/pages/classification/classification_details_page.dart';

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
        OpenContainer(
          transitionType: ContainerTransitionType.fadeThrough,
          openShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          closedElevation: 0,
          openBuilder: (context, _) {
            return FavoritePage();
          },
          closedBuilder: (context, _) {
            return Card(
              elevation: 0,
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Center(
                child: Text("收藏",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        )
    );
    list.addAll(RuntimeData.folderList.map((folder) =>
        OpenContainer(
          closedElevation: 0,
          openBuilder: (context, _) {
            return ClassificationDetailsPage(folder);
          },
          transitionType: ContainerTransitionType.fadeThrough,
          openShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          closedBuilder: (context, _) {
            return Card(
              elevation: 0,
              color: getRandomColor(seed: folder.hashCode),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Center(
                child: Text(folder,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        )
    ));
    return list;
  }
}