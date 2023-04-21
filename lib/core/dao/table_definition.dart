enum ColumnType {
  integer,
  real,
  text,
  blob,
  boolean,
  date,
  time,
  datetime,
}

class ColumnDefinition {
  final String name;
  final ColumnType type;
  final bool isPrimaryKey;
  final bool isAutoIncrement;
  final bool isNotNull;
  final bool isUnique;
  final String? defaultValue;

  ColumnDefinition({
    required this.name,
    required this.type,
    this.isPrimaryKey = false,
    this.isAutoIncrement = false,
    this.isNotNull = false,
    this.isUnique = false,
    this.defaultValue,
  });

  String get typeString {
    switch (type) {
      case ColumnType.integer:
        return "INTEGER";
      case ColumnType.real:
        return "REAL";
      case ColumnType.text:
        return "TEXT";
      case ColumnType.blob:
        return "BLOB";
      case ColumnType.boolean:
        return "BOOLEAN";
      case ColumnType.date:
        return "DATE";
      case ColumnType.time:
        return "TIME";
      case ColumnType.datetime:
        return "DATETIME";
    }
  }

  String get definition {
    var definition = "$name $typeString";
    if (isPrimaryKey) {
      definition += " PRIMARY KEY";
    }
    if (isAutoIncrement) {
      definition += " AUTOINCREMENT";
    }
    if (isNotNull) {
      definition += " NOT NULL";
    }
    if (isUnique) {
      definition += " UNIQUE";
    }
    if (defaultValue != null) {
      switch (type) {
        case ColumnType.integer:
          try {
            int.parse(defaultValue!);
          } on FormatException {
            throw FormatException("The default value of an integer column must be an integer.");
          }
          break;
        case ColumnType.real:
          try {
            double.parse(defaultValue!);
          } on FormatException {
            throw FormatException("The default value of a real column must be a real number.");
          }
          break;
        case ColumnType.blob:
          throw FormatException("blob columns cannot have a default value.");
        case ColumnType.boolean:
          if (defaultValue != "0" && defaultValue != "1") {
            throw FormatException("The default value of a boolean column must be 0 or 1.");
          }
          break;
        case ColumnType.date:
        case ColumnType.datetime:
          try {
            DateTime.parse(defaultValue!);
          } on FormatException {
            throw FormatException("The default value of a date/time column must be a date/time.");
          }
          break;
        case ColumnType.time:
          try {
            DateTime.parse("1970-01-01 ${defaultValue!}");
          } on FormatException {
            throw FormatException("The default value of a time column must like HH:MM:SS.");
          }
          break;
        default:
          break;
      }
      definition += " DEFAULT $defaultValue";
    }
    return definition;
  }
}

class CreateTableStatement {
  final String tableName;
  final List<ColumnDefinition> columns;

  CreateTableStatement(this.tableName, this.columns);

  String create() {
    var columnDefinitions = columns.map((e) => e.definition).join(", ");
    return "CREATE TABLE $tableName ($columnDefinitions)";
  }
}
