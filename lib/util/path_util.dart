import 'package:allpass/util/string_util.dart';

class PathUtil {
  PathUtil._();

  static const String separator = "/";

  static String formatRelativePath(String path) {
    return StringUtil.ensureNotEndsWith(StringUtil.ensureStartWith(path, separator), separator);
  }
}