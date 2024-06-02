import 'package:allpass/database/db_provider.dart';
import 'package:allpass/database/table_definition.dart';

mixin CardTable on BaseDBProvider {

  /// 表名
  static final String name = "allpass_card";

  /// 表主键字段
  static final String columnId = "uniqueKey";

  /// 版本1列名
  static final String columnName = "name";
  static final String columnOwnerName = "ownerName";
  static final String columnCardId = "cardId";
  static final String columnPassword = "password";
  static final String columnTelephone = "telephone";
  static final String columnFolder  ="folder";
  static final String columnNotes = "notes";
  static final String columnLabel = "label";
  static final String columnFav = "fav";
  static final String columnCreateTime = "createTime";
  static final String columnSortNumber = "sortNumber";

  @override
  String tableName() {
    return name;
  }

  @override
  List<ColumnDefinition> tableColumns() {
    return [
      ColumnDefinition(
        name: columnId,
        type: ColumnType.integer,
        isPrimaryKey: true,
        isAutoIncrement: true,
      ),
      ColumnDefinition(
        name: columnName,
        type: ColumnType.text,
        isNotNull: true,
      ),
      ColumnDefinition(
        name: columnOwnerName,
        type: ColumnType.text,
      ),
      ColumnDefinition(
        name: columnCardId,
        type: ColumnType.text,
        isNotNull: true,
      ),
      ColumnDefinition(
        name: columnPassword,
        type: ColumnType.text,
      ),
      ColumnDefinition(
        name: columnTelephone,
        type: ColumnType.text,
      ),
      ColumnDefinition(
        name: columnFolder,
        type: ColumnType.text,
        defaultValue: "'默认'",
      ),
      ColumnDefinition(
        name: columnNotes,
        type: ColumnType.text,
      ),
      ColumnDefinition(
        name: columnLabel,
        type: ColumnType.text,
      ),
      ColumnDefinition(
        name: columnFav,
        type: ColumnType.integer,
        defaultValue: '0',
      ),
      ColumnDefinition(
        name: columnCreateTime,
        type: ColumnType.text,
      ),
      ColumnDefinition(
        name: columnSortNumber,
        type: ColumnType.integer,
        defaultValue: '-1',
      ),
    ];
  }

}