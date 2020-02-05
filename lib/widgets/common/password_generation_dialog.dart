import 'dart:math';

import 'package:allpass/utils/allpass_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordGenerationDialog extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _PasswordGenerationDialog();
  }

}

class _PasswordGenerationDialog extends State<StatefulWidget> {

  TextEditingController _controller = TextEditingController();
  bool _capitalChoose = true;
  bool _lowerCaseChoose = true;
  bool _numberChoose = true;
  bool _symbolChoose = true;
  double _length = 12;
  
  List<String> _capitalList = List()..addAll(['D', 'E', 'F', 'G',
    'H', 'I', 'J', 'O', 'K', 'L', 'M', 'A', 'B', 'C', 'X', 'Y', 'N',
    'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'Z']);
  
  List<String> _lowCaseList = List()..addAll(['a', 'v', 'w', 'f', 'g','x', 'm',
    'h', 'i', 'k', 'l', 'n', 'b', 'c', 'd', 'e', 'o', 'p', 'r', 'j',  's', 't', 'u',
    'y', 'q', 'z']);
  List<String> _numberList = List()..addAll(['1', '9', '0', '2', '5', '6', '3', '4', '7', '8']);

  List<String> _symbolList = List()..addAll(['!', '@', '*', '?', '#', '%', '~', '=']);


  @override
  void initState() {
    _controller.text = generation(_capitalChoose,
        _lowerCaseChoose, _numberChoose, _symbolChoose, _length.floor());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("密码生成器"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            InkWell(
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: _capitalChoose,
                    onChanged: (choose) {
                      setState(() {
                        _capitalChoose = choose;
                      });
                    },
                  ),
                  Text("A-Z"),
                ],
              ),
              onTap: () {
                setState(() {
                  _capitalChoose = !_capitalChoose;
                });
              },
            ),
            InkWell(
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: _lowerCaseChoose,
                    onChanged: (choose) {
                      setState(() {
                        _lowerCaseChoose = choose;
                      });
                    },
                  ),
                  Text("a-z"),
                ],
              ),
              onTap: () {
                setState(() {
                  _lowerCaseChoose = !_lowerCaseChoose;
                });
              },
            ),
            InkWell(
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: _numberChoose,
                    onChanged: (choose) {
                      setState(() {
                        _numberChoose = choose;
                      });
                    },
                  ),
                  Text("0-9"),
                ],
              ),
              onTap: () {
                setState(() {
                  _numberChoose = !_numberChoose;
                });
              },
            ),
            InkWell(
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: _symbolChoose,
                    onChanged: (choose) {
                      setState(() {
                        _symbolChoose = choose;
                      });
                    },
                  ),
                  Text("特殊符号"),
                ],
              ),
              onTap: () {
                setState(() {
                  _symbolChoose = !_symbolChoose;
                });
              },
            ),
            Row(
              children: <Widget>[
                Text('4'),
                Slider(
                  min: 4,
                  max: 20,
                  divisions: 16,
                  value: _length,
                  label: _length.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      _length = value;
                      _controller.text = generation(_capitalChoose,
                          _lowerCaseChoose, _numberChoose,
                          _symbolChoose, _length.floor());
                    });
                  },
                ),
                Text('20')
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(controller: _controller,),
                ),
                InkWell(
                  child: Text("复制", style: AllpassTextUI.secondTitleStyleBlue,),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: _controller.text));
                  },
                )
              ],
            )
          ],
        )
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("确认"),
          onPressed: () {
            Navigator.pop<String>(context, _controller.text);
          },
        ),
        FlatButton(
          child: Text("生成"),
          onPressed: () {
            setState(() {
              _controller.text = generation(_capitalChoose,
                  _lowerCaseChoose, _numberChoose,
                  _symbolChoose, _length.floor());
            });
          },
        ),
        FlatButton(
          child: Text("关闭"),
          onPressed: () => Navigator.pop<String>(context, null),
        )
      ],
    );
  }
  
  String generation(bool cap, bool low, bool number, bool sym, int len) {
    List<String> list = List();
      if (cap && low && number && sym) {
        list..addAll(_lowCaseList);
        list..addAll(_capitalList);
        list..addAll(_symbolList);
        list..addAll(_numberList);
      } else if (cap && low && number && !sym) {
        list..addAll(_numberList);
        list..addAll(_capitalList);
        list..addAll(_lowCaseList);
      } else if (cap && low && !number && sym) {
        list..addAll(_capitalList);
        list..addAll(_symbolList);
        list..addAll(_lowCaseList);
      } else if (cap && !low && number && sym) {
        list..addAll(_numberList);
        list..addAll(_capitalList);
        list..addAll(_symbolList);
      } else if (!cap && low && number && sym) {
        list..addAll(_symbolList);
        list..addAll(_lowCaseList);
        list..addAll(_numberList);
      } else if (cap && low && !number && !sym) {
        list..addAll(_capitalList);
        list..addAll(_lowCaseList);
      } else if (cap && !low && number && !sym) {
        list..addAll(_numberList);
        list..addAll(_capitalList);
      } else if (cap && !low && !number && sym) {
        list..addAll(_symbolList);
        list..addAll(_capitalList);
      } else if (!cap && low && number && !sym) {
        list..addAll(_lowCaseList);
        list..addAll(_numberList);
      } else if (!cap && low && !number && sym) {
        list..addAll(_lowCaseList);
        list..addAll(_symbolList);
      } else if (!cap && !low && number && sym) {
        list..addAll(_numberList);
        list..addAll(_symbolList);
      } else if (cap && !low && !number && !sym) {
        list = _capitalList;
      } else if (!cap && low && !number && !sym) {
        list = _lowCaseList;
      } else if (!cap && !low && number && !sym) {
        list = _numberList;
      } else if (!cap && !low && !number && sym) {
        list = _symbolList;
      }
      StringBuffer stringBuffer = StringBuffer();
      Random random = Random(DateTime.now().hashCode - (list.length + len).hashCode);
      for (int i = 0; i < len; i++) {
        int index = random.nextInt(list.length);
        stringBuffer.write(list[index]);
      }
      return stringBuffer.toString();
  }
}