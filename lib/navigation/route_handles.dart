import 'package:allpass/home/home_page.dart';
import 'package:allpass/login/page/auth_login_page.dart';
import 'package:allpass/login/page/login_arguments.dart';
import 'package:allpass/login/page/login_page.dart';
import 'package:allpass/password/data/password_provider.dart';
import 'package:allpass/password/repository/password_memory_data_source.dart';
import 'package:allpass/password/repository/password_repository.dart';
import 'package:allpass/setting/import/import_preview_page.dart';
import 'package:allpass/util/csv_util.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';

/// 登录页
var loginHandler = Handler(
  handlerFunc: (context, params) {
    var arguments = context?.settings?.arguments as LoginArguments;
    return LoginPage(arguments: arguments);
  },
);

/// 生物识别登录页
var authLoginHandler = Handler(
  handlerFunc: (context, params) {
    var arguments = context?.settings?.arguments as LoginArguments;
    return AuthLoginPage(arguments: arguments);
  },
);

/// 主页
var homeHandler = Handler(
  handlerFunc: (context, params) => HomePage(),
);

var importDataHandler = Handler(handlerFunc: (context, params) {
  var data = context?.settings?.arguments.toString() ?? "";
  var dataSource = PasswordMemoryDataSource(
    dataProvider: () => CsvUtil.parsePasswordFromCsv(toParseText: data),
  );
  var passwordRepository = PasswordRepository(dataSource: dataSource);
  var passwordProvider = PasswordProvider(passwordRepository: passwordRepository);
  passwordProvider.init();
  return ChangeNotifierProvider.value(
    value: passwordProvider,
    child: ImportPreviewPage(data: data),
  );
});
