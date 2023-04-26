import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 跳转其他页面的FloatingActionButton
class MaterialRouteFloatingActionButton extends StatelessWidget {
  final WidgetBuilder builder;
  final Widget child;
  final String? tooltip;
  final Object heroTag;

  const MaterialRouteFloatingActionButton({
    Key? key,
    required this.builder,
    required this.child,
    this.tooltip,
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return FloatingActionButton(
        child: IconTheme(
          data: IconThemeData(color: Colors.white),
          child: child,
        ),
        tooltip: tooltip,
        onPressed: () => Navigator.push(
          context,
          CupertinoPageRoute(
            builder: builder,
          ),
        ),
        heroTag: heroTag,
      );
    } else {
      Color mainColor = Theme.of(context).primaryColor;
      var circleFabBorder = CircleBorder();
      return OpenContainer(
        closedBuilder: (context, openContainer) {
          return Tooltip(
            message: tooltip,
            child: InkWell(
              customBorder: circleFabBorder,
              onTap: () => openContainer(),
              child: SizedBox(
                height: 56,
                width: 56,
                child: Center(
                  child: IconTheme(
                    data: IconThemeData(color: Colors.white),
                    child: child,
                  ),
                ),
              ),
            ),
          );
        },
        openColor: mainColor,
        closedColor: mainColor,
        closedElevation: 6,
        closedShape: CircleBorder(),
        openBuilder: (context, closedContainer) => builder(context),
      );
    }
  }
}
