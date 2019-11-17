class CardBean {
  String name;      // 卡片名称
  String ownerName; // 卡片拥有者
  String cardId;    // 卡片ID/卡号
  String telephone; // 手机号
  String folder;    // 文件夹
  String label;     // 标签
  String notes;     // 备注

  CardBean(this.ownerName, this.cardId, {this.folder="default"}){
    if (name == null) {
      this.name = this.ownerName + "的卡片";
    }
  }
}