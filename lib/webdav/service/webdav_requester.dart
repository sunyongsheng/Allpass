import 'dart:convert';
import 'dart:io';

import 'package:allpass/core/error/app_error.dart';
import 'package:allpass/webdav/model/webdav_file.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

class WebDavRequester {
  static const String root = "/";

  late Dio _dio;
  late String _basicAuth;
  late Map<String, dynamic> _baseHeaders;

  late String urlPath;
  late String username;
  late String password;
  late int port;

  bool _authChecked = false;

  CancelToken _authCancelToken = CancelToken();

  Map<String, List<WebDavFile>> _dirFilesCache = Map();

  WebDavRequester(
      {String? urlPath, int? port, String? username, String? password}) {
    _dio = Dio(BaseOptions(receiveTimeout: 30000));

    _baseHeaders = {"Depth": 1};
    this.urlPath = "https://";
    this.username = "";
    this.password = "";
    this.port = 443;

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

    if (port != null) {
      this.port = port;
    }
    // 若端口号比较特殊，则将其设置为 url:port/ 的形式，否则设置为 url/ 的形式
    if (urlPath != null) {
      if (!urlPath.endsWith("/")) {
        if (this.port != 443 && this.port != 80) {
          urlPath += ":$port/";
        } else {
          urlPath += "/";
        }
      } else {
        if (this.port != 443 && this.port != 80) {
          urlPath = urlPath.substring(0, urlPath.length - 1) + ":$port/";
        }
      }
      this.urlPath = urlPath;
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
        urlPath,
        options: Options(
          method: WebDAVMethods.propFind,
          headers: _baseHeaders,
        ),
        cancelToken: _authCancelToken,
      );
      if (_checkResponse(response.statusCode)) {
        List<WebDavFile> fileNames = [];
        XmlDocument.parse(response.data.toString().toLowerCase())
            .findAllElements("d:response")
            .map((e) => WebDavFile.parse(e))
            .forEach((file) {
          if (file != null) {
            fileNames.add(file);
          }
        });
        _dirFilesCache[root] = fileNames.sublist(1);
        _authChecked = true;
        return true;
      } else if (response.statusCode == 401) return false;
    } on DioError catch (e) {
      print(e.response?.data);
      print(e.stackTrace);
    }
    return false;
  }

  /// 创建目录，名为[dirName]，创建路径在根目录下
  Future<bool> createDir(String dirName) async {
    try {
      String newPath = urlPath + dirName;
      Response response = await _dio.request(
        newPath,
        options: Options(
          method: WebDAVMethods.mkCol,
          headers: _baseHeaders,
        ),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e.response?.data);
      print(e.stackTrace);
    }
    return false;
  }

  /// 列出文件夹[dirName]中的所有文件名，若目录为空返回[null]
  Future<List<WebDavFile>?> listFiles(String dirName) async {
    try {
      String fullPath = urlPath + dirName;
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
        XmlDocument.parse(data.toString().toLowerCase())
            .findAllElements("d:response")
            .map((e) => WebDavFile.parse(e))
            .forEach((file) {
          if (file != null) {
            allFiles.add(file);
          }
        });
        // 第一个元素为当前文件夹
        var files = allFiles.sublist(1);
        _dirFilesCache[dirName] = files;
        return files;
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e.response?.data);
      print(e.stackTrace);
      return null;
    }
  }

  /// [dirName]目录下是否含有[fileName]文件
  Future<bool> containsFile(
      {String dirName = root, required String fileName}) async {
    List<WebDavFile>? allFiles = _dirFilesCache[dirName];
    if (allFiles != null) {
      return allFiles.map((e) => e.filename).contains(fileName);
    } else {
      return (await listFiles(dirName))
              ?.map((e) => e.filename)
              .contains(fileName) ??
          false;
    }
  }

  /// 向文件夹[dirName]上传文件。若[dirName]为空，则默认为根目录
  /// Throws [DioError]/[FileSystemException]/[UnknownException]
  Future<String> uploadFile(
      {String dirName = root,
      required String fileName,
      required String filePath}) async {
    String uploadPath = _concatPath(dirName, fileName);
    File file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException("上传文件出错！文件不存在！", filePath);
    }

    var content = await file.readAsString();
    Response response = await _dio.put(uploadPath,
        data: content, options: Options(headers: _baseHeaders));
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
      return this.urlPath + fileName;
    } else {
      return this.urlPath + "$dirName/$fileName";
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
