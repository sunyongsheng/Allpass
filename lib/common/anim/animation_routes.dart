import 'package:flutter/material.dart';

class ExtendRoute extends PageRouteBuilder {
  final Widget page;
  final double tapPosition;
  ExtendRoute({required this.page, required this.tapPosition}): super(
    pageBuilder: (_, __, ___) {
      return page;
    },
    transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
      return Align(
        child: SizeTransition(
          sizeFactor: animation,
          child: child,
        ),
        alignment: Alignment(
            0, tapPosition
        ),
      );
    },
  );
}