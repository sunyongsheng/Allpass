import 'package:flutter/widgets.dart';

abstract class WebDavSyncService {

  /// 权限检查
  Future<bool> authCheck();

  /// 备份密码到指定的目录中
  Future<bool> backupPassword(BuildContext context);

  /// 备份卡片到指定的目录中
  Future<bool> backupCard(BuildContext context);

  /// 备份文件夹及标签
  Future<bool> backupFolderAndLabel(BuildContext context);

  /// 恢复密码到本地
  /// ！！！恢复密码时将会清除本地所有数据
  /// 0: 正常执行完毕
  /// 1: 插入云端数据时出错
  /// 2: 解析json出错，可能是网络原因
  Future<int> recoverPassword(BuildContext context);

  /// 恢复卡片到本地
  /// ！！！恢复卡片时将会清除本地所有数据
  /// 0: 正常执行完毕
  /// 1: 插入云端数据时出错
  /// 2: 解析json出错，可能是网络原因
  Future<int> recoverCard(BuildContext context);

  /// 恢复文件夹与密码
  Future<bool> recoverFolderAndLabel();
}