import 'package:allpass/card/data/card_repository.dart';
import 'package:allpass/core/param/constants.dart';
import 'package:allpass/core/service/allpass_service.dart';
import 'package:allpass/core/service/auth_service.dart';
import 'package:allpass/favicon/favicon_service.dart';
import 'package:allpass/password/repository/password_repository.dart';
import 'package:allpass/webdav/service/webdav_sync_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../core/di/di.dart';

class GetItInitializer {
  GetItInitializer._();

  static void initialize() {
    var getIt = GetIt.instance;

    getIt.registerLazySingleton<AuthService>(() => AuthServiceImpl());
    getIt.registerLazySingleton<AllpassService>(() => AllpassServiceImpl());
    getIt.registerLazySingleton<WebDavSyncService>(() => WebDavSyncServiceImpl());
    getIt.registerLazySingleton<FaviconService>(() => FaviconServiceImpl(inject()));

    getIt.registerSingleton(PasswordRepository());
    getIt.registerSingleton(CardRepository());

    getIt.registerFactory(() {
      var dio = _createDefaultDio();
      dio.options.baseUrl = allpassUrl;
      return dio;
    });

    getIt.registerFactory(_createDefaultDio, instanceName: "generic");
  }

  static Dio _createDefaultDio() {
    var dio = Dio(BaseOptions(
      receiveTimeout: Duration(seconds: 30),
      connectTimeout: Duration(seconds: 10),
    ));
    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      ));
    }
    return dio;
  }
}
