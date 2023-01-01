import 'package:allpass/core/model/data/base_model.dart';

class ExtraModel extends BaseModel {
  final List<String> folderList;
  final List<String> labelList;

  ExtraModel(this.folderList, this.labelList);

  ExtraModel.fromJson(Map<String, dynamic> json)
      : folderList = json["folder"],
        labelList = json["label"];

  Map<String, dynamic> toJson() {
    return {"folder": folderList, "label": labelList};
  }
}
