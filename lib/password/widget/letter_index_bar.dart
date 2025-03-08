import 'dart:async';
import 'dart:math';

import 'package:allpass/password/data/letter_index_provider.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:allpass/common/ui/allpass_ui.dart';
import 'package:allpass/setting/theme/theme_provider.dart';

/// 首字母索引列
class LetterIndexBar extends StatefulWidget {
  final ScrollController scrollController;

  LetterIndexBar(this.scrollController, {Key? key}) : super(key: key);

  @override
  State createState() {
    return _LetterIndexBar();
  }
}

class _LetterIndexBar extends State<LetterIndexBar> {
  final double letterHeight = 16;

  int _tapPosition = 0;
  double _opacity = 0.0;
  bool _isHidden = true;
  Timer? _hideTimer;
  int _currentIndex = -1;

  late ScrollController _controller;

  late ScrollController _letterController;

  late VoidCallback _scrollListener;

  @override
  void initState() {
    super.initState();

    _letterController = ScrollController();
    _controller = widget.scrollController;

    _scrollListener = () {
      var letterIndex = _calculateFirstVisibleItemLetterIndex();
      if (letterIndex != _currentIndex) {
        setState(() {
          _currentIndex = letterIndex;
        });
      }
    };

    _currentIndex = _calculateFirstVisibleItemLetterIndex();
    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();

    _letterController.dispose();
    _controller.removeListener(_scrollListener);
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
                controller: _letterController,
                child: Selector<PasswordProvider, Map<String, int>>(
                  selector: (_, provider) => provider.letterIndexMap,
                  builder: (_, letterCountIndexMap, __) {
                    List<Widget> children = [];
                    letters.forEach((item) {
                      var selected = _currentIndex == letters.indexOf(item);
                      var contains = letterCountIndexMap[item] != null;
                      var textColor = selected ? Colors.white : contains ? null : Colors.grey;
                      children.add(Container(
                        width: letterHeight,
                        height: letterHeight,
                        alignment: Alignment.center,
                        child: Text(
                          item,
                          style: TextStyle(color: textColor, fontSize: 12),
                        ),
                        decoration: selected
                            ? BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(4),
                              )
                            : null,
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

  int _calculateFirstVisibleItemLetterIndex() {
    var offset = _controller.offset;
    var itemIndex = offset ~/ 72.0;
    var letterIndex = -1;
    context.read<PasswordProvider>().letterIndexMap.forEach((letter, index) {
      if (itemIndex >= index) {
        letterIndex = letters.indexOf(letter);
        return;
      }
    });
    return letterIndex;
  }

  int _calculateCurrentPosition(double dy) {
    return max(0, min(26, ((dy + _letterController.offset) / letterHeight).floor()));
  }

  void _scrollToTargetPosition(int target) {
    var map = context.read<PasswordProvider>().letterIndexMap;
    var keys = map.keys;
    if (keys.contains(letters[target])) {
      double offset = (map[letters[target]] ?? 0) * 72.0;
      if (offset == 0) offset = 0.5;
      _controller.animateTo(offset, curve: Curves.easeOut, duration: Duration(milliseconds: 200));
    }
  }
}
