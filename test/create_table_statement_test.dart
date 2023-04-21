import 'package:allpass/core/dao/table_definition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreateTableStatement', () {
    test('create() should return a valid SQL CREATE TABLE statement', () {
      final statement = CreateTableStatement(
        'users',
        [
          ColumnDefinition(
            name: 'id',
            type: ColumnType.integer,
            isPrimaryKey: true,
            isAutoIncrement: true,
          ),
          ColumnDefinition(
            name: 'name',
            type: ColumnType.text,
            isNotNull: true,
          ),
          ColumnDefinition(
            name: 'email',
            type: ColumnType.text,
            isNotNull: true,
            isUnique: true,
          ),
        ],
      );

      final sql = statement.create();
      print(sql);

      expect(
        sql,
        equals(
          'CREATE TABLE users ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'name TEXT NOT NULL, '
              'email TEXT NOT NULL UNIQUE'
              ')',
        ),
      );
    });
  });
}