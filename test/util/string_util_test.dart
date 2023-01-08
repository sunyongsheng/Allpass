import 'package:allpass/util/string_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("StringUtil test", () {
    var text1 = "http://example.com/";
    var text2 = "http://example.com///";
    var text3 = "abcd";
    var start1 = "http";
    var start2 = "http://http://";
    var start3 = "https://";
    var end1 = "/";
    var end2 = "//";
    var end3 = "abcde";
    var end4 = "abcd";

    assert (StringUtil.ensureStartWith(text1, start1) == text1);
    assert (StringUtil.ensureStartWith(text1, start2) == "http://http://http://example.com/");
    assert (StringUtil.ensureStartWith(text1, start3) == "https://http://example.com/");

    assert (StringUtil.ensureNotEndsWith(text1, end1) == "http://example.com");
    assert (StringUtil.ensureNotEndsWith(text2, end1) == "http://example.com");
    assert (StringUtil.ensureNotEndsWith(text1, end2) == "http://example.com/");
    assert (StringUtil.ensureNotEndsWith(text2, end2) == "http://example.com/");
    assert (StringUtil.ensureNotEndsWith(text3, end3) == "abcd");
    assert (StringUtil.ensureNotEndsWith(text3, end4) == "");
  });
}