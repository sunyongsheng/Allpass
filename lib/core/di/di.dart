import 'package:get_it/get_it.dart';

T inject<T extends Object>({
  String? instanceName,
  dynamic param1,
  dynamic param2,
}) {
  return GetIt.instance.get(
    instanceName: instanceName,
    param1: param1,
    param2: param2,
  );
}

T? injectOrNull<T extends Object>({
  String? instanceName,
  dynamic param1,
  dynamic param2,
}) {
  try {
    return inject(
      instanceName: instanceName,
      param1: param1,
      param2: param2,
    );
  } on AssertionError {
    return null;
  }
}
