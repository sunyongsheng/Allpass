import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:allpass/encrypt/encrypt_util.dart';

class PasswordGenerationDialog extends StatefulWidget {

  final Key? key;

  PasswordGenerationDialog({this.key}): super(key: key);

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

  @override
  void initState() {
    _controller.text = EncryptUtil.generateRandomKey(
      _length.floor(),
      cap: _capitalChoose,
      low: _lowerCaseChoose,
      number: _numberChoose,
      sym: _symbolChoose,);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color mainColor = Theme.of(context).primaryColor;
    return AlertDialog(
      title: Text("密码生成器"),
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
                        _capitalChoose = choose ?? true;
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
                        _lowerCaseChoose = choose ?? true;
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
                        _numberChoose = choose ?? true;
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
                        _symbolChoose = choose ?? true;
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
                      _controller.text = EncryptUtil.generateRandomKey(
                        _length.floor(),
                        cap: _capitalChoose,
                        low: _lowerCaseChoose,
                        number: _numberChoose,
                        sym: _symbolChoose,);
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
                  child: Text("复制", style: TextStyle(fontSize: 14)),
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
        TextButton(
          child: Text("确认", style: TextStyle(color: mainColor)),
          onPressed: () {
            Navigator.pop<String>(context, _controller.text);
          },
        ),
        TextButton(
          child: Text("生成", style: TextStyle(color: mainColor)),
          onPressed: () {
            setState(() {
              _controller.text = EncryptUtil.generateRandomKey(
                _length.floor(),
                cap: _capitalChoose,
                low: _lowerCaseChoose,
                number: _numberChoose,
                sym: _symbolChoose,);
            });
          },
        ),
        TextButton(
          child: Text("关闭", style: TextStyle(color: mainColor)),
          onPressed: () => Navigator.pop<String>(context, null),
        )
      ],
    );
  }
}