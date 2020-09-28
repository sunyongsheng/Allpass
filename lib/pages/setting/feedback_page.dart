import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:allpass/application.dart';
import 'package:allpass/params/param.dart';
import 'package:allpass/model/response_bean.dart';
import 'package:allpass/utils/screen_util.dart';
import 'package:allpass/ui/allpass_ui.dart';
import 'package:allpass/utils/network_util.dart';
import 'package:allpass/widgets/common/none_border_circular_textfield.dart';

class FeedbackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedbackPage();
  }
}

class _FeedbackPage extends State<StatefulWidget> {

  TextEditingController _feedbackController;
  TextEditingController _contactController;
  String _contactCache;

  bool _submitSuccess = false;

  @override
  void initState() {
    super.initState();
    _contactCache = Application.sp.getString(SPKeys.contact)??"";
    _feedbackController = TextEditingController();
    _contactController = TextEditingController(text: _contactCache);
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("意见反馈", style: AllpassTextUI.titleBarStyle,),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: AllpassEdgeInsets.dividerInset,
              height: AllpassScreenUtil.setHeight(500),
              child: NoneBorderCircularTextField(
                editingController: _feedbackController,
                maxLines: 500,
                hintText: "说说你的问题",
              )
            ),
            Padding(
              padding: AllpassEdgeInsets.smallTBPadding,
            ),
            Container(
              padding: AllpassEdgeInsets.dividerInset,
              child: NoneBorderCircularTextField(
                editingController: _contactController,
                hintText: "请输入联系方式（选填）",
              )
            ),
            Padding(
              padding: AllpassEdgeInsets.smallTBPadding,
            ),
            FlatButton(
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius)
              ),
              child: Text("提交", style: TextStyle(color: Colors.white),),
              onPressed: () async {
                if (_feedbackController.text.trim().length < 1) {
                  Fluttertoast.showToast(msg: "请输入反馈内容");
                  return;
                }
                if (_feedbackController.text.length >= 1000) {
                  Fluttertoast.showToast(msg: "反馈内容必须小于1000字！");
                  return;
                }
                showDialog(
                    context: context,
                    child: FutureBuilder(
                      future: submitFeedback(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            return Center();
                          default:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        }
                      },
                    )).then((_) {
                      if (_submitSuccess) {
                        Navigator.pop(context);
                      }
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Future<Null> submitFeedback() async {
    Map<String, String> map = Map();
    map['feedbackContent'] = _feedbackController.text;
    map['contact'] = _contactController.text;
    map['allpassVersion'] = Application.version;
    if (_contactController.text.isNotEmpty) {
      Application.sp.setString(SPKeys.contact, _contactController.text);
    }
    DeviceInfoPlugin infoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await infoPlugin.androidInfo;
      map['identification'] = info.androidId;
    } else if (Platform.isIOS) {
      IosDeviceInfo info = await infoPlugin.iosInfo;
      map['identification'] = info.identifierForVendor;
    } else {
      map['identification'] = "unknown";
    }
    ResponseBean data = await NetworkUtil.sendFeedback(map);
    if (data.done) {
      _submitSuccess = true;
    }
    Fluttertoast.showToast(msg: data.msg);
    Navigator.pop(context);
  }

}