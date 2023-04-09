import 'dart:convert';
import 'dart:io';

import 'package:allpass/application.dart';
import 'package:allpass/core/error/app_error.dart';
import 'package:allpass/util/path_util.dart';
import 'package:allpass/util/string_util.dart';
import 'package:allpass/webdav/model/webdav_file.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

class WebDavRequester {
  final Logger _logger = Logger();

  static const String root = "/";

  late Dio _dio;
  late String _basicAuth;
  late Map<String, dynamic> _baseHeaders;

  late String urlPath;
  late String username;
  late String password;

  bool _authChecked = false;

  CancelToken _authCancelToken = CancelToken();

  Map<String, List<WebDavFile>> _dirFilesCache = Map();

  WebDavRequester(
      {String? urlPath, int? port, String? username, String? password}) {
    _dio = AllpassApplication.getIt.get();

    _baseHeaders = {"Depth": 1};
    this.urlPath = "";
    this.username = "";
    this.password = "";

    updateConfig(
      urlPath: urlPath,
      port: port,
      username: username,
      password: password,
    );
  }

  void updateConfig(
      {String? urlPath, int? port, String? username, String? password}) {
    _authChecked = false;

    // 若端口号比较特殊，则将其设置为 url:port 的形式，否则设置为 url 的形式
    if (urlPath != null) {
      var urlWithoutSuffix = StringUtil.ensureNotEndsWith(urlPath, "/");
      if (port == null || port == 80 || port == 443) {
        this.urlPath = urlWithoutSuffix;
      } else {
        this.urlPath = "$urlWithoutSuffix:$port";
      }
    }

    if (username != null) {
      this.username = username;
    }

    if (password != null) {
      this.password = password;
    }

    var listInt = utf8.encode("${this.username}:${this.password}");
    _basicAuth = base64Encode(listInt);
    _baseHeaders["Authorization"] = "Basic $_basicAuth";
  }

  /// 身份验证
  Future<bool> authorityCheck() async {
    if (_authChecked) {
      return true;
    }

    try {
      Response response = await _dio.request(
        urlPath + root,
        options: Options(
          method: WebDAVMethods.propFind,
          headers: _baseHeaders,
        ),
        cancelToken: _authCancelToken,
      );
      if (_checkResponse(response.statusCode)) {
        List<WebDavFile> fileNames = [];
        obtainResponseNodes(response.data)
            .map((e) => WebDavFile.parse(e))
            .forEach((file) {
          if (file != null) {
            fileNames.add(file);
          }
        });
        if (fileNames.isNotEmpty) {
          _dirFilesCache[root] = fileNames.sublist(1);
        }
        _authChecked = true;
        return true;
      } else if (response.statusCode == 401) return false;
    } on DioError catch (e) {
      _logger.e("authorityCheck data: ${e.response?.data}", e);
    }
    return false;
  }

  /// 创建目录，名为[dirName]
  Future<bool> createDir(String dirName) async {
    try {
      String newPath = urlPath + PathUtil.formatRelativePath(dirName);
      Response response = await _dio.request(
        newPath,
        options: Options(
          method: WebDAVMethods.mkCol,
          headers: _baseHeaders,
        ),
      );
      if (response.statusCode == 201) {
        _dirFilesCache[dirName] = [];
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      _logger.e("createDir error\n${e.response?.data}", e);
    }
    return false;
  }

  /// 列出文件夹[dirName]中的所有文件名，若目录为空返回[null]
  Future<List<WebDavFile>?> listFiles(String dirName) async {
    String fullPath = urlPath + PathUtil.formatRelativePath(dirName);
    Response<String> response = await _dio.request(
      fullPath,
      options: Options(
        method: WebDAVMethods.propFind,
        headers: _baseHeaders,
      ),
    );
    List<WebDavFile> allFiles = [];
    if (_checkResponse(response.statusCode)) {
      var data = response.data;
      if (data == null) return null;
      obtainResponseNodes(data)
          .map((e) => WebDavFile.parse(e))
          .forEach((file) {
        if (file != null) {
          allFiles.add(file);
        }
      });
      // 第一个元素为当前文件夹
      if (allFiles.isNotEmpty) {
        var files = allFiles.sublist(1);
        _dirFilesCache[dirName] = files;
        return files;
      } else {
        return [];
      }
    } else {
      return null;
    }
  }

  Iterable<XmlElement> obtainResponseNodes(String input) {
    var document = XmlDocument.parse(input);
    var dNodes = document.findAllElements("d:response");
    if (dNodes.isEmpty) {
      return document.findAllElements("D:response");
    }
    return dNodes;
  }
  
  Future<bool> exists(String path) async {
    if (_dirFilesCache.containsKey(path)) {
      return true;
    }

    String fullPath = urlPath + PathUtil.formatRelativePath(path);
    try {
      Response<String> response = await _dio.request(
        fullPath,
        options: Options(
          method: WebDAVMethods.propFind,
          headers: _baseHeaders,
        ),
      );
      if (_checkResponse(response.statusCode)) {
        // 由于此函数调用比较频繁，故此处不进行解析
        _dirFilesCache[path] = [];
        return true;
      }
    } on DioError catch (e) {
      _logger.e("exists error\n${e.response?.data}", e);
      return false;
    }
    return false;
  }

  /// [dirName]目录下是否含有[fileName]文件
  Future<bool> containsFile(
      {String dirName = root, required String fileName}) async {
    List<WebDavFile>? allFiles = _dirFilesCache[dirName];
    if (allFiles != null) {
      return allFiles.map((e) => e.filename).contains(fileName);
    } else {
      try {
        return (await listFiles(dirName))
            ?.map((e) => e.filename)
            .contains(fileName) ??
            false;
      } on DioError catch (e) {
        _logger.e("containsFile data: ${e.response?.data}", e, e.stackTrace);
        return false;
      }
    }
  }

  /// 向文件夹[dirName]上传文件。若[dirName]为空，则默认为根目录
  /// Throws [DioError]/[FileSystemException]/[UnknownException]
  Future<String> uploadFile(
      {String dirName = root,
      required String fileName,
      required String localFilePath}) async {
    String uploadPath = _concatPath(dirName, fileName);
    File file = File(localFilePath);
    if (!await file.exists()) {
      throw FileSystemException("上传文件出错！文件不存在！", localFilePath);
    }

    var content = await file.readAsString();
    Response response = await _dio.put(
      uploadPath,
      data: content,
      options: Options(headers: _baseHeaders),
    );
    if (_checkResponse(response.statusCode)) {
      return fileName;
    }

    throw UnknownException(response.statusMessage);
  }

  /// 下载文件夹[dirName]中的文件。若[dirName]为空，则默认为根目录
  ///
  /// 返回保存路径
  /// Throws [DioError]/[UnknownException]
  Future<String> downloadFile(
      {String dirName = root,
      required String fileName,
      String? savePath}) async {
    String downloadUrl = _concatPath(dirName, fileName);
    String _savePath;
    if (savePath == null) {
      Directory appDir = await getApplicationDocumentsDirectory();
      _savePath = appDir.uri.toFilePath() + fileName;
    } else {
      _savePath = savePath;
    }
    Response response = await _dio.download(
      downloadUrl,
      _savePath,
      options: Options(headers: _baseHeaders),
    );
    if (_checkResponse(response.statusCode)) {
      return _savePath;
    }

    throw UnknownException(response.statusMessage);
  }

  void cancelConfirmAuth() {
    _authCancelToken.cancel();
  }

  bool _checkResponse(int? statusCode) {
    return statusCode != null && statusCode < 300;
  }

  String _concatPath(String? dirName, String fileName) {
    if (dirName == null || dirName == root) {
      return this.urlPath + PathUtil.formatRelativePath(fileName);
    } else {
      String validDirname = PathUtil.formatRelativePath(dirName);
      String validFilename = PathUtil.formatRelativePath(fileName);
      return this.urlPath + validDirname + validFilename;
    }
  }
}

class WebDAVMethods {
  WebDAVMethods._();

  static const String get = "GET"; // 用于下载
  static const String create = "PUT"; // 用于上传
  static const String mkCol = "MKCOL"; // 用于创建目录或文件
  static const String acl = "ACL";
  static const String lock = "LOCK";
  static const String unLock = "UNLOCK";
  static const String move = "MOVE";
  static const String propFind = "PROPFIND"; // 用于搜索
  static const String propPatch = "PROPPATCH";
}
