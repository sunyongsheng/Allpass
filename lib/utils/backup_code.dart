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