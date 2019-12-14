/// 搜索框
// Container(
//   padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
//   child: ConstrainedBox(
//     constraints: BoxConstraints(maxHeight: 40),
//     child: Container(
//       padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
//       alignment: Alignment.center,
//       height: 60.0,
//       decoration: BoxDecoration(
//           color: Colors.grey[200],
//           border: null,
//           borderRadius: new BorderRadius.circular(25.0)),
//       child: TextFormField(
//         decoration: InputDecoration.collapsed(hintText: '搜索', hintStyle: AllpassTextUI.hintTextStyle),
//         controller: searchController,
//         style: AllpassTextUI.secondTitleStyleBlack,
//         onFieldSubmitted: (text) {
//           print("点击了搜索按钮：$text");
//         },
//       ),
//     ),
//   )
// ),

/// password_data.dart
// import 'package:allpass/model/password_bean.dart';
//
// /// 用于存储所有“密码”数据
// /// @author Aengus Sun
// class PasswordData {
//   // 保存所有的密码
//   static List<PasswordBean> passwordData = List();
//   // 保存每个密码的key
//   static Set<int> passwordKeySet = Set();
//
// }
//
// /// 更新特定key的PasswordBean
// void updatePasswordBean(PasswordBean res, int toUpdateKey) {
//   int index = -1;
//   for (int i = 0; i < PasswordData.passwordData.length; i++) {
//     if (toUpdateKey == PasswordData.passwordData[i].uniqueKey) {
//       index = i;
//       break;
//     }
//   }
//   // 以下这种方式修改的名称与用户名可以保存，但是其他数据修改保存再打开就会恢复
//   // PasswordData.passwordData[index] = reData;
//   copyPasswordBean(PasswordData.passwordData[index], res);
// }
//
// /// 删除特定key的PasswordBean
// void deletePasswordBean(int toDelKey) {
//   int index = -1;
//   for (int i = 0; i < PasswordData.passwordData.length; i++) {
//     if (toDelKey == PasswordData.passwordData[i].uniqueKey) {
//       index = i;
//       break;
//     }
//   }
//   PasswordData.passwordData.removeAt(index);
// }

/// card_data.dart
// import 'package:allpass/model/card_bean.dart';
//
// /// 用于存储所有“卡片”数据
// /// @author Aengus Sun
// class CardData {
//   // 保存所有卡片数据
//   static List<CardBean> cardData = List();
//   // 保存卡片唯一Key
//   static Set<int> cardKeySet = Set();
//
// }
//
// /// 更新特定key的CardBean
// void updateCardBean(CardBean res, int toUpdateKey) {
//   int index = -1;
//   for (int i = 0; i < CardData.cardData.length; i++) {
//     if (toUpdateKey == CardData.cardData[i].uniqueKey) {
//       index = i;
//       break;
//     }
//   }
//   copyCardBean(CardData.cardData[index], res);
// }
//
// /// 删除特定key的CardBean
// void deleteCardBean(int toDelKey) {
//   int index = -1;
//   for (int i = 0; i < CardData.cardData.length; i++) {
//     if (toDelKey == CardData.cardData[i].uniqueKey) {
//       index = i;
//       break;
//     }
//   }
//   CardData.cardData.removeAt(index);
// }

// ListTile(
// leading: CircleAvatar(
// backgroundColor: getRandomColor(cardBean.uniqueKey),
// child: Text(
// cardBean.name.substring(0, 1),
// style: TextStyle(color: Colors.white),
// ),
// ),
// title: Text(cardBean.name),
// subtitle: Text(cardBean.ownerName),
// onTap: () {
// print("点击了卡片：" + cardBean.name);
// _currentKey = cardBean.uniqueKey;
// // 显示模态BottomSheet
// showModalBottomSheet(
// context: context,
// builder: (BuildContext context) {
// return _createBottomSheet(context, cardBean);
// });
// },
// )

/// 参数初始化和持久化
// Directory appDocDir = await getApplicationDocumentsDirectory();
// appPath = appDocDir.path;
//
// final folderFile = File("$appPath/folder.appt"); // all_pass_plain_text
// if (!folderFile.existsSync()) {
//   folderFile.createSync();
// }
// String folder = folderFile.readAsStringSync();
// for (String f in folder.split(",")) {
//   if (f != "" && f != '~' && f != ',' && f != " ") folderList.add(f);
// }
//
// final labelFile = File("$appPath/label.appt");
// if (!labelFile.existsSync()) {
//   labelFile.createSync();
// }
// String label = labelFile.readAsStringSync();
// for (String l in label.split(",")) {
//   if (l != "" && l != '~' && l != ',' && l != " ") labelList.add(l);
// }

// final labelFile = File("$appPath/label.appt");
// String label = "";
// for (var s in labelList) {
//   label += s;
//   if (s != labelList.last) label += ",";
// }
// labelFile.writeAsStringSync(label, flush: true);

// final folderFile = File("$appPath/folder.appt");
// String folder = "";
// for (var s in folderList) {
//   folder += s;
//   if (s != folderList.last) folder += ",";
// }
// folderFile.writeAsStringSync(folder, flush: true);