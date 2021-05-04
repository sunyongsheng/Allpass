import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:xml/xml.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class WebDavUtil {

  static const String root = "/";

  Dio _dio;
  String _basicAuth;
  Map<String, String> _baseHeaders;

  String urlPath;
  String username;
  String password;
  int port;

  Map<String, List<String>> _dirFilenameCache = Map();

  WebDavUtil({String urlPath, int port, String username, String password}) {
    _dio = Dio(BaseOptions(receiveTimeout: 5000));
    _baseHeaders = Map();
    this.urlPath = "https://";
    this.username = "";
    this.password = "";
    this.port = 443;

    updateConfig(urlPath: urlPath, port: port, username: username, password: password);
  }

  void updateConfig({String urlPath, int port, String username, String password}) {
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
  Future<bool> authConfirm() async {
    try {
      Response response = await _dio.request(
          urlPath,
          options: Options(
            method: WebDAVMethods.propFind,
            headers: _baseHeaders,
          )
      );
      if (response.statusCode < 300) {
        List<String> fileNames = [];
        var xmlDoc = XmlDocument.parse(response.data);
        xmlDoc.findAllElements("d:displayname").map((e) => e.text).forEach((fileName) {
          if (fileName.isNotEmpty) {
            fileNames.add(fileName);
          }
        });
        _dirFilenameCache[root] = fileNames.sublist(1);
        return true;
      }
      else if (response.statusCode == 401) return false;
    } catch (e) {
      print(e.toString());
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
        )
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  /// 列出文件夹[dirName]中的所有文件名，若目录为空返回[null]
  Future<List<String>> listFilenames(String dirName) async {
    try {
      String fullPath = urlPath + dirName;
      Response<String> response = await _dio.request(
        fullPath,
        options: Options(
          method: WebDAVMethods.propFind,
          headers: _baseHeaders,
        )
      );
      List<String> fileNames = [];
      if (response.statusCode < 300) {
        var xmlDoc = XmlDocument.parse(response.data);
        xmlDoc.findAllElements("d:displayname").map((e) => e.text).forEach((fileName) {
          if (fileName.isNotEmpty) {
            fileNames.add(fileName);
          }
        });
        _dirFilenameCache[dirName] = fileNames.sublist(1);
        return fileNames;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// [dirName]目录下是否含有[fileName]文件
  Future<bool> containsFile(
      { String dirName = root,
        @required String fileName }) async {
    List<String> allFiles = _dirFilenameCache[dirName];
    if (allFiles != null) {
      return allFiles.contains(fileName);
    }
    return (await listFilenames(dirName))?.contains(fileName) ?? false;
  }

  /// 向文件夹[dirName]上传文件。若[dirName]为空，则默认为根目录
  Future<bool> uploadFile(
      { String dirName = root,
        @required String fileName,
        @required String filePath }) async {
    String uploadPath = _concatPath(dirName, fileName);
    File file = File(filePath);
    if (!file.existsSync()) throw FileSystemException("上传文件出错！文件不存在！", filePath);
    Response response = await _dio.put(
        uploadPath,
        data: file.readAsStringSync(),
        options: Options(headers: _baseHeaders));
    if (response.statusCode < 300) {
      if (_dirFilenameCache[dirName] != null) {
        _dirFilenameCache[dirName].add(fileName);
      }
      return true;
    }
    else return false;
    
  }

  /// 下载文件夹[dirName]中的文件。若[dirName]为空，则默认为根目录
  ///
  /// 返回保存路径，若下载失败则返回null
  Future<String> downloadFile(
      { String dirName = root,
        @required String fileName,
        String savePath }) async {
    String downloadUrl = _concatPath(dirName, fileName);
    String _savePath;
    if (savePath == null) {
      Directory appDir = await getApplicationDocumentsDirectory();
      _savePath = appDir.uri.toFilePath() + fileName;
    } else {
      _savePath = savePath;
    }
    try {
      Response<ResponseBody> response = await _dio.download(
          downloadUrl,
          _savePath,
          options: Options(
            headers: _baseHeaders
      ));
      if (response.statusCode < 300) {
        return _savePath;
      }
    } catch (e) {
      print("下载文件出错！错误信息：${e.toString()}");
    }
    return null;
  }

  void cancel() {
    _dio.clear();
  }

  String _concatPath(String dirName, String fileName) {
    if (dirName == null || dirName == root) {
      return this.urlPath + fileName;
    } else {
      return this.urlPath + "$dirName/$fileName";
    }
  }
}

class WebDAVMethods {
  WebDAVMethods._();

  static const String get = "GET";              // 用于下载
  static const String create = "PUT";           // 用于上传
  static const String mkCol = "MKCOL";          // 用于创建目录或文件
  static const String acl = "ACL";
  static const String lock = "LOCK";
  static const String unLock = "UNLOCK";
  static const String move = "MOVE";
  static const String propFind = "PROPFIND";    // 用于搜索
  static const String propPatch = "PROPPATCH";
}