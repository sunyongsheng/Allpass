abstract class AuthService {

  /// 授权，返回[true]代表授权成功
  Future<bool> authenticate();

  /// 取消授权，返回[true]代表成功
  Future<bool> stopAuthenticate();

}