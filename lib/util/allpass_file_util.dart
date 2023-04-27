import 'dart:io';

import 'package:allpass/util/string_util.dart';
import 'package:path_provider/path_provider.dart';

class AllpassFileUtil {
  /// 读取路径为[filePath]的文件内容
  /// 若文件不存在则抛出异常
  /// 先进行格式检查，若格式正确则返回文件内容，否则抛出异常
  static String readFile(String filePath) {
    File file = File(filePath);
    if (!file.existsSync()) {
      throw FileSystemException("文件不存在！", filePath);
    }
    return file.readAsStringSync();
  }

  static Future<String> writeFile(
    String dirname,
    String filename,
    String content,
  ) async {
    String appDirPath =
        (await getApplicationDocumentsDirectory()).uri.toFilePath();
    String dirPath = StringUtil.ensureEndsWith(appDirPath, "/") + dirname;
    String filePath = StringUtil.ensureEndsWith(dirPath, "/") + filename;
    File file = File(filePath);
    if (!await file.exists()) {
      await file.create(recursive: true);
    }

    var result =
        await file.writeAsString(content, mode: FileMode.write, flush: true);
    return result.path;
  }

  /// 删除文件
  static Future<void> deleteFile(String filePath) async {
    File file = File(filePath);
    await file.delete();
  }
}
