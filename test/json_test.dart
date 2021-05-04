import 'package:allpass/core/model/data/base_model.dart';
import 'package:allpass/password/model/password_bean.dart';
import 'package:allpass/core/param/allpass_type.dart';
import 'package:allpass/util/allpass_file_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<BaseModel> testData1 = [PasswordBean(
    key: 1,
    username: "test",
    password: "121321321",
    url: "https://www.aengus.top",
    folder: "默认",
    name: "test1",
    fav: 1,
    notes: "hhhhhh",
    label: ["aaa", "bbb"]
  ), PasswordBean(
        key: 2,
        username: "testtest",
        password: "121321321",
        url: "https://www.aengus.top",
        folder: "默认",
        name: "test1",
        fav: 1,
        notes: "hhhhhh",
        label: []
    )];
  String test1;
  AllpassFileUtil util = AllpassFileUtil();
  test("编码测试", () {
    test1 = util.encodeList(testData1);
    print(test1);
  });

  test("译码测试", () {
    test1 = util.encodeList(testData1);
    print(util.decodeList(test1, AllpassType.password));
  });

  test("文件夹与标签测试", () {
    List<String> folderList = ["aaa", "bbb", "ccc"];
    var labelList = ["AAA", "BBB", 'CCC'];
    test1 = util.encodeFolderAndLabel(folderList, labelList);
    print(test1);
    print(util.decodeFolderAndLabel(test1));
  });
}