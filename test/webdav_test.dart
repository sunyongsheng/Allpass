import 'package:allpass/util/webdav_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WebDavUtil utils = WebDavUtil(urlPath: "https://dav.jianguoyun.com/dav/", username: "sys6511@126.com", password: "aqv9wpw8it9amxiw");
  test("创建文件夹测试", () async {
    await utils.createDir("Allpass");
  });

  test("列出文件测试", () async {
    print(await utils.listFilenames("Allpass"));
  });

  test("身份授权测试", () async {
    assert(await utils.authConfirm());
  });

  test("下载文件", () async {
    String? path = await utils.downloadFile(dirName: "Allpass", fileName: "test.txt", savePath: "D:/Files");
    assert(path != null);
  });

  test("是否包含文件", () async {
    await utils.authConfirm();
    assert(await utils.containsFile(fileName: "Allpass"));
    assert(!(await utils.containsFile(dirName: "Allpass", fileName: "none")));
    assert(await utils.containsFile(dirName: "Allpass", fileName: "allpass_card.json"));
  });
}