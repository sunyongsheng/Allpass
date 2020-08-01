import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/params/runtime_data.dart';
import 'package:allpass/provider/password_list.dart';
import 'package:allpass/provider/theme_provider.dart';

/// 首字母索引列
class LetterIndexBar extends StatefulWidget {

  final ScrollController scrollController;

  LetterIndexBar(this.scrollController);

  @override
  State createState() {
    return _LetterIndexBar();
  }
}

class _LetterIndexBar extends State<LetterIndexBar> {
  final List<String> letters = ['#','A','B','C','D','E','F','G',
    'H','I','J','K','L','M','N', 'O','P','Q','R','S','T',
    'U','V','W','X','Y','Z'];

  double _tapPositionY = RuntimeData.tapVerticalPosition;
  bool _pressed = false;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.scrollController;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = List();
    Map<String, int> map = Provider.of<PasswordList>(context).letterCountIndex;
    var keys = map.keys;
    letters.forEach((item) {
      _children.add(SizedBox(
        child: Text(item, style: TextStyle(
            color: keys.contains(item) ? null : Colors.grey
        ),),
        height: 16,
      ));
    });
    return Stack(
      children: <Widget>[
        Align(
          alignment: FractionalOffset(1.0, 0),
          child: SizedBox(
            width: 25,
            height: 432,
            child: GestureDetector(
              child: SingleChildScrollView(
                child: Column(
                  children: _children,
                ),
              ),
              onTapDown: (detail) {
                setState(() {
                  _tapPositionY = detail.localPosition.dy;
                  _pressed = true;
                });
                Future.delayed(Duration(milliseconds: 800)).then((_) {
                  setState(() {
                    _pressed = false;
                  });
                });
              },
              onTapUp: (details) {
                setState(() {
                  _tapPositionY = details.localPosition.dy;
                });
                int index = (_tapPositionY / 16).floor();
                if (index >= 26) index = 26;
                if (keys.contains(letters[index])) {
                  double offset = map[letters[index]] * 72.0;
                  if (offset == 0) offset = 0.5;
                  _controller.animateTo(offset, curve: Curves.easeOut, duration: Duration(milliseconds: 200));
                }
              },
              onVerticalDragUpdate: (details) {
                setState(() {
                  _pressed = true;
                  _tapPositionY = details.localPosition.dy;
                });
              },
              onVerticalDragEnd: (_) {
                setState(() {
                  _pressed = false;
                });
                int index = (_tapPositionY / 16).floor();
                if (index >= 26) index = 26;
                if (keys.contains(letters[index])) {
                  double offset = map[letters[index]] * 72.0;
                  if (offset == 0) offset = 0.5;
                  _controller.animateTo(offset, curve: Curves.easeOut, duration: Duration(milliseconds: 200));
                }
              },
            ),
          ),
        ),
        Offstage(
          offstage: !_pressed,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius),
                color: Provider.of<ThemeProvider>(context).offsetColor,
              ),
              width: 60,
              height: 60,
              child: Center(
                child: Text(letters[(_tapPositionY/16).abs().floor() >= 26
                    ? 26
                    : (_tapPositionY/16).abs().floor()],
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}