import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:device_info/device_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:allpass/params/param.dart';
import 'package:allpass/utils/screen_util.dart';
import 'package:allpass/utils/allpass_ui.dart';

class FeedbackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedbackPage();
  }
}

class _FeedbackPage extends State<StatefulWidget> {

  TextEditingController _feedbackController;
  TextEditingController _contactController;
  Dio _dio;

  bool _submitSuccess = false;

  @override
  void initState() {
    super.initState();
    _feedbackController = TextEditingController();
    _contactController = TextEditingController();
    _dio = Dio(BaseOptions(connectTimeout: 3000));
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _contactController.dispose();
    _dio.close(force: true);
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
              child: TextField(
                decoration: InputDecoration(
                  hintText: "说说你的问题",
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius),
                  ),
                ),
                maxLines: 1000,
                controller: _feedbackController,
              ),
            ),
            Padding(
              padding: AllpassEdgeInsets.smallTBPadding*2,
            ),
            Container(
              padding: AllpassEdgeInsets.dividerInset,
              height: AllpassScreenUtil.setHeight(120),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "请输入联系方式（选填）",
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AllpassUI.smallBorderRadius),
                  ),
                ),
                maxLines: 1,
                controller: _contactController,
              ),
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
                      if (_submitSuccess) Navigator.pop(context);
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
    DeviceInfoPlugin infoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await infoPlugin.androidInfo;
      map['imei'] = info.androidId;
    } else if (Platform.isIOS) {
      IosDeviceInfo info = await infoPlugin.iosInfo;
      map['imei'] = info.identifierForVendor;
    } else {
      map['imei'] = "unknow";
    }
    try {
      Response res = await _dio.post("$allpassUrl/feedback", data: map);
      if ((res.data['result']??'0') == '1') {
        Fluttertoast.showToast(msg: "感谢你的反馈！");
        _submitSuccess = true;
      }
    } on DioError {
      Fluttertoast.showToast(msg: "提交失败，请检查网络连接或远程服务器错误");
    }
    Navigator.pop(context);
  }

}