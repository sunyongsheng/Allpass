class CardBean {
  final int key;    // ID
  String name;      // 卡片名称
  String ownerName; // 卡片拥有者
  String cardId;    // 卡片ID/卡号
  int telephone;    // 手机号
  String folder;    // 文件夹
  String label;     // 标签
  String notes;     // 备注

  CardBean(this.key, this.ownerName, this.cardId, {this.folder, this.name, this.telephone, this.label, this.notes}){
    if (name == null) {
      this.name = this.ownerName + "的卡片";
    }

    if (folder == null) {
      this.folder = "默认";
    }

  }
}