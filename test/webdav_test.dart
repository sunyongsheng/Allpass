import 'package:allpass/utils/webdav_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WebDavUtil utils = WebDavUtil(urlPath: "https://dav.jianguoyun.com/dav/", username: "sys6511@126.com", password: "ax7vjv58zyma4ddp");
  test("创建文件夹测试", () async {
    await utils.createDir("Allpass");
  });

  test("列出文件测试", () async {
    await utils.listFiles("Notability");
  });

  test("身份授权测试", () async {
    print((await utils.authConfirm()).toString());
  });
}