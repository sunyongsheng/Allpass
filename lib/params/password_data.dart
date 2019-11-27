import 'package:allpass/model//password_bean.dart';

/// 用于存储所有“密码”数据
/// @author Aengus Sun
class PasswordData {
  // 保存所有的密码
  static List<PasswordBean> passwordData = List();
  // 保存每个密码的key
  static Set<int> passwordKeySet = Set();

}

/// 更新特定key的PasswordBean
void updatePasswordBean(PasswordBean res, int toUpdateKey) {
  int index = -1;
  for (int i = 0; i < PasswordData.passwordData.length; i++) {
    if (toUpdateKey == PasswordData.passwordData[i].uniqueKey) {
      index = i;
      break;
    }
  }
  // TODO 以下这种方式修改的名称与用户名可以保存，但是其他数据修改保存再打开就会恢复
  // PasswordData.passwordData[index] = reData;
  copyPasswordBean(PasswordData.passwordData[index], res);
}

/// 删除特定key的PasswordBean
void deletePasswordBean(int toDelKey) {
  int index = -1;
  for (int i = 0; i < PasswordData.passwordData.length; i++) {
    if (toDelKey == PasswordData.passwordData[i].uniqueKey) {
      index = i;
      break;
    }
  }
  PasswordData.passwordData.removeAt(index);
}