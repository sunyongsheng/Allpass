import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/setting/theme/theme_provider.dart';

/// 首字母索引列
class LetterIndexBar extends StatefulWidget {

  final Key? key;
  final ScrollController scrollController;

  LetterIndexBar(this.scrollController, {this.key}) : super(key: key);

  @override
  State createState() {
    return _LetterIndexBar();
  }
}

class _LetterIndexBar extends State<LetterIndexBar> {
  final List<String> letters = ['#','A','B','C','D','E','F','G',
    'H','I','J','K','L','M','N', 'O','P','Q','R','S','T',
    'U','V','W','X','Y','Z'];
  final double letterHeight = 16;

  int _tapPosition = 0;
  double _opacity = 0.0;
  bool _isHidden = true;
  Timer? _hideTimer;

  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.scrollController;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: FractionalOffset(1.0, 0),
          child: SizedBox(
            width: 25,
            height: letterHeight * letters.length,
            child: GestureDetector(
              child: SingleChildScrollView(
                child: Selector<PasswordProvider, Map<String, int>>(
                  selector: (_, provider) => provider.letterCountIndex,
                  builder: (_, letterCountIndex, __) {
                    List<Widget> children = [];
                    var keys = letterCountIndex.keys;
                    letters.forEach((item) {
                      children.add(SizedBox(
                        child: Text(
                          item,
                          style: TextStyle(
                            color: keys.contains(item) ? null : Colors.grey,
                          ),
                        ),
                        height: letterHeight,
                      ));
                    });
                    return Column(
                      children: children,
                    );
                  },
                ),
              ),
              onTapDown: (detail) {
                _hideTimer?.cancel();
                setState(() {
                  _tapPosition = _calculateCurrentPosition(detail.localPosition.dy);
                  _isHidden = false;
                  _opacity = 1;
                });
                _hideTimer = Timer(Duration(milliseconds: 800), () {
                  setState(() {
                    _opacity = 0;
                  });
                });
              },
              onTapUp: (details) {
                setState(() {
                  _tapPosition = _calculateCurrentPosition(details.localPosition.dy);
                  if (_hideTimer == null) {
                    _opacity = 0;
                  }
                });
                _scrollToTargetPosition(_tapPosition);
              },
              onVerticalDragUpdate: (details) {
                _hideTimer?.cancel();
                _hideTimer = null;
                setState(() {
                  _opacity = 1;
                  _isHidden = false;
                  _tapPosition = _calculateCurrentPosition(details.localPosition.dy);
                });
              },
              onVerticalDragEnd: (_) {
                setState(() {
                  _opacity = 0;
                });
                _scrollToTargetPosition(_tapPosition);
              },
            ),
          ),
        ),
        Offstage(
          offstage: _isHidden,
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: Duration(milliseconds: 150),
            onEnd: () {
              if (_opacity == 0) {
                setState(() {
                  _isHidden = true;
                });
              }
            },
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: AllpassUI.smallBorderRadius,
                  color: context.watch<ThemeProvider>().offstageColor,
                ),
                width: 60,
                height: 60,
                child: Center(
                  child: Text(
                    letters[_tapPosition],
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  int _calculateCurrentPosition(double dy) {
    return max(0, min(26, (dy / letterHeight).floor()));
  }

  void _scrollToTargetPosition(int target) {
    var map = context.read<PasswordProvider>().letterCountIndex;
    var keys = map.keys;
    if (keys.contains(letters[target])) {
      double offset = (map[letters[target]] ?? 0) * 72.0;
      if (offset == 0) offset = 0.5;
      _controller.animateTo(offset, curve: Curves.easeOut, duration: Duration(milliseconds: 200));
    }
  }
}