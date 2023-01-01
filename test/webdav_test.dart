import 'package:allpass/webdav/service/webdav_requester.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WebDavRequester utils = WebDavRequester(
      urlPath: "https://dav.jianguoyun.com/dav/",
      username: "sys6511@126.com",
      password: "aqv9wpw8it9amxiw");
  test("创建文件夹测试", () async {
    await utils.createDir("Allpass");
  });

  test("列出文件测试", () async {
    print(await utils.listFiles("Allpass"));
  });

  test("身份授权测试", () async {
    assert(await utils.authorityCheck());
  });

  test("下载文件", () {
    var path = "D:/Files";
    utils
        .downloadFile(dirName: "Allpass", fileName: "test.txt", savePath: path)
        .then((value) {
      assert(path == value);
    });
  });

  test("是否包含文件", () async {
    await utils.authorityCheck();
  });
}
