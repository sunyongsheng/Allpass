import 'package:allpass/core/dao/db_provider.dart';
import 'package:allpass/core/dao/table_definition.dart';

mixin PasswordTable on BaseDBProvider {
  /// 表名
  static final String name = "allpass_password";

  /// 表主键字段
  static final String columnId = "uniqueKey";

  /// 版本1列名
  static final String columnName = "name";
  static final String columnUsername = "username";
  static final String columnPassword = "password";
  static final String columnUrl = "url";
  static final String columnFolder = "folder";
  static final String columnNotes = "notes";
  static final String columnLabel = "label";
  static final String columnFav = "fav";
  /// 版本2列名
  static final String columnCreateTime = "createTime";
  /// 版本3列名
  static final String columnSortNumber = "sortNumber";
  /// 版本4列名
  static final String columnAppId = "appId";
  /// 版本5列名
  static final String columnAppName = "appName";

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
        name: columnUsername,
        type: ColumnType.text,
        isNotNull: true,
      ),
      ColumnDefinition(
        name: columnPassword,
        type: ColumnType.text,
        isNotNull: true,
      ),
      ColumnDefinition(
        name: columnUrl,
        type: ColumnType.text,
        isNotNull: true,
      ),
      ColumnDefinition(
        name: columnFolder,
        type: ColumnType.text,
        defaultValue: "默认",
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
      ColumnDefinition(
        name: columnAppId,
        type: ColumnType.text,
      ),
      ColumnDefinition(
        name: columnAppName,
        type: ColumnType.text,
      ),
    ];
  }
}