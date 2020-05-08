import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class WebDavUtil {
  Dio _dio;
  String _basicAuth;
  Map<String, String> _baseHeaders;

  String urlPath;
  String username;
  String password;
  int port;

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
      if (response.statusCode < 300) return true;
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

  /// 列出文件夹[dirName]中的所有文件
  Future<Null> listFiles(String dirName) async {
    try {
      String fullPath = urlPath + dirName;
      Response response = await _dio.request(
        fullPath,
        options: Options(
          method: WebDAVMethods.propFind,
          headers: _baseHeaders,
        )
      );
      if (response.statusCode < 300) {
        // TODO 解析data(xml)
      }
      print(response.data.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  /// 向文件夹[dirName]上传文件。若[dirName]为空，则默认为根目录
  Future<Null> uploadFile({String dirName, @required String fileName}) async {
    String fullPath = concatPath(dirName, fileName);
    
  }

  /// 下载文件夹[dirName]中的文件。若[dirName]为空，则默认为根目录
  Future<bool> downloadFile({String dirName, @required String fileName}) async {
    String downloadUrl = concatPath(dirName, fileName);
    Directory appDir = await getApplicationDocumentsDirectory();
    String savePath = appDir.uri.toFilePath() + fileName;
    Response response = await _dio.download(downloadUrl, savePath);
    // TODO 保存文件

    if (response.statusCode < 300) return true;
    return false;
  }

  void cancel() {
    _dio.clear();
  }

  String concatPath(String dirName, String fileName) {
    if (dirName == null) {
      return this.urlPath + fileName;
    } else {
      return this.urlPath + "$dirName/$fileName";
    }
  }
}

class WebDAVMethods {
  WebDAVMethods._();

  static const String get = "GET";
  static const String mkCol = "MKCOL";
  static const String acl = "ACL";
  static const String lock = "LOCK";
  static const String unLock = "UNLOCK";
  static const String move = "MOVE";
  static const String propFind = "PROPFIND";
  static const String propPatch = "PROPPATCH";
}